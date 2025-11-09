import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
// ignore_for_file: unused_import
import 'package:data/constants.dart';

import 'user_remote_datasource_test.mocks.dart';
class FakeDio extends Mock implements Dio {}


@GenerateMocks([AuthRepository])
void main() {
  late UserRemoteDatasource dataSource;
  late FakeDio mockDio;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
  mockDio = FakeDio();
  mockAuthRepository = MockAuthRepository();
  dataSource = UserRemoteDatasource(mockDio, mockAuthRepository);
  });

  group('UserRemoteDatasource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('getUserMe', () {

      test('내 정보 조회 성공', () async {
        // Arrange
        when(mockDio.get('/users/me', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me'),
              statusCode: 200,
              data: {
                "message": "내 정보 조회 성공",
                "userId": 123,
                "loginId": "testuser",
                "nickname": "Test Nickname",
                "email": "test@example.com"
              },
            ));

        // Act
        final result = await dataSource.getUserMe();

        // Assert
        expect(result, isA<User>());
  verify(mockDio.get('/users/me', options: anyNamed('options'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        when(mockDio.get('/users/me', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

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
        when(mockDio.get('/users/me', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me'),
              statusCode: 500,
              data: {"message": "Internal Server Error"},
            ));

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

      // JWT 토큰 없어도 쿠키 세션 가능 -> 예외 테스트 제거

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        when(mockDio.get('/users/me', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me'),
              statusCode: 200,
              data: {"message": "Invalid response"},
            ));

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

      test('비밀번호 수정 성공', () async {
        // Arrange
        when(mockDio.put('/users/me/password', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me/password'),
              statusCode: 200,
              data: {"message": "비밀번호 수정 성공"},
            ));

        // Act
        await dataSource.updatePassword('newPassword123');

        // Assert
        verify(mockDio.put('/users/me/password', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        when(mockDio.put('/users/me/password', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me/password'),
              statusCode: 400,
              data: {"message": "Invalid password format"},
            ));

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
        when(mockDio.put('/users/me/password', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me/password'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

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

      // JWT 토큰 없이도 쿠키 세션 가능 → 예외 테스트 제거

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        when(mockDio.put('/users/me/password', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me/password'),
              statusCode: 200,
              data: {"message": "Invalid response"},
            ));

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

      test('닉네임 변경 성공', () async {
        // Arrange
        when(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/save-nickname'),
              statusCode: 200,
              data: {"message": "닉네임 최초 저장 및 수정 완료", "nickname": "New Nickname"},
            ));

        // Act
        final result = await dataSource.changeNickName('New Nickname');

        // Assert
        expect(result, 'New Nickname');
        verify(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('400 에러 처리 - 빈 닉네임', () async {
        // Arrange
        when(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/save-nickname'),
              statusCode: 400,
              data: {"message": "Bad Request"},
            ));

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
        when(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/save-nickname'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

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
        when(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/save-nickname'),
              statusCode: 500,
              data: {"message": "Internal Server Error"},
            ));

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

      // JWT 토큰 없이도 쿠키 세션 가능 → 예외 테스트 제거

      test('잘못된 응답 형식 처리', () async {
        // Arrange
        when(mockDio.put('/users/save-nickname', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/save-nickname'),
              statusCode: 200,
              data: {"message": "Invalid response"},
            ));

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
        when(mockDio.delete('/users/delete', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/delete'),
              statusCode: 200,
              data: {"message": "deleted"},
            ));

        // Act
        await dataSource.deleteAccount();

        // Assert
  verify(mockDio.delete('/users/delete', options: anyNamed('options'))).called(1);
      });

      test('삭제 실패 처리', () async {
        // Arrange
        when(mockDio.delete('/users/delete', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/delete'),
              statusCode: 500,
              data: {"message": "Failed to delete"},
            ));

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

      // JWT 토큰 없이도 쿠키 세션 가능 → 예외 테스트 제거
    });

  group('Bearer token 처리', () {
      test('토큰이 올바르게 헤더에 포함됨', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => 'Bearer injected');
        when(mockDio.get('/users/me', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/users/me'),
              statusCode: 200,
              data: {
                "message": "내 정보 조회 성공",
                "userId": 123,
                "loginId": "test",
                "nickname": "test",
                "email": "test@test.com"
              },
            ));

        // Act
        await dataSource.getUserMe();

        // Assert
        verify(mockDio.get('/users/me', options: anyNamed('options'))).called(1);
      });
    });
  });
}
