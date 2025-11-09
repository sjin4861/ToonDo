import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:data/constants.dart';

/// 간단 라우트 매칭 정보
// 테스트 내부에서만 사용하는 단순 라우트 구조체
// public 으로 노출되어 library_private_types_in_public_api 경고 제거
class MockRoute {
  final String method;
  final String path; // baseUrl 이후 경로 (query 포함)
  final int statusCode;
  final dynamic data;
  MockRoute(this.method, this.path, this.statusCode, this.data);
}

/// 요청을 사전 정의된 라우트로 해석해 Response를 반환하는 Interceptor 기반 Mock Dio
Dio createMockDio(List<MockRoute> routes) {
  final dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    final match = routes.firstWhere(
      (r) =>
          r.method.toUpperCase() == options.method.toUpperCase() &&
          r.path == options.path,
      orElse: () => MockRoute('NONE', 'NONE', 599, {'error': 'NOT_MATCHED'}),
    );
    if (match.statusCode == 599) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 404,
        data: {'error': 'Route not found: ${options.path}'},
      ));
    }
    return handler.resolve(Response(
      requestOptions: options,
      statusCode: match.statusCode,
      data: match.data,
    ));
  }));
  return dio;
}

void main() {
  group('AuthRemoteDataSource (Dio)', () {
    group('registerUser', () {
      test('회원가입 성공 시 토큰 반환', () async {
        final dio = createMockDio([
          MockRoute('POST', '/api/v1/users/signup', 201, {
            'accessToken': 'test_token_123'
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        final result = await dataSource.registerUser('testuser', 'testpass');
        expect(result, 'test_token_123');
      });

      test('이미 존재하는 ID로 회원가입 시 예외 발생', () async {
        final dio = createMockDio([
          MockRoute('POST', '/api/v1/users/signup', 400, {
            'error': 'Already exists loginId'
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.registerUser('existinguser', 'testpass'),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString().contains('Already exists loginId'))),
        );
      });

      test('서버 오류 시 예외 발생', () async {
        final dio = createMockDio([
          MockRoute('POST', '/api/v1/users/signup', 500, 'Internal Server Error'),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.registerUser('testuser', 'testpass'),
          throwsA(predicate((e) =>
              e is Exception && e.toString().contains('서버 내부 오류가 발생했습니다'))),
        );
      });

      test('기타 오류 시 예외 발생', () async {
        final dio = createMockDio([
          MockRoute('POST', '/api/v1/users/signup', 401, 'Bad Request'),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.registerUser('testuser', 'testpass'),
          throwsA(predicate((e) =>
              e is Exception && e.toString().contains('회원가입 실패'))),
        );
      });
    });

    group('login', () {
      test('신규 경로 404 후 레거시 경로 성공 시 토큰 반환', () async {
        final dio = createMockDio([
          MockRoute('POST', '/login', 404, {'error': 'Not Found'}),
          MockRoute('POST', '/users/login', 200, {
            'accessToken': 'login_token_456'
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        final result = await dataSource.login('testuser', 'testpass');
        expect(result, 'login_token_456');
      });

      test('잘못된 로그인 정보 시 예외 발생', () async {
        final dio = createMockDio([
          MockRoute('POST', '/login', 400, {'error': 'Invalid credentials'}),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.login('wronguser', 'wrongpass'),
          throwsA(predicate((e) =>
              e is Exception && e.toString().contains('Invalid credentials'))),
        );
      });

      test('로그인 서버 오류 시 예외 발생', () async {
        final dio = createMockDio([
          MockRoute('POST', '/login', 500, 'Internal Server Error'),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.login('testuser', 'testpass'),
          throwsA(predicate((e) =>
              e is Exception && e.toString().contains('서버 내부 오류가 발생했습니다'))),
        );
      });
    });

    group('isLoginIdRegistered', () {
      test('등록된 ID 확인 성공 (camelCase 쿼리)', () async {
        final dio = createMockDio([
          MockRoute('GET', '/api/v1/users/check-loginid?loginId=existinguser', 200, {
            'exists': true
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        final result = await dataSource.isLoginIdRegistered('existinguser');
        expect(result, true);
      });

      test('등록된 ID 확인 성공 (fallback lowercase 쿼리)', () async {
        // 첫 번째(camelCase) 요청은 매칭 실패 -> 404 시뮬레이션, 두 번째(lowercase)에서 성공
        final dio = createMockDio([
          MockRoute('GET', '/api/v1/users/check-loginid?loginid=legacyuser', 200, {
            'exists': true
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        final result = await dataSource.isLoginIdRegistered('legacyuser');
        expect(result, true);
      });

      test('등록되지 않은 ID 확인 (camelCase)', () async {
        final dio = createMockDio([
          MockRoute('GET', '/api/v1/users/check-loginid?loginId=newuser', 200, {
            'exists': false
          }),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        final result = await dataSource.isLoginIdRegistered('newuser');
        expect(result, false);
      });

      test('아이디 확인 실패 시 예외 반환 (400 시 모든 후보 실패)', () async {
        final dio = createMockDio([
          MockRoute('GET', '/api/v1/users/check-loginid?loginId=baduser', 400, 'Bad Request'),
          MockRoute('GET', '/api/v1/users/check-loginid?loginid=baduser', 400, 'Bad Request'),
          MockRoute('GET', '/users/check-loginid?loginId=baduser', 400, 'Bad Request'),
        ]);
        final dataSource = AuthRemoteDataSource(dio);
        expect(
          () => dataSource.isLoginIdRegistered('baduser'),
          throwsA(predicate((e) => e is Exception && e.toString().contains('아이디 확인 요청 실패'))),
        );
      });
    });

    group('deleteAccount', () {
      test('계정 탈퇴 목 구현 정상', () async {
  final dio = createMockDio([]); // 실제 호출 없음
        final dataSource = AuthRemoteDataSource(dio);
        expect(() => dataSource.deleteAccount(), returnsNormally);
      });
    });
  });
}
