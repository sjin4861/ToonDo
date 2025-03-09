import 'package:domain/entities/goal.dart';
import 'package:domain/entities/goal_status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoalStatusUseCase {
  final GoalRepository repository;

  UpdateGoalStatusUseCase({required this.repository});

  Future<bool> call(Goal goal, GoalStatus newStatus) async {
    await repository.updateGoalStatus(goal, newStatus);
  }
}
