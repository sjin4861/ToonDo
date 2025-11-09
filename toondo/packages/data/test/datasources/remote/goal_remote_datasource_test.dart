import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
// ignore_for_file: unused_import
import 'package:data/constants.dart';

import 'goal_remote_datasource_test.mocks.dart';
// Local fake to avoid Mockito name collision and codegen for Dio
class FakeDio extends Mock implements Dio {}


@GenerateMocks([AuthRepository])
void main() {
  late GoalRemoteDataSource dataSource;
  late FakeDio mockDio;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
  mockDio = FakeDio();
  mockAuthRepository = MockAuthRepository();
  dataSource = GoalRemoteDataSource(mockDio, mockAuthRepository);
  });

  group('GoalRemoteDataSource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('readGoals', () {
      test('전체 목표 조회 성공', () async {
        // Arrange
        when(mockDio.get('/api/v1/goals', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 200,
              data: [
                {
                  "goalId": "1",
                  "goalName": "테스트 목표",
                  "startDate": "2024-01-01",
                  "endDate": "2024-12-31",
                  "icon": "test_icon",
                  "status": 0,
                  "progress": 50.0,
                  "showOnHome": false,
                }
              ],
            ));

        // Act
        final result = await dataSource.readGoals();

        // Assert
        expect(result, isA<List<Goal>>());
        expect(result.length, 1);
        expect(result.first.name, '테스트 목표');
  verify(mockDio.get('/api/v1/goals', options: anyNamed('options'))).called(1);
      });

      test('401 에러 처리', () async {
        // Arrange
        when(mockDio.get('/api/v1/goals', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 401,
              data: {"error": "Unauthorized"},
            ));

        // Act & Assert
        expect(
          () => dataSource.readGoals(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('인증 오류 (401 Unauthorized)'),
          )),
        );
      });

      // JWT 토큰 없을 때는 쿠키 기반 흐름 (예외 제거)
    });

    group('createGoal', () {
      final testGoal = Goal(
        id: '',
        name: '새 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 0.0,
      );

      test('목표 생성 성공', () async {
        // Arrange
        when(mockDio.post('/api/v1/goals', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 201,
              data: {
                "goalId": "1",
                "goalName": "새 목표",
                "startDate": "2024-01-01",
                "endDate": "2024-12-31",
                "icon": "test_icon",
                "status": 0,
                "progress": 0.0,
                "showOnHome": false,
              },
            ));

        // Act
        final result = await dataSource.createGoal(testGoal);

        // Assert
        expect(result, isA<Goal>());
        expect(result.name, '새 목표');
        verify(mockDio.post('/api/v1/goals', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        when(mockDio.post('/api/v1/goals', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 400,
              data: {"message": "Bad Request"},
            ));

        // Act & Assert
        expect(
          () => dataSource.createGoal(testGoal),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('잘못된 요청 (400 Bad Request)'),
          )),
        );
      });
    });

    group('updateGoal', () {
      final testGoal = Goal(
        id: '1',
        name: '업데이트된 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'updated_icon',
        status: Status.inProgress,
        progress: 75.0,
      );

      test('목표 업데이트 성공', () async {
        // Arrange
        when(mockDio.put('/api/v1/goals/1', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1'),
              statusCode: 200,
              data: {"message": "updated"},
            ));

        // Act
        await dataSource.updateGoal(testGoal);

        // Assert
        verify(mockDio.put('/api/v1/goals/1', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        when(mockDio.put('/api/v1/goals/1', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1'),
              statusCode: 400,
              data: {"message": "Bad Request"},
            ));

        // Act & Assert
        expect(
          () => dataSource.updateGoal(testGoal),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('잘못된 요청 (400 Bad Request)'),
          )),
        );
      });
    });

    group('updateGoalStatus', () {
      final testGoal = Goal(
        id: '1',
        name: '테스트 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 50.0,
      );

      test('목표 상태 업데이트 성공', () async {
        // Arrange
        when(mockDio.patch('/api/v1/goals/1/status', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1/status'),
              statusCode: 200,
              data: {"message": "목표 상태가 업데이트되었습니다", "progress": 100},
            ));

        // Act
        final result = await dataSource.updateGoalStatus(testGoal, Status.completed);

        // Assert
        expect(result, true);
        verify(mockDio.patch('/api/v1/goals/1/status', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('500 에러 처리', () async {
        // Arrange
        when(mockDio.patch('/api/v1/goals/1/status', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1/status'),
              statusCode: 500,
              data: {"message": "Internal Server Error"},
            ));

        // Act & Assert
        expect(
          () => dataSource.updateGoalStatus(testGoal, Status.completed),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 내부 오류 (500 Internal Server Error)'),
          )),
        );
      });
    });

    group('updateGoalProgress', () {
      final testGoal = Goal(
        id: '1',
        name: '테스트 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 50.0,
      );

      test('목표 진행률 업데이트 성공', () async {
        // Arrange
        when(mockDio.patch('/api/v1/goals/1/progress', data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1/progress'),
              statusCode: 200,
              data: {"message": "목표 진행률이 업데이트되었습니다", "progress": 75},
            ));

        // Act
        final result = await dataSource.updateGoalProgress(testGoal, 75.0);

        // Assert
        expect(result, true);
        verify(mockDio.patch('/api/v1/goals/1/progress', data: anyNamed('data'), options: anyNamed('options'))).called(1);
      });

      test('잘못된 progress 값으로 예외 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.updateGoalProgress(testGoal, 150.0),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('progress 값은 0~100 사이여야 합니다'),
          )),
        );
      });

      test('음수 progress 값으로 예외 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.updateGoalProgress(testGoal, -10.0),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('progress 값은 0~100 사이여야 합니다'),
          )),
        );
      });
    });

    group('deleteGoal', () {
      test('목표 삭제 성공', () async {
        // Arrange
        when(mockDio.delete('/api/v1/goals/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1'),
              statusCode: 200,
              data: {"message": "deleted"},
            ));

        // Act
        await dataSource.deleteGoal('1');

        // Assert
  verify(mockDio.delete('/api/v1/goals/1', options: anyNamed('options'))).called(1);
      });

      test('403 에러 처리', () async {
        // Arrange
        when(mockDio.delete('/api/v1/goals/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals/1'),
              statusCode: 403,
              data: {"message": "Forbidden"},
            ));

        // Act & Assert
        expect(
          () => dataSource.deleteGoal('1'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('권한 오류 (403 Forbidden)'),
          )),
        );
      });
    });

    group('Bearer token 처리', () {
      test('Bearer 프리픽스가 없는 토큰에 자동으로 추가', () async {
        // Arrange
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'raw_token_without_bearer');
        
        when(mockDio.get('/api/v1/goals', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 200,
              data: [],
            ));

        // Act
        await dataSource.readGoals();

        // Assert
        verify(mockDio.get('/api/v1/goals', options: anyNamed('options'))).called(1);
      });

      test('이미 Bearer 프리픽스가 있는 토큰은 그대로 사용', () async {
        // Arrange
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'Bearer existing_token');
        
        when(mockDio.get('/api/v1/goals', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/goals'),
              statusCode: 200,
              data: [],
            ));

        // Act
        await dataSource.readGoals();

        // Assert
        verify(mockDio.get('/api/v1/goals', options: anyNamed('options'))).called(1);
      });
    });
  });
}
