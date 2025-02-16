import 'package:injectable/injectable.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class AddGoalUseCase {
  final GoalRepository repository;

  AddGoalUseCase(this.repository);

  Future<void> call(Goal goal) {
    return repository.addGoal(goal);
  }
}
