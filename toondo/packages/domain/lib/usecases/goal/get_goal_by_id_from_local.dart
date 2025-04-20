import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGoalByIdFromLocalUseCase {
  final GoalRepository repository;

  GetGoalByIdFromLocalUseCase(this.repository);

  Future<Goal?> call(String goalId) async {
    final List<Goal> goals = repository.getGoalsLocal();
    for (final goal in goals) {
      if (goal.id == goalId) {
        return goal;
      }
    }
    return null;
  }
}