import 'package:domain/repositories/goal_repository.dart';
import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/entities/goal.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDatasource localDatasource;
  final GoalRemoteDataSource remoteDatasource;

  GoalRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<List<Goal>> readGoals() async {
    final goals = await remoteDatasource.readGoals();
    await localDatasource.clearGoals();
    for (var goal in goals) {
      await localDatasource.saveGoal(goal);
    }
    return goals;
  }

  @override
  Future<Goal> createGoal(Goal goal) async {
    final createdGoal = await remoteDatasource.createGoal(goal);
    await localDatasource.saveGoal(createdGoal);
    return createdGoal;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    await remoteDatasource.updateGoal(goal);
    await localDatasource.updateGoal(goal);
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await remoteDatasource.deleteGoal(goalId);
    await localDatasource.deleteGoal(goalId); // 로컬에서도 삭제
  }

  @override
  List<Goal> getLocalGoals() {
    return localDatasource.getAllGoals();
  }
}
