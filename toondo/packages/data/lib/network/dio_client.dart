import 'dart:async';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:data/constants.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/network/mock_api_interceptor.dart';

class DioClient {
  final Dio dio;
  final CookieJar cookieJar;

  DioClient._(this.dio, this.cookieJar);

  factory DioClient.create({required SecureLocalDataSource secureLocalDataSource}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        headers: {
          'Content-Type': 'application/json',
        },
        // We still allow non-2xx through to interceptors (refresh handling)
        validateStatus: (code) => code != null && code >= 200 && code < 600,
      ),
    );

    final cookieJar = CookieJar();
    
    // Mock 인터셉터는 가장 먼저 추가 (다른 인터셉터보다 우선 실행)
    if (Constants.useMockApi) {
      dio.interceptors.add(MockApiInterceptor());
    }
    
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(_AccessTokenAttachInterceptor(secureLocalDataSource));
    dio.interceptors.add(_AuthInterceptor(dio, secureLocalDataSource));
    dio.interceptors.add(LogInterceptor(
      request: false, responseBody: false, requestBody: false,
    ));

    return DioClient._(dio, cookieJar);
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureLocalDataSource _secure;
  Completer<void>? _refreshCompleter;

  _AuthInterceptor(this._dio, this._secure);

  static const _refreshPath = '/api/v1/auth/refreshToken';

  bool _isRefreshEndpoint(String path) => path == _refreshPath;

  bool _shouldAttemptRefresh(Response? res, RequestOptions req) {
    if (res?.statusCode != 401) return false;
    if (_isRefreshEndpoint(req.path)) return false; // refresh 자기 자신은 재시도 X
    if (req.extra['__refreshAttempted'] == true) return false; // 이미 한 번 시도
    // Spec-based: any 401 can attempt refresh once.
    return true;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final res = err.response;
    final reqOptions = err.requestOptions;

    if (!_shouldAttemptRefresh(res, reqOptions)) {
      handler.next(err);
      return;
    }

    // 이미 새로고침 중이면 해당 Future 완료까지 대기
    if (_refreshCompleter != null) {
      try {
        await _refreshCompleter!.future;
      } catch (_) {
        handler.next(err); // refresh 실패 전달
        return;
      }
    } else {
      // 새로고침 시작
      _refreshCompleter = Completer<void>();
      try {
        reqOptions.extra['__refreshAttempted'] = true;
        // ignore: avoid_print
        print('[AuthInterceptor] Refresh start (from onError)');
        await _attemptRefresh();
      } catch (e) {
        // ignore: avoid_print
        print('[AuthInterceptor] Refresh exception: $e');
      }
      // 새로고침 cycle 종료 후 재사용 방지
      final c = _refreshCompleter;
      _refreshCompleter = null;
      try {
        await c!.future; // 실패 시 catch 블록에서 err 전달
      } catch (_) {
        handler.next(err);
        return;
      }
    }

    // 새 토큰(쿠키) 적용되었으니 원 요청 재시도
    try {
      final cloned = _copyRequestOptions(reqOptions);
      final response = await _dio.fetch(cloned);
      handler.resolve(response);
    } catch (e) {
      // 재시도도 실패 → 원본 에러 통과
      handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // validateStatus 가 401을 통과시키는 설정인 경우 onError 가 아닌 onResponse 로 들어옴
    final req = response.requestOptions;
    if (!_shouldAttemptRefresh(response, req)) {
      handler.next(response);
      return;
    }

    // 아래 로직은 onError 와 동일: refresh 동기화 후 원 요청 재시도
    if (_refreshCompleter != null) {
      try {
        await _refreshCompleter!.future;
      } catch (_) {
        handler.next(response);
        return;
      }
    } else {
      _refreshCompleter = Completer<void>();
      try {
        req.extra['__refreshAttempted'] = true;
        // ignore: avoid_print
        print('[AuthInterceptor] Refresh start (from onResponse)');
        await _attemptRefresh();
      } catch (e) {
        // ignore: avoid_print
        print('[AuthInterceptor] Refresh exception: $e');
      }
      final c = _refreshCompleter;
      _refreshCompleter = null;
      try {
        await c!.future;
      } catch (_) {
        handler.next(response);
        return;
      }
    }

    try {
      final cloned = _copyRequestOptions(response.requestOptions);
      final retried = await _dio.fetch(cloned);
      handler.resolve(retried);
    } catch (_) {
      handler.next(response);
    }
  }

  Future<void> _attemptRefresh() async {
    final refreshToken = await _secure.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _secure.clearAuthTokens();
      _refreshCompleter?.completeError(Exception('No refresh token'));
      return;
    }

    try {
      // Spec: GET /api/v1/auth/refreshToken with Authorization: Bearer {refreshToken}
      final resp = await _dio.get(
        _refreshPath,
        options: Options(
          extra: {'__skipAuthAttach': true},
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      if (resp.statusCode == 200 && resp.data is Map) {
        final map = Map<String, dynamic>.from(resp.data as Map);
        final newAccess = map['accessToken'] as String?;
        final newRefresh = map['refreshToken'] as String?;
        if (newAccess == null || newAccess.isEmpty || newRefresh == null || newRefresh.isEmpty) {
          await _secure.clearAuthTokens();
          _refreshCompleter?.completeError(Exception('Refresh response missing tokens'));
          return;
        }
        await _secure.saveAccessToken(newAccess);
        await _secure.saveRefreshToken(newRefresh);
        _refreshCompleter?.complete();
        return;
      }

      await _secure.clearAuthTokens();
      _refreshCompleter?.completeError(Exception('Refresh failed (HTTP ${resp.statusCode})'));
    } on DioException catch (e) {
      await _secure.clearAuthTokens();
      _refreshCompleter?.completeError(Exception('Refresh error: ${e.response?.statusCode ?? ''} ${e.message}'));
    }
  }

  RequestOptions _copyRequestOptions(RequestOptions original) {
    return RequestOptions(
      path: original.path,
      method: original.method,
      baseUrl: original.baseUrl,
      data: original.data,
      queryParameters: Map<String, dynamic>.from(original.queryParameters),
      headers: Map<String, dynamic>.from(original.headers),
      extra: Map<String, dynamic>.from(original.extra),
      contentType: original.contentType,
      followRedirects: original.followRedirects,
      listFormat: original.listFormat,
      maxRedirects: original.maxRedirects,
      receiveDataWhenStatusError: original.receiveDataWhenStatusError,
      requestEncoder: original.requestEncoder,
      responseDecoder: original.responseDecoder,
      responseType: original.responseType,
      sendTimeout: original.sendTimeout,
      receiveTimeout: original.receiveTimeout,
      validateStatus: original.validateStatus,
    );
  }
}

class _AccessTokenAttachInterceptor extends Interceptor {
  final SecureLocalDataSource _secure;
  _AccessTokenAttachInterceptor(this._secure);

  static final _jwtRegex = RegExp(r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$');
  bool _printedClaims = false;

  Map<String, dynamic>? _decodeJwtClaims(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String normalized = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      final payload = String.fromCharCodes(base64.decode(normalized));
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 전역 플래그로 Authorization 자동 부착을 임시 비활성화할 수 있음 (쿠키만 사용하여 문제 원인 격리)
    // ignore: avoid_print
    print('[AccessTokenAttach] flags: disableAuthHeaderAttach=' +
        '${Constants.disableAuthHeaderAttach} useCustomUserIdHeader=${Constants.useCustomUserIdHeader} path=${options.path}');
    if (Constants.disableAuthHeaderAttach == true) {
      handler.next(options);
      return;
    }
    // refresh 요청 또는 명시적 skip
    if (options.path == _AuthInterceptor._refreshPath || options.extra['__skipAuthAttach'] == true) {
      handler.next(options);
      return;
    }
    // 이미 Authorization 있으면 패스
    if (!options.headers.containsKey('Authorization')) {
      try {
        final accessToken = await _secure.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty && _jwtRegex.hasMatch(accessToken)) {
          if (!_printedClaims) {
            final claims = _decodeJwtClaims(accessToken);
          if (claims != null) {
            // ignore: avoid_print
            print('[AccessTokenAttach] accessToken claims: ' + claims.toString());
          }
          _printedClaims = true;
          }
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      } catch (_) {
        // ignore silently
      }
    }
    // 실험용 사용자 숫자 ID 헤더 부착 (옵션)
    if (Constants.useCustomUserIdHeader == true) {
      options.headers[Constants.customUserIdHeader] = Constants.testUserNumericId.toString();
      // ignore: avoid_print
      print('[AccessTokenAttach] added custom user header ${Constants.customUserIdHeader}=${Constants.testUserNumericId}');
    }
    handler.next(options);
  }
}
