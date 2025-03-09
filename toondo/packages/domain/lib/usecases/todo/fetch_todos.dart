import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';

class FetchTodosUseCase {
  final TodoRepository repository;

  FetchTodosUseCase(this.repository);

  Future<List<Todo>> call() async {
    return await repository.fetchTodos();
  }
}
