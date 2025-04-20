import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:mockito/mockito.dart';

class MockTodoRepository extends Mock implements TodoRepository {
  @override
  List<Todo> getLocalTodos() {
    return super.noSuchMethod(
      Invocation.method(#getLocalTodos, []),
      returnValue: <Todo>[],
      returnValueForMissingStub: <Todo>[],
    );
  }
  
  @override
  Future<void> deleteTodo(Todo todo) {
    return super.noSuchMethod(
      Invocation.method(#deleteTodo, [todo]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> updateTodo(Todo todo) {
    return super.noSuchMethod(
      Invocation.method(#updateTodo, [todo]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<bool> createTodo(Todo todo) {
    return super.noSuchMethod(
      Invocation.method(#createTodo, [todo]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
  
  @override
  Future<bool> commitTodos() {
    return super.noSuchMethod(
      Invocation.method(#commitTodos, []),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
  
  @override
  Future<List<Todo>> fetchTodos() {
    return super.noSuchMethod(
      Invocation.method(#fetchTodos, []),
      returnValue: Future.value(<Todo>[]),
      returnValueForMissingStub: Future.value(<Todo>[]),
    );
  }
  
  @override
  Future<void> updateTodoDates(Todo todo, DateTime newStartDate, DateTime newEndDate) {
    return super.noSuchMethod(
      Invocation.method(#updateTodoDates, [todo, newStartDate, newEndDate]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> updateTodoStatus(Todo todo, double status) {
    return super.noSuchMethod(
      Invocation.method(#updateTodoStatus, [todo, status]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}