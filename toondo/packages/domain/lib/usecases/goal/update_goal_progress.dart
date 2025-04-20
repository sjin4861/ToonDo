import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoalProgressUseCase {
  final GoalRepository repository;
  UpdateGoalProgressUseCase(this.repository);

  Future<bool> call(Goal goal, double newProgress) {
    return repository.updateGoalProgressRemote(goal, newProgress);
  }
}