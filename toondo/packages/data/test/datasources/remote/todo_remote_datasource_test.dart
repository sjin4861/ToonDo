import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/constants.dart';

import 'todo_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client, AuthRepository])
void main() {
  late TodoRemoteDataSource dataSource;
  late MockClient mockClient;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockClient = MockClient();
    mockAuthRepository = MockAuthRepository();
    dataSource = TodoRemoteDataSource(mockClient, mockAuthRepository);
  });

  group('TodoRemoteDataSource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('createTodo', () {
      const mockResponseBody = '''{"todoId": "1"}''';

      test('투두 생성 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos');
        when(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.createTodo(
          title: '새로운 투두',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          goalId: 1,
          eisenhower: 'IMPORTANT_URGENT',
        );

        // Assert
        expect(result, '1');
        verify(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos');
        when(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"message": "Bad Request"}', 400));

        // Act & Assert
        expect(
          () => dataSource.createTodo(
            title: '새로운 투두',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 1, 31),
            eisenhower: 'IMPORTANT_URGENT',
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 응답 400'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.createTodo(
            title: '새로운 투두',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 1, 31),
            eisenhower: 'IMPORTANT_URGENT',
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });
    });

    group('fetchTodosByDate', () {
      const mockResponseBody = '''{
        "dday": [{"todoId": "1", "goalId": 1, "title": "Deadline Todo", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": 1}],
        "daily": [{"todoId": "2", "goalId": null, "title": "Daily Todo", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": 2}]
      }''';

      test('날짜별 투두 조회 성공', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 1);
        final url = Uri.parse('${Constants.baseUrl}/api/v1/by-date?date=2024-01-01');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.fetchTodosByDate(testDate);

        // Assert
        expect(result, isA<Map<String, List<Todo>>>());
        expect(result['dday']!.length, 1);
        expect(result['daily']!.length, 1);
        expect(result['dday']!.first.title, 'Deadline Todo');
        expect(result['daily']!.first.title, 'Daily Todo');
        verify(mockClient.get(url, headers: anyNamed('headers'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 1);
        final url = Uri.parse('${Constants.baseUrl}/api/v1/by-date?date=2024-01-01');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"message": "Not Found"}', 404));

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
      const mockResponseBody = '''{
        "data": [{"todoId": "1", "goalId": 1, "title": "Goal Todo", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-31", "eisenhower": "IMPORTANT_URGENT"}]
      }''';

      test('목표별 투두 조회 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/by-goal/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.fetchTodosByGoal(1);

        // Assert
        expect(result, isA<List<Todo>>());
        expect(result.length, 1);
        expect(result.first.title, 'Goal Todo');
        expect(result.first.goalId, '1');
        verify(mockClient.get(url, headers: anyNamed('headers'))).called(1);
      });

      test('500 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/by-goal/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"message": "Server Error"}', 500));

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
      const mockResponseBody = '''{
        "data": {"todoId": "1", "goalId": 1, "title": "Individual Todo", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-31", "eisenhower": "IMPORTANT_NOT_URGENT"}
      }''';

      test('투두 ID로 조회 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.fetchTodoById(1);

        // Assert
        expect(result, isA<Todo>());
        expect(result.title, 'Individual Todo');
        expect(result.id, '1');
        expect(result.eisenhower, 2); // IMPORTANT_NOT_URGENT = 2
        verify(mockClient.get(url, headers: anyNamed('headers'))).called(1);
      });
    });

    group('updateTodo', () {
      const mockResponseBody = '''{"todoId": "1"}''';

      test('투두 업데이트 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.updateTodo(
          todoId: 1,
          title: '업데이트된 투두',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          goalId: 1,
          eisenhower: 'NOT_IMPORTANT_URGENT',
        );

        // Assert
        expect(result, '1');
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"message": "Bad Request"}', 400));

        // Act & Assert
        expect(
          () => dataSource.updateTodo(
            todoId: 1,
            title: '업데이트된 투두',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 1, 31),
            eisenhower: 'NOT_IMPORTANT_URGENT',
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
      const mockResponseBody = '''{
        "todoId": "1",
        "status": 1,
        "completedAt": "2024-01-01T10:00:00Z"
      }''';

      test('투두 상태 토글 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1/status');
        when(mockClient.patch(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await dataSource.toggleTodoStatus(1);

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['todoId'], '1');
        expect(result['status'], 1);
        expect(result['completedAt'], '2024-01-01T10:00:00Z');
        verify(mockClient.patch(url, headers: anyNamed('headers'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1/status');
        when(mockClient.patch(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"message": "Not Found"}', 404));

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
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('', 200));

        // Act
        final result = await dataSource.deleteTodo(1);

        // Assert
        expect(result, true);
        verify(mockClient.delete(url, headers: anyNamed('headers'))).called(1);
      });

      test('404 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"message": "Not Found"}', 404));

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
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'raw_token_without_bearer');
        
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"data": {"todoId": "1", "title": "test", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": 1}}', 200));

        // Act
        await dataSource.fetchTodoById(1);

        // Assert
        verify(mockClient.get(
          url,
          headers: argThat(
            contains('Authorization'),
            named: 'headers',
          ),
        )).called(1);
      });

      test('이미 Bearer 프리픽스가 있는 토큰은 그대로 사용', () async {
        // Arrange
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'Bearer existing_token');
        
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{"data": {"todoId": "1", "title": "test", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": 1}}', 200));

        // Act
        await dataSource.fetchTodoById(1);

        // Assert
        verify(mockClient.get(
          url,
          headers: argThat(
            contains('Authorization'),
            named: 'headers',
          ),
        )).called(1);
      });
    });

    group('eisenhower 값 처리', () {
      test('문자열 eisenhower 값이 올바르게 정수로 변환', () async {
        // Arrange
        const responseWithStringEisenhower = '''{
          "data": {"todoId": "1", "goalId": 1, "title": "test", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": "NOT_IMPORTANT_NOT_URGENT"}
        }''';
        
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(responseWithStringEisenhower, 200));

        // Act
        final result = await dataSource.fetchTodoById(1);

        // Assert
        expect(result.eisenhower, 4); // NOT_IMPORTANT_NOT_URGENT = 4
      });

      test('정수 eisenhower 값이 올바르게 처리', () async {
        // Arrange
        const responseWithIntEisenhower = '''{
          "data": {"todoId": "1", "goalId": 1, "title": "test", "status": 0, "startDate": "2024-01-01", "endDate": "2024-01-01", "eisenhower": 3}
        }''';
        
        final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/1');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(responseWithIntEisenhower, 200));

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
