import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoDates {
  final TodoRepository repository;
  UpdateTodoDates(this.repository);

  Future<void> call(
    Todo todo,
    DateTime newStartDate,
    DateTime newEndDate,
  ) async {
    repository.updateTodoDates(todo, newStartDate, newEndDate);
  }
}
