import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:data/repositories/todo_repository_impl.dart';
import 'package:domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'todo_repository_impl_test.mocks.dart';
import '../helpers/test_data.dart';

@GenerateMocks([
  TodoLocalDatasource,
  TodoRemoteDataSource,
])
void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDatasource mockLocal;
  late MockTodoRemoteDataSource mockRemote;

  setUp(() {
    mockLocal = MockTodoLocalDatasource();
    mockRemote = MockTodoRemoteDataSource();

    repository = TodoRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
    );
  });

  group('TodoRepositoryImpl', () {
    group('로컬 데이터 테스트', () {
      test('getLocalTodos는 로컬 데이터소스의 getAllTodos를 호출해야 한다', () {
        final todos = TestData.createTestTodos();
        when(mockLocal.getAllTodos()).thenReturn(todos);

        final result = repository.getLocalTodos();

        expect(result, equals(todos));
        verify(mockLocal.getAllTodos());
      });

      test('createTodo는 로컬 데이터소스의 saveTodo를 호출하고 결과를 반환해야 한다', () async {
        final todo = TestData.createTestTodo(id: 'todo_1');
        when(mockLocal.saveTodo(todo)).thenAnswer((_) => Future.value(true));

        final result = await repository.createTodo(todo);

        expect(result, isTrue);
        verify(mockLocal.saveTodo(todo));
      });

      test('updateTodo는 로컬 데이터소스의 updateTodo를 호출해야 한다', () async {
        final todo = TestData.createTestTodo(id: 'todo_1');
        when(mockLocal.updateTodo(todo)).thenAnswer((_) => Future<void>.value());

        await repository.updateTodo(todo);

        verify(mockLocal.updateTodo(todo));
      });

      test('deleteTodo는 로컬 데이터소스의 deleteTodo를 호출해야 한다', () async {
        final todo = TestData.createTestTodo(id: 'todo_1');
        when(mockLocal.deleteTodo(todo)).thenAnswer((_) => Future<void>.value());

        await repository.deleteTodo(todo);

        verify(mockLocal.deleteTodo(todo));
      });
    });

    group('원격 데이터 테스트', () {
      // fetchTodos와 commitTodos는 미구현 상태이므로 테스트 제외
      // TODO: 향후 백엔드 API 스펙 확정 후 테스트 추가
    });
  });
}