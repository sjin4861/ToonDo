import 'package:domain/entities/todo.dart';

abstract class TodoRepository {
  List<Todo> getLocalTodos();
  Future<void> deleteTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<bool> createTodo(Todo todo);
  Future<bool> commitTodos();
  Future<List<Todo>> fetchTodos();
}