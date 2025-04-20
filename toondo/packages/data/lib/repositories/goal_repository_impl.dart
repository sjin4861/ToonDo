import 'package:domain/entities/status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/entities/goal.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDatasource localDatasource;
  final GoalRemoteDataSource remoteDatasource;

  GoalRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  // 로컬 전용 CRUD
  @override
  List<Goal> getGoalsLocal() {
    return localDatasource.getAllGoals();
  }

  @override
  Future<Goal?> getGoalByIdLocal(String goalId) async {
    final list = localDatasource.getAllGoals();
    return list.firstWhere((g) => g.id == goalId);
  }

  @override
  Future<void> saveGoalLocal(Goal goal) async {
    await localDatasource.saveGoal(goal);
  }

  @override
  Future<void> updateGoalLocal(Goal goal) async {
    await localDatasource.updateGoal(goal);
  }

  @override
  Future<void> deleteGoalLocal(String goalId) async {
    await localDatasource.deleteGoal(goalId);
  }

  // 원격 전용 CRUD
  @override
  Future<List<Goal>> fetchGoalsRemote() async {
    return await remoteDatasource.readGoals();
  }

  @override
  Future<Goal> createGoalRemote(Goal goal) async {
    return await remoteDatasource.createGoal(goal);
  }

  @override
  Future<bool> updateGoalStatusRemote(Goal goal, Status newStatus) async {
    return await remoteDatasource.updateGoalStatus(goal, newStatus);
  }

  @override
  Future<bool> updateGoalProgressRemote(Goal goal, double newProgress) async {
    return await remoteDatasource.updateGoalProgress(goal, newProgress);
  }

  @override
  Future<void> updateGoalRemote(Goal goal) async {
    await remoteDatasource.updateGoal(goal);
  }

  @override
  Future<void> deleteGoalRemote(String goalId) async {
    await remoteDatasource.deleteGoal(goalId);
  }
}
