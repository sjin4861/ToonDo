import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateGoal {
  final GoalRepository repository;

  CreateGoal(this.repository);

  Future<Goal> call(Goal goal) async {
    return await repository.createGoal(goal);
  }
}
