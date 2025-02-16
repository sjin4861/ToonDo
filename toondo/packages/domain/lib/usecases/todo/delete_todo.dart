import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(Todo todo) async {
    await repository.deleteTodo(todo);
  }
}