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
      test('fetchTodos는 원격 데이터소스의 fetchTodos를 호출하고 로컬에 저장해야 한다', () async {
        final todos = TestData.createTestTodos();
        when(mockRemote.fetchTodos()).thenAnswer((_) => Future.value(todos));
        when(mockLocal.clearTodos()).thenAnswer((_) => Future<void>.value());
        
        for (var t in todos) {
          when(mockLocal.saveTodo(t)).thenAnswer((_) => Future.value(true));
        }

        final result = await repository.fetchTodos();

        expect(result, equals(todos));
        verify(mockRemote.fetchTodos());
        verify(mockLocal.clearTodos());
        
        for (var t in todos) {
          verify(mockLocal.saveTodo(t));
        }
      });
    });

    group('동기화 테스트', () {
      test('commitTodos 성공 시 동기화 과정을 거쳐 true를 반환해야 한다', () async {
        final unsynced = TestData.createTestTodos();
        final deleted = <Todo>[];
        
        when(mockLocal.getUnsyncedTodos()).thenReturn(unsynced);
        when(mockLocal.getDeletedTodos()).thenReturn(deleted);
        when(mockRemote.commitTodos(unsynced, deleted))
            .thenAnswer((_) => Future.value(true));
        when(mockLocal.syncTodos(unsynced)).thenAnswer((_) => Future<void>.value());
        when(mockLocal.clearDeletedTodos()).thenAnswer((_) => Future<void>.value());

        final result = await repository.commitTodos();

        expect(result, isTrue);
        verify(mockLocal.getUnsyncedTodos());
        verify(mockLocal.getDeletedTodos());
        verify(mockRemote.commitTodos(unsynced, deleted));
        verify(mockLocal.syncTodos(unsynced));
        verify(mockLocal.clearDeletedTodos());
      });

      test('commitTodos 실패 시 예외를 던져야 한다', () async {
        final emptyTodos = <Todo>[];
        
        when(mockLocal.getUnsyncedTodos()).thenReturn(emptyTodos);
        when(mockLocal.getDeletedTodos()).thenReturn(emptyTodos);
        when(mockRemote.commitTodos(emptyTodos, emptyTodos))
            .thenAnswer((_) => Future.value(false));

        expect(repository.commitTodos(), throwsException);
        
        verify(mockLocal.getUnsyncedTodos());
        verify(mockLocal.getDeletedTodos());
        verify(mockRemote.commitTodos(emptyTodos, emptyTodos));
      });
    });
  });
}