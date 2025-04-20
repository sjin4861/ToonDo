import 'package:injectable/injectable.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class DeleteGoalRemoteUseCase {
  final GoalRepository repository;
  DeleteGoalRemoteUseCase(this.repository);

  Future<void> call(String goalId) async {
    await repository.deleteGoalRemote(goalId);
  }
}