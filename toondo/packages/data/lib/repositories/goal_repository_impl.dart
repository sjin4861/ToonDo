import 'package:domain/repositories/goal_repository.dart';
import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/entities/goal.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDatasource localDatasource;
  final GoalRemoteDataSource remoteDatasource;

  GoalRepository({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  Future<List<Goal>> readGoals() async {
    final goals = await remoteDatasource.readGoals();
    await localDatasource.clearGoals();
    for (var goal in goals) {
      await localDatasource.saveGoal(goal);
    }
    return goals;
  }

  Future<Goal> createGoal(Goal goal) async {
    final createdGoal = await remoteDatasource.createGoal(goal);
    await localDatasource.saveGoal(createdGoal);
    return createdGoal;
  }

  Future<void> updateGoal(Goal goal) async {
    await remoteDatasource.updateGoal(goal);
    await localDatasource.updateGoal(goal);
  }

  Future<void> deleteGoal(String goalId) async {
    await remoteDatasource.deleteGoal(goalId);
    // 삭제 후 로컬에서도 제거 (goalBox.delete 사용)
    // ...existing code for local deletion...
  }

  List<Goal> getLocalGoals() {
    return localDatasource.getAllGoals();
  }
}
