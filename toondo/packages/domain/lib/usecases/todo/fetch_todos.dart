import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';

class FetchTodos {
  final TodoRepository repository;

  FetchTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.fetchTodos();
  }
}