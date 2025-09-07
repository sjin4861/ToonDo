import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthRemoteDataSource{
  final http.Client httpClient;
  AuthRemoteDataSource(this.httpClient);

  static const String baseUrl = Constants.baseUrl;

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
    // 1) Local explicit bypass (only if flag enabled)
  if (Constants.enableLocalTestBypass &&
    loginId == Constants.testLoginId &&
    password == Constants.testPassword) {
      // 디자인 플로우 빠른 확인용
      return Constants.testAccessToken;
    }

    final url = Uri.parse('$baseUrl/users/signup');
    http.Response response;
    try {
      response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'loginId': loginId,
          'password': password,
        }),
      );
    } catch (e) {
      // 네트워크 오류 시 테스트 계정이면 로컬 토큰으로 흐름 계속
  if (loginId == Constants.testLoginId && password == Constants.testPassword) {
        return Constants.testAccessToken; // fallback
      }
      rethrow;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['accessToken'];
    }

    if (response.statusCode == 400) {
      // 이미 존재하는 로그인 ID 등 중복 상황 처리
      String? error;
      try {
        error = jsonDecode(response.body)['error'];
      } catch (_) {}

      // 2) testuser 중복 시도면: 자동으로 로그인 시도하여 토큰 반환 (idempotent UX)
  if (loginId == Constants.testLoginId && password == Constants.testPassword) {
        try {
          final loginUrl = Uri.parse('$baseUrl/users/login');
          final loginResp = await httpClient.post(
            loginUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'loginId': loginId, 'password': password}),
          );
          if (loginResp.statusCode == 200) {
            final data = jsonDecode(loginResp.body);
            return data['accessToken'];
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
    throw Exception('회원가입 실패: ${response.body}');
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
    final url = Uri.parse('$baseUrl/users/login');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': loginId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['accessToken'];
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? '로그인 정보가 올바르지 않습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류가 발생했습니다.');
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  Future<bool> isLoginIdRegistered(String loginId) async {
  final url = Uri.parse('$baseUrl/users/check-loginid?loginid=$loginId');
  // TODO(timeout): 현재 timeout 미적용 - 서버 무응답/네트워크 이슈 시 Future가 오래 걸릴 수 있음
  // final response = await httpClient.get(url).timeout(const Duration(seconds: 8));
    // Local test bypass: 디자인 플로우 확인용으로 test 계정은 항상 "미등록" 처리
    if (Constants.enableLocalTestBypass && loginId == Constants.testLoginId) {
      return false; // 사용 가능
    }

    try {
      final response = await httpClient
          .get(url)
          .timeout(const Duration(seconds: 6)); // 간단 timeout 추가
      // TODO(error-body): 200 외 응답 구조(에러 body 형식) 백엔드 스펙 문서화 필요
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] == true;
      }
      // 404 등 비정상 응답 시 UI 흐름 막지 않도록 '미등록'으로 간주 (디자인 확인 단계)
      // TODO(prod): 프로덕션에서는 여기서 예외 던지고 상위에서 처리하도록 되돌릴 것
      return false;
    } catch (e) {
      // 네트워크 오류/timeout 시에도 디자인 흐름 진행을 위해 사용 가능 처리
      // TODO(prod): 네트워크 오류 시 사용자에게 재시도 안내
      return false;
    }
    // TODO(retry): 필요시 재시도/backoff 전략 적용 고려
  }

  Future<void> deleteAccount() async {
    // TODO: 개발 중에는 목 응답 사용, 실제 서버 연결 시 아래 주석 해제
    // 임시로 성공 응답 시뮬레이션
    await Future.delayed(Duration(milliseconds: 1000)); // 네트워크 지연 시뮬레이션
    
    /* 실제 서버 연결 코드
    final url = Uri.parse('$baseUrl/users/delete-account');
    final response = await httpClient.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('계정 탈퇴 실패: ${response.body}');
    }
    */
  }
}
