import 'package:domain/repositories/todo_repository.dart';

class CommitTodos {
  final TodoRepository repository;

  CommitTodos(this.repository);

  Future<bool> call() async {
    return await repository.commitTodos();
  }
}