import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}