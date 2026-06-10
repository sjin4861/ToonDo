import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteRecurringTodoUseCase {
  final TodoRepository repository;

  DeleteRecurringTodoUseCase(this.repository);

  Future<void> call(String seriesId) async {
    await repository.deleteSeries(seriesId);
  }
}
