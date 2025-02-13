import 'package:mockito/mockito.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/data/repositories/todo_repository.dart';

class MockTodoRepository extends Mock implements TodoRepository {
  @override
  Future<List<Todo>> fetchTodos() => super.noSuchMethod(
        Invocation.method(#fetchTodos, []),
        returnValue: Future<List<Todo>>.value(<Todo>[]),
        returnValueForMissingStub: Future<List<Todo>>.value(<Todo>[]),
      ) as Future<List<Todo>>;

  @override
  Future<bool> commitTodos() => super.noSuchMethod(
        Invocation.method(#commitTodos, []),
        returnValue: Future<bool>.value(true),
        returnValueForMissingStub: Future<bool>.value(true),
      ) as Future<bool>;

  @override
  Future<bool> createTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#createTodo, [todo]),
        returnValue: Future<bool>.value(true),
        returnValueForMissingStub: Future<bool>.value(true),
      ) as Future<bool>;

  @override
  Future<void> updateTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#updateTodo, [todo]),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as Future<void>;

  @override
  Future<void> deleteTodo(Todo todo) => super.noSuchMethod(
        Invocation.method(#deleteTodo, [todo]),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as Future<void>;

  @override
  List<Todo> getLocalTodos() => super.noSuchMethod(
        Invocation.method(#getLocalTodos, []),
        returnValue: <Todo>[],
        returnValueForMissingStub: <Todo>[],
      ) as List<Todo>;
}
