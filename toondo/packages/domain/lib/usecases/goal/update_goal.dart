import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoal {
  final GoalRepository repository;

  UpdateGoal(this.repository);

  Future<void> call(Goal goal) async {
    await repository.updateGoal(goal);
  }
}
