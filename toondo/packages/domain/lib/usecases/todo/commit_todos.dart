import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommitTodosUseCase {
  final TodoRepository repository;

  CommitTodosUseCase(this.repository);

  Future<bool> call() async {
    return await repository.commitTodos();
  }
}
