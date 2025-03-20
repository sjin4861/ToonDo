import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}
