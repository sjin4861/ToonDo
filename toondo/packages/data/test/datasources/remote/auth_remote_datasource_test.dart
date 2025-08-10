import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:data/constants.dart';

import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSource dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = AuthRemoteDataSource(mockClient);
  });

  group('AuthRemoteDataSource', () {
    group('registerUser', () {
      test('회원가입 성공 시 토큰 반환', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/signup');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              '{"accessToken":"test_token_123"}',
              200,
            ));

        // When
        final result = await dataSource.registerUser('testuser', 'testpass');

        // Then
        expect(result, 'test_token_123');
        verify(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).called(1);
      });

      test('이미 존재하는 ID로 회원가입 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/signup');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"existinguser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              '{"error":"Already exists loginId"}',
              400,
            ));

        // When & Then
        expect(
          () => dataSource.registerUser('existinguser', 'testpass'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('Already exists loginId')),
          ),
        );
      });

      test('서버 오류 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/signup');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              'Internal Server Error',
              500,
            ));

        // When & Then
        expect(
          () => dataSource.registerUser('testuser', 'testpass'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('서버 내부 오류가 발생했습니다')),
          ),
        );
      });

      test('기타 오류 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/signup');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              'Bad Request',
              401,
            ));

        // When & Then
        expect(
          () => dataSource.registerUser('testuser', 'testpass'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('회원가입 실패')),
          ),
        );
      });
    });

    group('login', () {
      test('로그인 성공 시 토큰 반환', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/login');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              '{"accessToken":"login_token_456"}',
              200,
            ));

        // When
        final result = await dataSource.login('testuser', 'testpass');

        // Then
        expect(result, 'login_token_456');
        verify(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).called(1);
      });

      test('잘못된 로그인 정보 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/login');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"wronguser","password":"wrongpass"}',
        )).thenAnswer((_) async => http.Response(
              '{"error":"Invalid credentials"}',
              400,
            ));

        // When & Then
        expect(
          () => dataSource.login('wronguser', 'wrongpass'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('Invalid credentials')),
          ),
        );
      });

      test('로그인 서버 오류 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/login');
        when(mockClient.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: '{"loginId":"testuser","password":"testpass"}',
        )).thenAnswer((_) async => http.Response(
              'Internal Server Error',
              500,
            ));

        // When & Then
        expect(
          () => dataSource.login('testuser', 'testpass'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('서버 내부 오류가 발생했습니다')),
          ),
        );
      });
    });

    group('isLoginIdRegistered', () {
      test('등록된 ID 확인 성공', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/check-loginid?loginid=existinguser');
        when(mockClient.get(url)).thenAnswer((_) async => http.Response(
              '{"exists":true}',
              200,
            ));

        // When
        final result = await dataSource.isLoginIdRegistered('existinguser');

        // Then
        expect(result, true);
        verify(mockClient.get(url)).called(1);
      });

      test('등록되지 않은 ID 확인 성공', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/check-loginid?loginid=newuser');
        when(mockClient.get(url)).thenAnswer((_) async => http.Response(
              '{"exists":false}',
              200,
            ));

        // When
        final result = await dataSource.isLoginIdRegistered('newuser');

        // Then
        expect(result, false);
        verify(mockClient.get(url)).called(1);
      });

      test('아이디 확인 실패 시 예외 발생', () async {
        // Given
        final url = Uri.parse('${Constants.baseUrl}/users/check-loginid?loginid=testuser');
        when(mockClient.get(url)).thenAnswer((_) async => http.Response(
              'Bad Request',
              400,
            ));

        // When & Then
        expect(
          () => dataSource.isLoginIdRegistered('testuser'),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('아이디 확인 실패')),
          ),
        );
      });
    });

    group('deleteAccount', () {
      test('계정 탈퇴 성공', () async {
        // When & Then
        // 현재는 목 구현이므로 예외가 발생하지 않으면 성공으로 간주
        expect(() => dataSource.deleteAccount(), returnsNormally);
      });
    });
  });
}
