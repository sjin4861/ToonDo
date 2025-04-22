import 'package:injectable/injectable.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class DeleteGoalLocalUseCase {
  final GoalRepository repository;
  DeleteGoalLocalUseCase(this.repository);

  Future<void> call(String goalId) async {
    await repository.deleteGoalLocal(goalId);
  }
}