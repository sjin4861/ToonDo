import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:data/constants.dart';

class DioClient {
  final Dio dio;
  final CookieJar cookieJar;

  DioClient._(this.dio, this.cookieJar);

  factory DioClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        headers: {
          'Content-Type': 'application/json',
        },
        // Important for cookie-based JWT on web/desktop
        validateStatus: (code) => code != null && code >= 200 && code < 600,
      ),
    );

    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(_AccessTokenAttachInterceptor(cookieJar));
    dio.interceptors.add(_AuthInterceptor(dio, cookieJar));
    dio.interceptors.add(LogInterceptor(
      request: false, responseBody: false, requestBody: false,
    ));

    return DioClient._(dio, cookieJar);
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  final CookieJar _cookieJar;
  Completer<void>? _refreshCompleter;

  _AuthInterceptor(this._dio, this._cookieJar);

  bool _isRefreshEndpoint(String path) => path.contains('/auth/refreshToken');

  bool _shouldAttemptRefresh(Response? res, RequestOptions req) {
    if (res?.statusCode != 401) return false;
    if (_isRefreshEndpoint(req.path)) return false; // refresh 자기 자신은 재시도 X
    if (req.extra['__refreshAttempted'] == true) return false; // 이미 한 번 시도
    // errorCode == TOKEN_EXPIRED 이거나, body에 TOKEN_EXPIRED 문자열 포함, 혹은 errorCode 누락된 401 모두 시도 (쿠키 기반이므로 무해)
    final data = res?.data;
    if (data is Map && data['errorCode'] == 'TOKEN_EXPIRED') return true;
    final bodyStr = data?.toString() ?? '';
    if (bodyStr.contains('TOKEN_EXPIRED')) return true;
    // 마지막: accessToken/refreshToken 쿠키 둘 다 있으면 한 번 갱신 시도해볼 가치 있음
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
    // 이미 refreshing flag는 외부에서 설정됨
    final candidates = <String>[
      '/api/v1/auth/refreshToken',
      '/api/v1/auth/refresh-token',
      '/auth/refreshToken',
      '/auth/refresh-token',
    ];

    // 현재 쿠키 상태 출력
    try {
      final baseUri = Uri.parse(Constants.baseUrl);
      final currentCookies = await _cookieJar.loadForRequest(baseUri);
      // ignore: avoid_print
      print('[AuthInterceptor] Cookies before refresh: ' +
          currentCookies.map((c) => '${c.name}=${c.value.substring(0, c.value.length > 12 ? 12 : c.value.length)}...').join(', '));
    } catch (_) {}

    Response? successResp;
    DioException? lastError;
    for (final path in candidates) {
      try {
        final resp = await _dio.post(
          path,
          options: Options(extra: {'__skipAuthAttach': true}),
        );
        if (resp.statusCode == 200) {
          successResp = resp;
          break;
        } else {
          // ignore: avoid_print
          print('[AuthInterceptor] Refresh candidate $path failed code=${resp.statusCode}');
        }
      } on DioException catch (e) {
        lastError = e;
        // ignore: avoid_print
        print('[AuthInterceptor] Refresh candidate error $path: ${e.response?.statusCode}');
      }
    }

    if (successResp != null) {
      // ignore: avoid_print
      print('[AuthInterceptor] Refresh success path=${successResp.requestOptions.path}');
      try {
        final baseUri = Uri.parse(Constants.baseUrl);
        final afterCookies = await _cookieJar.loadForRequest(baseUri);
        // ignore: avoid_print
        print('[AuthInterceptor] Cookies after refresh: ' +
            afterCookies.map((c) => '${c.name}=${c.value.substring(0, c.value.length > 12 ? 12 : c.value.length)}...').join(', '));
      } catch (_) {}
      _refreshCompleter?.complete();
    } else {
      await _cookieJar.deleteAll();
      _refreshCompleter?.completeError(Exception('All refresh candidates failed${lastError != null ? ': ${lastError.message}' : ''}'));
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
  final CookieJar _cookieJar;
  _AccessTokenAttachInterceptor(this._cookieJar);

  static final _jwtRegex = RegExp(r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // refresh 토큰 엔드포인트는 Authorization 헤더를 붙이지 않는다 (쿠키 기반 갱신 전용)
    if (options.path.contains('/auth/refreshToken') || options.extra['__skipAuthAttach'] == true) {
      handler.next(options);
      return;
    }
    // 이미 Authorization 있으면 패스
    if (!options.headers.containsKey('Authorization')) {
      try {
        final uri = options.uri;
        final cookies = await _cookieJar.loadForRequest(uri);
        final access = cookies.firstWhere(
          (c) => c.name == 'accessToken',
          orElse: () => Cookie('accessToken', ''),
        );
        if (access.value.isNotEmpty && _jwtRegex.hasMatch(access.value)) {
          options.headers['Authorization'] = 'Bearer ${access.value}';
          // ignore: avoid_print
          print('[AccessTokenAttach] Authorization 헤더 자동 부착');
        }
      } catch (_) {
        // ignore silently
      }
    }
    handler.next(options);
  }
}
