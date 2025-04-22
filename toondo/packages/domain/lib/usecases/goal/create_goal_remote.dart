import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateGoalRemoteUseCase {
  final GoalRepository repository;
  CreateGoalRemoteUseCase(this.repository);

  Future<Goal> call(Goal goal) async {
    return repository.createGoalRemote(goal);
  }
}