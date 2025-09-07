import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllTodosUseCase {
  final TodoRepository repository;
  GetAllTodosUseCase(this.repository);

  Future<List<Todo>> call() async {
    return repository.getLocalTodos();
  }
}
