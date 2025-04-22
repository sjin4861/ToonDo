import 'package:mockito/mockito.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:domain/entities/todo.dart';

class MockTodoLocalDatasource extends Mock implements TodoLocalDatasource {
  @override
  List<Todo> getAllTodos() => super.noSuchMethod(
        Invocation.method(#getAllTodos, []),
        returnValue: <Todo>[],
      ) as List<Todo>;

  @override
  Future<void> clearTodos() => super.noSuchMethod(
        Invocation.method(#clearTodos, []),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<bool> saveTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#saveTodo, [todo]),
        returnValue: Future.value(false),
      ) as Future<bool>;

  @override
  Future<void> updateTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#updateTodo, [todo]),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<void> deleteTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#deleteTodo, [todo]),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  List<Todo> getUnsyncedTodos() => super.noSuchMethod(
        Invocation.method(#getUnsyncedTodos, []),
        returnValue: <Todo>[],
      ) as List<Todo>;

  @override
  List<Todo> getDeletedTodos() => super.noSuchMethod(
        Invocation.method(#getDeletedTodos, []),
        returnValue: <Todo>[],
      ) as List<Todo>;

  @override
  Future<void> clearDeletedTodos() => super.noSuchMethod(
        Invocation.method(#clearDeletedTodos, []),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<void> syncTodos(List<Todo> committedTodos) => super.noSuchMethod(
        Invocation.method(#syncTodos, [committedTodos]),
        returnValue: Future.value(),
      ) as Future<void>;
}