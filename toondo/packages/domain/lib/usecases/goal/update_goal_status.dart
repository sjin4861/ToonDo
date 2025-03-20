import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoalStatusUseCase {
  final GoalRepository repository;

  UpdateGoalStatusUseCase({required this.repository});

  Future<void> call(Goal goal, Status newStatus) async {
    await repository.updateGoalStatus(goal, newStatus);
  }
}
