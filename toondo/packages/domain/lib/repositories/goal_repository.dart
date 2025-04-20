import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';

abstract class GoalRepository {
  // 로컬 전용 CRUD
  List<Goal> getGoalsLocal();
  Future<Goal?> getGoalByIdLocal(String goalId);
  Future<void> saveGoalLocal(Goal goal);
  Future<void> updateGoalLocal(Goal goal);
  Future<void> deleteGoalLocal(String goalId);

  // 원격 전용 CRUD
  Future<List<Goal>> fetchGoalsRemote();
  Future<Goal> createGoalRemote(Goal goal);
  Future<bool> updateGoalStatusRemote(Goal goal, Status newStatus);
  Future<bool> updateGoalProgressRemote(Goal goal, double newProgress);
  Future<void> updateGoalRemote(Goal goal);
  Future<void> deleteGoalRemote(String goalId);
}
