import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoalProgressUseCase {
  final GoalRepository repository;
  UpdateGoalProgressUseCase({required this.repository});

  Future<void> call(Goal goal, double newProgress) async {
    await repository.updateGoalProgress(goal, newProgress);
  }
}
