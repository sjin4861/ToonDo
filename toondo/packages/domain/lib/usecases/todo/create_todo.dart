import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTodoUseCase {
  final TodoRepository repository;

  CreateTodoUseCase(this.repository);

  Future<bool> call(Todo todo) async {
    return await repository.createTodo(todo);
  }
}
