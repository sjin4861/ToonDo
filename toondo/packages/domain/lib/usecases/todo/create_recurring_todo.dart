import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateRecurringTodoUseCase {
  final TodoRepository repository;

  CreateRecurringTodoUseCase(this.repository);

  Future<bool> call(Todo seriesTemplate) async {
    assert(seriesTemplate.recurrence != null,
        'CreateRecurringTodoUseCase requires a recurrence rule');
    assert(seriesTemplate.seriesId == null,
        'Series template must not carry a seriesId');
    return repository.createTodo(seriesTemplate);
  }
}
