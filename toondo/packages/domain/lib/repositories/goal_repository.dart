import 'package:domain/entities/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> readGoals();
  Future<Goal> createGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(String goalId);
  List<Goal> getLocalGoals();
}
