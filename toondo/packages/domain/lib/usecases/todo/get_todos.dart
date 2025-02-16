import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTodosUseCase {
  final TodoRepository repository;
  GetTodosUseCase(this.repository);

  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}
