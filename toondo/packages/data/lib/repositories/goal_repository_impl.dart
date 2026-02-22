import 'package:domain/entities/status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:data/constants.dart';
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
    if (!Constants.remoteApiEnabled) {
      return localDatasource.getAllGoals();
    }

    final remoteGoals = await remoteDatasource.readGoals();
    for (final goal in remoteGoals) {
      await localDatasource.saveGoal(goal);
    }
    return remoteGoals;
  }

  @override
  Future<Goal> createGoalRemote(Goal goal) async {
    if (Constants.remoteApiEnabled) {
      final created = await remoteDatasource.createGoal(goal);
      await localDatasource.saveGoal(created);
      return created;
    }

    final goalToSave = goal.id.isNotEmpty
        ? goal
        : goal.copyWith(id: 'LOCAL-${DateTime.now().millisecondsSinceEpoch}');
    await localDatasource.saveGoal(goalToSave);
    return goalToSave;
  }

  @override
  Future<bool> updateGoalStatusRemote(Goal goal, Status newStatus) async {
    if (Constants.remoteApiEnabled) {
      final ok = await remoteDatasource.updateGoalStatus(goal, newStatus);
      if (ok) {
        final updatedGoal = goal.copyWith(
          status: newStatus,
          progress: newStatus == Status.completed ? 100.0 : goal.progress,
        );
        await localDatasource.updateGoal(updatedGoal);
      }
      return ok;
    }

    await localDatasource.updateGoalStatus(goal, newStatus);
    if (newStatus == Status.completed) {
      final updatedGoal = goal.copyWith(status: newStatus, progress: 100.0);
      await localDatasource.updateGoal(updatedGoal);
    }
    return true;
  }

  @override
  Future<bool> updateGoalProgressRemote(Goal goal, double newProgress) async {
    if (Constants.remoteApiEnabled) {
      final ok = await remoteDatasource.updateGoalProgress(goal, newProgress);
      if (ok) {
        final updatedGoal = goal.copyWith(progress: newProgress);
        await localDatasource.updateGoal(updatedGoal);
      }
      return ok;
    }

    final updatedGoal = goal.copyWith(progress: newProgress);
    await localDatasource.updateGoal(updatedGoal);
    return true;
  }

  @override
  Future<void> updateGoalRemote(Goal goal) async {
    if (Constants.remoteApiEnabled) {
      await remoteDatasource.updateGoal(goal);
    }
    await localDatasource.updateGoal(goal);
  }

  @override
  Future<void> deleteGoalRemote(String goalId) async {
    if (Constants.remoteApiEnabled) {
      await remoteDatasource.deleteGoal(goalId);
    }
    await localDatasource.deleteGoal(goalId);
  }
}
