import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';

class CreateTodo {
  final TodoRepository repository;

  CreateTodo(this.repository);

  Future<bool> call(Todo todo) async {
    return await repository.createTodo(todo);
  }
}