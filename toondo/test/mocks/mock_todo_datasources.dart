import 'package:mockito/mockito.dart';
import '../../packages/data/lib/datasources/local/todo_local_datasource.dart';
import '../../packages/data/lib/datasources/remote/todo_remote_datasource.dart';
import 'package:toondo/data/models/todo.dart';

// Mockito를 이용한 Mock 클래스 생성
class MockTodoLocalDatasource extends Mock implements TodoLocalDatasource {
  @override
  Future<bool> saveTodo(Todo todo) => super.noSuchMethod(
    Invocation.method(#saveTodo, [todo]),
    returnValue: Future.value(true),
    returnValueForMissingStub: Future.value(true),
  ) as Future<bool>;

  @override
  List<Todo> getAllTodos() => super.noSuchMethod(
    Invocation.method(#getAllTodos, []),
    returnValue: <Todo>[],
    returnValueForMissingStub: <Todo>[],
  ) as List<Todo>;

  @override
  Future<void> clearTodos() => super.noSuchMethod(
    Invocation.method(#clearTodos, []),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  ) as Future<void>;

  @override
  List<Todo> getUnsyncedTodos() => super.noSuchMethod(
    Invocation.method(#getUnsyncedTodos, []),
    returnValue: <Todo>[],
    returnValueForMissingStub: <Todo>[],
  ) as List<Todo>;

  @override
  Future<void> updateTodo(Todo todo) => super.noSuchMethod(
    Invocation.method(#updateTodo, [todo]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  ) as Future<void>;

  @override
  Future<void> deleteTodo(Todo todo) => super.noSuchMethod(
    Invocation.method(#deleteTodo, [todo]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  ) as Future<void>;

  @override
  List<Todo> getDeletedTodos() => super.noSuchMethod(
    Invocation.method(#getDeletedTodos, []),
    returnValue: <Todo>[],
    returnValueForMissingStub: <Todo>[],
  ) as List<Todo>;

  @override
  Future<void> syncTodos(List<Todo> committedTodos) => super.noSuchMethod(
    Invocation.method(#syncTodos, [committedTodos]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  ) as Future<void>;

  @override
  Future<void> clearDeletedTodos() => super.noSuchMethod(
    Invocation.method(#clearDeletedTodos, []),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  ) as Future<void>;
}

class MockTodoRemoteDatasource extends Mock implements TodoRemoteDataSource {
  @override
  Future<bool> commitTodos(List<Todo> unsyncedTodos, List<Todo> deletedTodos) => super.noSuchMethod(
    Invocation.method(#commitTodos, [unsyncedTodos, deletedTodos]),
    returnValue: Future.value(true),
    returnValueForMissingStub: Future.value(true),
  ) as Future<bool>;

  @override
  Future<List<Todo>> fetchTodos() => super.noSuchMethod(
    Invocation.method(#fetchTodos, []),
    returnValue: Future.value(<Todo>[]),
    returnValueForMissingStub: Future.value(<Todo>[]),
  ) as Future<List<Todo>>;
}
