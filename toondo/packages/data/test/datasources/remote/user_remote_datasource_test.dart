import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:data/constants.dart';

import 'user_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client, AuthRepository])
void main() {
  late UserRemoteDatasource dataSource;
  late MockClient mockClient;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockClient = MockClient();
    mockAuthRepository = MockAuthRepository();
    dataSource = UserRemoteDatasource(mockClient, mockAuthRepository);
  });

  group('UserRemoteDatasource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('getUserMe', () {
      const mockResponseBody = '''{
        "message": "내 정보 조회 성공",
        "userId": 123,
        "loginId": "testuser",
        "nickname": "Test Nickname",
        "email": "test@example.com"
      }''';

      test('내 정보 조회 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me');
        final responseBytes = utf8.encode(mockResponseBody);
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response.bytes(
              responseBytes, 
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ));

        // Act
        final result = await dataSource.getUserMe();

        // Assert
        expect(result, isA<User>());
        verify(mockClient.get(url, headers: anyNamed('headers'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => dataSource.getUserMe(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('사용자를 찾을 수 없습니다'),
          )),
        );
      });

      test('500 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Internal Server Error', 500));

        // Act & Assert
        expect(
          () => dataSource.getUserMe(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 오류가 발생했습니다'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.getUserMe(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"message": "Invalid response"}', 200));

        // Act & Assert
        expect(
          () => dataSource.getUserMe(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('응답 형식이 올바르지 않습니다'),
          )),
        );
      });
    });

    group('updatePassword', () {
      const mockResponseBody = '''{
        "message": "비밀번호 수정 성공"
      }''';

      test('비밀번호 수정 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me/password');
        final responseBytes = utf8.encode(mockResponseBody);
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response.bytes(
          responseBytes, 
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ));

        // Act
        await dataSource.updatePassword('newPassword123');

        // Assert
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me/password');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"message": "Invalid password format"}', 400));

        // Act & Assert
        expect(
          () => dataSource.updatePassword('weak'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid password format'),
          )),
        );
      });

      test('404 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me/password');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => dataSource.updatePassword('newPassword123'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('사용자를 찾을 수 없습니다'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.updatePassword('newPassword123'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me/password');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"message": "Invalid response"}', 200));

        // Act & Assert
        expect(
          () => dataSource.updatePassword('newPassword123'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('응답 형식이 올바르지 않습니다'),
          )),
        );
      });
    });

    group('changeNickName', () {
      const mockResponseBody = '''{
        "message": "닉네임 최초 저장 및 수정 완료",
        "nickname": "New Nickname"
      }''';

      test('닉네임 변경 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
        final responseBytes = utf8.encode(mockResponseBody);
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response.bytes(
          responseBytes, 
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ));

        // Act
        final result = await dataSource.changeNickName('New Nickname');

        // Assert
        expect(result, 'New Nickname');
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리 - 빈 닉네임', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Bad Request', 400));

        // Act & Assert
        expect(
          () => dataSource.changeNickName(''),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('닉네임은 공백일 수 없습니다'),
          )),
        );
      });

      test('404 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => dataSource.changeNickName('New Nickname'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('사용자를 찾을 수 없습니다'),
          )),
        );
      });

      test('500 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        // Act & Assert
        expect(
          () => dataSource.changeNickName('New Nickname'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 오류가 발생했습니다'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.changeNickName('New Nickname'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"message": "Invalid response"}', 200));

        // Act & Assert
        expect(
          () => dataSource.changeNickName('New Nickname'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('응답 형식이 올바르지 않습니다'),
          )),
        );
      });
    });

    group('deleteAccount', () {
      test('계정 삭제 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/delete');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('', 200));

        // Act
        await dataSource.deleteAccount();

        // Assert
        verify(mockClient.delete(url, headers: anyNamed('headers'))).called(1);
      });

      test('삭제 실패 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/delete');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Failed to delete', 500));

        // Act & Assert
        expect(
          () => dataSource.deleteAccount(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to delete account'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.deleteAccount(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });
    });

    group('Bearer token 처리', () {
      test('토큰이 올바르게 헤더에 포함됨', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/users/me');
        final responseBytes = utf8.encode('{"message": "내 정보 조회 성공", "userId": 123, "loginId": "test", "nickname": "test", "email": "test@test.com"}');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response.bytes(
              responseBytes, 
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ));

        // Act
        await dataSource.getUserMe();

        // Assert
        verify(mockClient.get(
          url,
          headers: argThat(
            allOf([
              contains('Authorization'),
              contains('Content-Type'),
            ]),
            named: 'headers',
          ),
        )).called(1);
      });
    });
  });
}
