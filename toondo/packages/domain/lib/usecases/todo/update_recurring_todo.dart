import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateRecurringTodoUseCase {
  final TodoRepository repository;

  UpdateRecurringTodoUseCase(this.repository);

  Future<void> call(Todo series) async {
    assert(series.recurrence != null);
    await repository.updateTodo(series);
  }
}
