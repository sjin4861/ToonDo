import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateGoalUseCase {
  final GoalRepository repository;

  CreateGoalUseCase(this.repository);

  Future<Goal> call(Goal goal) async {
    return await repository.createGoal(goal);
  }
}
