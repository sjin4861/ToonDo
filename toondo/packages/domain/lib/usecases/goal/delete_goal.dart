import 'package:injectable/injectable.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class DeleteGoalUseCase {
  final GoalRepository repository;

  DeleteGoalUseCase(this.repository);

  Future<void> call(int goalId) {
    return repository.deleteGoal(goalId);
  }
}
