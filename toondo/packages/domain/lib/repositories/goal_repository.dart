import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';

abstract class GoalRepository {
  Future<List<Goal>> readGoals();
  Future<Goal> createGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(String goalId);
  List<Goal> getLocalGoals();
  Future<bool> updateGoalStatus(Goal goal, Status newStatus);
  Future<bool> updateGoalProgress(Goal goal, double newProgress);
}
