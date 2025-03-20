import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddTodoUseCase {
  final TodoRepository repository;
  AddTodoUseCase(this.repository);

  Future<void> call(Todo todo) {
    return repository.createTodo(todo);
  }
}
