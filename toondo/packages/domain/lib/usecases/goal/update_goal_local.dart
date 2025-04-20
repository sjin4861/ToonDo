import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoalLocalUseCase {
  final GoalRepository repository;
  UpdateGoalLocalUseCase(this.repository);

  Future<void> call(Goal goal) async {
    await repository.updateGoalLocal(goal);
  }
}