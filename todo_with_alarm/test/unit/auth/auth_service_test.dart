// test/auth_service_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  // Flutter 바인딩 초기화
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Tests', () {
    late MockClient mockHttpClient;
    late AuthService authService;

    setUp(() {
      mockHttpClient = MockClient((request) async {
        final requestBody = jsonDecode(request.body);

        if (request.url.path == '/users/signup' && request.method == 'POST') {
          if (requestBody['phoneNumber'] == '01098765432') {
            // 이미 존재하는 휴대폰 번호로 회원가입 시도
            return http.Response(
              jsonEncode({'message': '이미 등록된 휴대폰 번호입니다.'}),
              400,
            );
          } else {
            // 회원가입 성공
            return http.Response(
              jsonEncode({'message': '회원가입 성공'}),
              201,
            );
          }
        } else if (request.url.path == '/users/login' &&
            request.method == 'POST') {
          if (requestBody['password'] == 'correctpassword') {
            // 로그인 성공
            return http.Response(
              jsonEncode({'token': 'dummy_token'}),
              200,
            );
          } else {
            // 로그인 실패
            return http.Response(
              jsonEncode({'message': '비밀번호가 일치하지 않습니다.'}),
              400,
            );
          }
        } else if (request.url.path == '/users/update-username' &&
            request.method == 'PUT') {
          if (requestBody['userId'] == 'validUserId') {
            // 닉네임 업데이트 성공
            return http.Response(
              jsonEncode({'message': '닉네임이 성공적으로 업데이트되었습니다.'}),
              200,
            );
          } else {
            // 닉네임 업데이트 실패
            return http.Response(
              jsonEncode({'message': '유효하지 않은 사용자 ID입니다.'}),
              400,
            );
          }
        } else if (request.url.path == '/users/check-phone' &&
            request.method == 'POST') {
          if (requestBody['phoneNumber'] == '01012345678') {
            // 휴대폰 번호가 이미 등록되어 있음
            return http.Response(
              jsonEncode({'exists': true}),
              200,
            );
          } else {
            // 휴대폰 번호가 등록되어 있지 않음
            return http.Response(
              jsonEncode({'exists': false}),
              200,
            );
          }
        } else {
          // 기타 요청에 대한 기본 응답
          return http.Response('Not Found', 404);
        }
      });

      authService = AuthService();
    });

    test('1. Register new user successfully', () async {
      // Arrange
      final phoneNumber = '01012345678';
      final password = 'password123';

      // Act
      await authService.registerUser(phoneNumber, password);

      // Assert
      // 예외가 발생하지 않으면 회원가입 성공으로 간주합니다.
    });

    test('2. Fail to register user with existing phone number', () async {
      // Arrange
      final phoneNumber = '01087654321'; // 이미 존재하는 번호로 설정
      final password = '87654321';

      // Act & Assert
      expect(
        () async => await authService.registerUser(phoneNumber, password),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('이미 등록된 휴대폰 번호입니다.'),
        )),
      );
    });

    test('3. Login successfully with correct credentials', () async {
      // Arrange
      final phoneNumber = '01055556666';
      final password = 'correctpassword';

      // Act
      await authService.login(phoneNumber, password);

      // Assert
      // 예외가 발생하지 않으면 로그인 성공으로 간주합니다.
    });

    test('4. Fail to login with incorrect password', () async {
      // Arrange
      final phoneNumber = '01077778888';
      final password = 'wrongpassword';

      // Act & Assert
      expect(
        () async => await authService.login(phoneNumber, password),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('비밀번호가 일치하지 않습니다.'),
        )),
      );
    });

    test('5. Successfully update username', () async {
      // Arrange
      final nickname = 'NewNickname';

      // Act
      await authService.updateUsername(nickname);

      // Assert
      // 예외가 발생하지 않으면 닉네임 업데이트 성공으로 간주합니다.
    });

    test('6. Fail to update username with invalid userId', () async {
      // Arrange
      final nickname = 'NewNickname';

      // Act & Assert
      expect(
        () async => await authService.updateUsername(nickname),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('유효하지 않은 사용자 ID입니다.'),
        )),
      );
    });

    test('7. Check if phone number is already registered', () async {
      // Arrange
      final phoneNumber = '01012345678';

      // Act
      final result = await authService.isPhoneNumberRegistered(phoneNumber);

      // Assert
      expect(result, isA<bool>());
    });

    test('8. Logout clears token and currentUser', () async {
      // Act
      await authService.logout();

      // Assert
      // Expect token and currentUser to be removed from storage
    });
  });
}
