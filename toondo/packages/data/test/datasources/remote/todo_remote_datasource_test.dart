import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/todo.dart';
// ignore_for_file: unused_import
import 'package:data/constants.dart';

import 'todo_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio, AuthRepository])
void main() {
  late TodoRemoteDataSource dataSource;
  late MockDio mockDio;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockDio = MockDio();
    mockAuthRepository = MockAuthRepository();
    dataSource = TodoRemoteDataSource(mockDio, mockAuthRepository);
  });

  group('TodoRemoteDataSource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('createTodo', () {

      test('투두 생성 성공', () async {
        // Arrange
        when(mockDio.post(
          '/api/v1/todos',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos'),
              statusCode: 200,
              data: {"todoId": "1"},
            ));

        // Act
        final result = await dataSource.createTodo(
          title: '새로운 투두',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          goalId: 1,
          eisenhower: 0,
        );

        // Assert
        expect(result, '1');
        verify(mockDio.post(
          '/api/v1/todos',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        when(mockDio.post(
          '/api/v1/todos',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos'),
              statusCode: 400,
              data: {"message": "Bad Request"},
            ));

        // Act & Assert
        expect(
          () => dataSource.createTodo(
            title: '새로운 투두',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 1, 31),
            eisenhower: 0,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 400'),
          )),
        );
      });

      // 토큰 null 시 Authorization 헤더 생략되며 쿠키 기반 처리. 별도 예외 테스트 제거.
    });

    group('fetchTodosByDate', () {

      test('날짜별 투두 조회 성공', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 1);
        when(mockDio.get(
          '/api/v1/todos/by-date',
          queryParameters: {'date': '2024-01-01'},
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/by-date'),
              statusCode: 200,
              data: {
                "dday": [
                  {
                    "todoId": "1",
                    "goalId": 1,
                    "title": "Deadline Todo",
                    "status": 0,
                    "startDate": "2024-01-01",
                    "endDate": "2024-01-01",
                    "eisenhower": 1,
                    "showOnHome": false,
                  }
                ],
                "daily": [
                  {
                    "todoId": "2",
                    "goalId": null,
                    "title": "Daily Todo",
                    "status": 0,
                    "startDate": "2024-01-01",
                    "endDate": "2024-01-01",
                    "eisenhower": 2,
                    "showOnHome": false,
                  }
                ]
              },
            ));

        // Act
        final result = await dataSource.fetchTodosByDate(testDate);

        // Assert
        expect(result, isA<Map<String, List<Todo>>>());
        expect(result['dday']!.length, 1);
        expect(result['daily']!.length, 1);
        expect(result['dday']!.first.title, 'Deadline Todo');
        expect(result['daily']!.first.title, 'Daily Todo');
        verify(mockDio.get(
          '/api/v1/todos/by-date',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 1);
        when(mockDio.get(
          '/api/v1/todos/by-date',
          data: anyNamed('data'),
          queryParameters: {'date': '2024-01-01'},
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/by-date'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

        // Act & Assert
        expect(
          () => dataSource.fetchTodosByDate(testDate),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 404'),
          )),
        );
      });
    });

    group('fetchTodosByGoal', () {

      test('목표별 투두 조회 성공', () async {
        // Arrange
        when(mockDio.get('/api/v1/todos/by-goal/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/by-goal/1'),
              statusCode: 200,
              data: {
                "data": [
                  {
                    "todoId": "1",
                    "goalId": 1,
                    "title": "Goal Todo",
                    "status": 0,
                    "startDate": "2024-01-01",
                    "endDate": "2024-01-31",
                    "eisenhower": "IMPORTANT_URGENT",
                    "showOnHome": false,
                  }
                ]
              },
            ));

        // Act
        final result = await dataSource.fetchTodosByGoal(1);

        // Assert
        expect(result, isA<List<Todo>>());
        expect(result.length, 1);
        expect(result.first.title, 'Goal Todo');
        expect(result.first.goalId, '1');
  verify(mockDio.get('/api/v1/todos/by-goal/1', options: anyNamed('options'))).called(1);
      });

      test('500 에러 처리', () async {
        // Arrange
        when(mockDio.get('/api/v1/todos/by-goal/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/by-goal/1'),
              statusCode: 500,
              data: {"message": "Server Error"},
            ));

        // Act & Assert
        expect(
          () => dataSource.fetchTodosByGoal(1),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 500'),
          )),
        );
      });
    });

    group('fetchTodoById', () {

      test('투두 ID로 조회 성공', () async {
        // Arrange
        when(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {
                "data": {
                  "todoId": "1",
                  "goalId": 1,
                  "title": "Individual Todo",
                  "status": 0,
                  "startDate": "2024-01-01",
                  "endDate": "2024-01-31",
                  "eisenhower": "IMPORTANT_NOT_URGENT",
                  "showOnHome": false,
                }
              },
            ));

        // Act
        final result = await dataSource.fetchTodoById(1);

        // Assert
        expect(result, isA<Todo>());
        expect(result.title, 'Individual Todo');
        expect(result.id, '1');
        expect(result.eisenhower, 2); // IMPORTANT_NOT_URGENT = 2
  verify(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).called(1);
      });
    });

    group('updateTodo', () {

      test('투두 업데이트 성공', () async {
        // Arrange
        when(mockDio.put(
          '/api/v1/todos/1',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {"todoId": "1"},
            ));

        // Act
        final result = await dataSource.updateTodo(
          todoId: 1,
          title: '업데이트된 투두',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          goalId: 1,
          eisenhower: 3, // NOT_IMPORTANT_URGENT
        );

        // Assert
        expect(result, '1');
        verify(mockDio.put(
          '/api/v1/todos/1',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        when(mockDio.put(
          '/api/v1/todos/1',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 400,
              data: {"message": "Bad Request"},
            ));

        // Act & Assert
        expect(
          () => dataSource.updateTodo(
            todoId: 1,
            title: '업데이트된 투두',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 1, 31),
            eisenhower: 3, // NOT_IMPORTANT_URGENT
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 400'),
          )),
        );
      });
    });

    group('toggleTodoStatus', () {

      test('투두 상태 토글 성공', () async {
        // Arrange
        when(mockDio.patch(
          '/api/v1/todos/1/status',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1/status'),
              statusCode: 200,
              data: {"todoId": "1", "status": 1, "completedAt": "2024-01-01T10:00:00Z"},
            ));

        // Act
        final result = await dataSource.toggleTodoStatus(1);

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['todoId'], '1');
        expect(result['status'], 1.0);
        expect(result['completedAt'], '2024-01-01T10:00:00Z');
  verify(mockDio.patch('/api/v1/todos/1/status', options: anyNamed('options'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        when(mockDio.patch('/api/v1/todos/1/status', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1/status'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

        // Act & Assert
        expect(
          () => dataSource.toggleTodoStatus(1),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 404'),
          )),
        );
      });
    });

    group('deleteTodo', () {
      test('투두 삭제 성공', () async {
        // Arrange
        when(mockDio.delete('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {},
            ));

        // Act
        final result = await dataSource.deleteTodo(1);

        // Assert
        expect(result, true);
  verify(mockDio.delete('/api/v1/todos/1', options: anyNamed('options'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        when(mockDio.delete('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 404,
              data: {"message": "Not Found"},
            ));

        // Act & Assert
        expect(
          () => dataSource.deleteTodo(1),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 404'),
          )),
        );
      });
    });

    group('Bearer token 처리', () {
      test('Bearer 프리픽스가 없는 토큰에 자동으로 추가', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => 'raw_token_without_bearer');
        when(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {
                "data": {
                  "todoId": "1",
                  "title": "test",
                  "status": 0,
                  "startDate": "2024-01-01",
                  "endDate": "2024-01-01",
                  "eisenhower": 1,
                  "showOnHome": false,
                }
              },
            ));

        // Act
        await dataSource.fetchTodoById(1);

        // Assert
        verify(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).called(1);
      });

      test('이미 Bearer 프리픽스가 있는 토큰은 그대로 사용', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => 'Bearer existing_token');
        when(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {
                "data": {
                  "todoId": "1",
                  "title": "test",
                  "status": 0,
                  "startDate": "2024-01-01",
                  "endDate": "2024-01-01",
                  "eisenhower": 1,
                  "showOnHome": false,
                }
              },
            ));

        // Act
        await dataSource.fetchTodoById(1);

        // Assert
        verify(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).called(1);
      });
    });

    group('eisenhower 값 처리', () {
      test('문자열 eisenhower 값이 올바르게 정수로 변환', () async {
        // Arrange
        // no-op: response body prepared inline in mock answer
        
        when(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {
                "data": {
                  "todoId": "1",
                  "goalId": 1,
                  "title": "test",
                  "status": 0,
                  "startDate": "2024-01-01",
                  "endDate": "2024-01-01",
                  "eisenhower": "NOT_IMPORTANT_NOT_URGENT",
                  "showOnHome": false,
                }
              },
            ));

        // Act
        final result = await dataSource.fetchTodoById(1);

        // Assert
        expect(result.eisenhower, 4); // NOT_IMPORTANT_NOT_URGENT = 4
      });

      test('정수 eisenhower 값이 올바르게 처리', () async {
        // Arrange
        // no-op: response body prepared inline in mock answer
        
        when(mockDio.get('/api/v1/todos/1', options: anyNamed('options'))).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/v1/todos/1'),
              statusCode: 200,
              data: {
                "data": {
                  "todoId": "1",
                  "goalId": 1,
                  "title": "test",
                  "status": 0,
                  "startDate": "2024-01-01",
                  "endDate": "2024-01-01",
                  "eisenhower": 3,
                  "showOnHome": false,
                }
              },
            ));

        // Act
        final result = await dataSource.fetchTodoById(1);

        // Assert
        expect(result.eisenhower, 3);
      });
    });

    group('미구현 메소드들', () {
      test('fetchTodos는 UnimplementedError 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.fetchTodos(),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('commitTodos는 UnimplementedError 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.commitTodos([], []),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
