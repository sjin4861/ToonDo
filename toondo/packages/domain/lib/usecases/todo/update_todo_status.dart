import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:injectable/injectable.dart'; // assuming this exposes a function type or class

@injectable
class UpdateTodoStatusUseCase {
  final TodoRepository repository;

  UpdateTodoStatusUseCase(this.repository);

  Future<void> call(Todo todo, double status) async {
    await repository.updateTodoStatus(todo, status);
  }
}
