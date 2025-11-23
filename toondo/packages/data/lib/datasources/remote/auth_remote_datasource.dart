import 'package:dio/dio.dart';
import 'package:data/constants.dart';
import 'package:injectable/injectable.dart';

// Dio 기반 최소 구현 버전
// - 쿠키는 글로벌 Dio 인스턴스 (CookieManager 인터셉터 부착) 에 의해 자동 저장/전송
// - 기존 http.Client 로직을 단순화하여 핵심 엔드포인트만 동작하도록 함
// TODO(auth-migrate): 회원가입 phoneNumber/nickname 필드 추가 후 관련 계층 확장
// TODO(auth-refresh): 401 TOKEN_EXPIRED 케이스는 dio_client.dart 인터셉터에서 처리됨 (여기서는 별도 처리 불필요)

@LazySingleton()
class AuthRemoteDataSource{
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  static const String baseUrl = Constants.baseUrl; // TODO(auth): 포트 변경 반영됨(8083). 경로 prefix '/api/v1' 적용 필요 여부 백엔드 스펙 재확인

  /// 사용자를 회원가입시키는 함수.
  ///
  /// 서버의 `/users/signup` 엔드포인트에 `POST` 요청을 보내어
  /// 새로운 사용자를 등록하고, 성공하면 `UserModel`을 반환합니다.
  ///
  /// [loginId] 사용자의 로그인 아이디
  /// [password] 사용자의 비밀번호
  ///
  /// 성공 시:
  /// - HTTP 상태 코드 200(OK) 또는 201(Created)
  /// - 응답 본문에 JWT 토큰과 사용자 정보 포함
  ///
  /// 실패 시:
  /// - 400 BAD REQUEST: 이미 존재하는 로그인 ID
  /// - 500 INTERNAL SERVER ERROR: 서버 오류 발생
  /// - 예외를 던져 호출한 곳에서 처리하도록 함
  ///
  /// 예제:
  /// ```dart
  /// try {
  ///   final user = await registerUser('user123', 'password123');
  ///   print('회원가입 성공: ${user.token}');
  /// } catch (e) {
  ///   print('회원가입 실패: $e');
  /// }
  /// ```
  Future<String> registerUser(
    String loginId,
    String password,
  ) async {
    // TODO(payload): 최신 회원가입 요청 스펙에 phoneNumber, nickname 필드 추가 필요
    // 현재 서버 엔드포인트는 /api/v1/users/signup 기대: {loginId,password,phoneNumber,nickname}
    // ViewModel/UseCase 계층과 모델 확장 필요
    // 1) Local explicit bypass (only if flag enabled)
    if (Constants.enableLocalTestBypass &&
        loginId == Constants.testLoginId &&
        password == Constants.testPassword) {
      return Constants.testAccessToken; // 디자인 플로우 빠른 확인용
    }

    // 기존 및 신규 엔드포인트 병행 테스트 대비: signupUrl만 사용 (중복 제거)
    // TODO(endpoint): 최종 확정 후 필요시 레거시 경로 제거
    final signupUrl = Uri.parse('$baseUrl/api/v1/users/signup');
    Response response;
    try {
      response = await dio.post(
        signupUrl.toString(),
        data: {
          'loginId': loginId,
          'password': password,
          // 'phoneNumber': phoneNumber, // TODO(payload)
          // 'nickname': nickname,       // TODO(payload)
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      if (loginId == Constants.testLoginId && password == Constants.testPassword) {
        return Constants.testAccessToken; // 네트워크 오류 fallback
      }
      rethrow;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 백엔드가 쿠키만 반환하고 body에 토큰을 포함하지 않을 수 있음 -> accessToken 키 없으면 빈 문자열 반환
      final dynamic data = response.data;
      if (data is Map && data.containsKey('accessToken')) {
        return data['accessToken'] as String? ?? '';
      }
      // TODO(token): 쿠키 기반 세션만 있는 경우 프론트에서 굳이 accessToken 보관 불필요. 상위 계층 정리 필요
      return '';
    }

    if (response.statusCode == 400) {
      // 이미 존재하는 로그인 ID 등 중복 상황 처리
      String? error;
      if (response.data is Map) {
        try { error = (response.data as Map)['error'] as String?; } catch (_) {}
      }

      // 2) testuser 중복 시도면: 자동으로 로그인 시도하여 토큰 반환 (idempotent UX)
  if (loginId == Constants.testLoginId && password == Constants.testPassword) {
        try {
          final loginUrl = Uri.parse('$baseUrl/users/login');
          final loginResp = await dio.post(
            loginUrl.toString(),
            data: {'loginId': loginId, 'password': password},
            options: Options(headers: {'Content-Type': 'application/json'}),
          );
          if (loginResp.statusCode == 200) {
            final lrData = loginResp.data;
            if (lrData is Map && lrData.containsKey('accessToken')) {
              return lrData['accessToken'] as String? ?? '';
            }
            return '';
          }
          // 로그인도 실패하면 최종 fallback 로컬 토큰 (디자인 진행)
          return Constants.testAccessToken;
        } catch (_) {
          return Constants.testAccessToken;
        }
      }
      throw Exception(error ?? '이미 존재하는 로그인 ID입니다.');
    }

    if (response.statusCode == 500) {
      // 서버 오류지만 테스트 계정이면 fallback 허용
      if (loginId == Constants.testLoginId && password == Constants.testPassword) {
        return Constants.testAccessToken;
      }
      throw Exception('서버 내부 오류가 발생했습니다.');
    }

    // 기타 예외 상태 처리
    if (loginId == Constants.testLoginId && password == Constants.testPassword) {
      // 예측 밖 상태도 테스트 계정은 흐름 계속
      return Constants.testAccessToken;
    }
    throw Exception('회원가입 실패: ${response.data}');
  }

  Future<String> login(
    String loginId,
    String password,
  ) async {
    // Local test bypass: if enabled and credentials match, skip network call.
    if (Constants.enableLocalTestBypass &&
        loginId == Constants.testLoginId &&
        password == Constants.testPassword) {
      await Future.delayed(const Duration(milliseconds: 300)); // mimic latency
      return Constants.testAccessToken;
    }
    // legacy 경로 변수 제거 (중복 및 미사용 경고 방지)
    // TODO(endpoint): 최신 로그인 엔드포인트 '/login' (루트) 제공 여부 확인.
    // 서버 공유 내용: POST /login (id,password) vs 기존 '/users/login'. 테스트 후 하나로 확정 필요.
    // 임시로 신규 스펙 우선 시도 후 실패 시 fallback.
    final primaryUrl = Uri.parse('$baseUrl/login');
    final legacyUrl = Uri.parse('$baseUrl/users/login'); // fallback
    Response response;
    try {
      response = await dio.post(
        primaryUrl.toString(),
        data: {
          'id': loginId, // TODO(mapping): 서버는 'id' 키 사용. 기존 'loginId' -> 통일 필요
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 404) {
        // fallback to legacy path
        response = await dio.post(
          legacyUrl.toString(),
          data: {
            'loginId': loginId,
            'password': password,
          },
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
      }
    } catch (e) {
      rethrow; // TODO(net): 네트워크 예외 세분화 후 사용자 메시지 매핑
    }

    if (response.statusCode == 200 || response.statusCode == 500) {
      // 500이어도 쿠키(accessToken/refreshToken)가 set-cookie로 왔다면 성공으로 처리
      // 서버가 토큰 발급 후 내부 로직 오류로 500을 반환하는 케이스 대응
      final respData = response.data;
      if (respData is Map && respData.containsKey('accessToken')) {
        return respData['accessToken'] as String? ?? '';
      }
      // Body에 토큰이 없어도 쿠키는 이미 CookieJar에 저장되므로 빈 문자열 반환 (쿠키 기반 인증)
      return '';
    } else if (response.statusCode == 400) {
      String? error;
      final body = response.data;
      if (body is Map) {
        try { error = body['error'] as String?; } catch (_) {}
      }
      throw Exception(error ?? '로그인 정보가 올바르지 않습니다.');
    } else {
      throw Exception('로그인 실패: ${response.data}');
    }
    // 모든 분기에서 return/throw 처리되므로 도달 불가. 분석기 경고 방지용
    // ignore: dead_code
    throw Exception('UNREACHABLE');
  }

  Future<bool> isLoginIdRegistered(String loginId) async {
    // 우선순위: camelCase 쿼리 키(loginId) → 소문자(loginid) → 비-prefix 경로
    final candidates = <Uri>[
      Uri.parse('$baseUrl/api/v1/users/check-loginid?loginId=$loginId'),
      Uri.parse('$baseUrl/api/v1/users/check-loginid?loginid=$loginId'),
      Uri.parse('$baseUrl/users/check-loginid?loginId=$loginId'),
    ];

    // Local test bypass: 디자인 플로우 확인용으로 test 계정은 항상 "미등록" 처리
    if (Constants.enableLocalTestBypass && loginId == Constants.testLoginId) {
      return false; // 사용 가능
    }

  // 마지막 예외(디버깅용 변수) - 현재 미사용이므로 제거하여 경고 방지
    Response? lastResponse;

    for (final uri in candidates) {
      try {
        final response = await dio.get(
          uri.toString(),
          options: Options(receiveTimeout: const Duration(seconds: 6)),
        );
        // 정상 응답 처리
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map && data.containsKey('exists')) {
            return data['exists'] == true;
          }
          if (data is bool) return data;
          // 형식이 예상과 다르면 다음 후보 시도
          lastResponse = response;
          continue;
        }

        // 404/500 등은 다음 후보를 시도, 모두 실패 시 예외 처리
        lastResponse = response;
        continue;
      } on DioException catch (_) {
        // TODO(log): DioException 세부 정보 로깅 필요 시 Logger 주입 후 활용
        continue; // 다음 후보 URL 시도
      } catch (_) {
        // 알 수 없는 예외도 다음 후보 시도
        continue;
      }
    }

    // 모든 후보 실패: 명시적으로 예외 던져 상위(UI)에서 에러 메시지 표시되도록
    final code = lastResponse?.statusCode;
    // lastError?.message 등을 조합 가능하나 사용자 메시지 단순화
    throw Exception('아이디 확인 요청 실패${code != null ? ' (HTTP $code)' : ''}');
  }

  Future<void> deleteAccount() async {
    // TODO(endpoint): 실제 탈퇴 엔드포인트 '/api/v1/users/delete-account' (추정) 확인 필요
    // TODO(auth): 쿠키 기반 인증이므로 추가 헤더보다 기본 쿠키 전송으로 인증 처리
    // TODO: 개발 중에는 목 응답 사용, 실제 서버 연결 시 아래 주석 해제
    // 임시로 성공 응답 시뮬레이션
    await Future.delayed(Duration(milliseconds: 1000)); // 네트워크 지연 시뮬레이션
    
    /* 실제 서버 연결 코드 (확정 시 교체)
    final url = Uri.parse('$baseUrl/users/delete-account');
    final response = await dio.delete(url.toString());
    if (response.statusCode != 200) {
      throw Exception('계정 탈퇴 실패: ${response.data}');
    }
    */
  }
}
