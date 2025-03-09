import 'package:injectable/injectable.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class DeleteGoalUseCase {
  final GoalRepository repository;

  DeleteGoalUseCase(this.repository);

  Future<void> call(String goalId) async {
    await repository.deleteGoal(goalId);
  }
}
