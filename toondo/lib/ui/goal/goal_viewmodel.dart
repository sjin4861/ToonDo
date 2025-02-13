// ...기존 코드와 동일...
import 'package:flutter/material.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/data/models/goal_status.dart';
import 'package:toondo/services/goal_service.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalService goalService;

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  GoalViewModel({required this.goalService}) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    try {
      _goals = await goalService.loadGoals();
      notifyListeners();
    } catch (e) {
      print('Error loading goals: $e');
    }
  }

  Future<void> addGoal(Goal goal) async {
    try {
      final newGoal = await goalService.createGoal(goal);
      _goals.add(newGoal);
      notifyListeners();
    } catch (e) {
      print('Error adding goal: $e');
      rethrow;
    }
  }

  Future<void> updateGoal(Goal updatedGoal) async {
    try {
      await goalService.updateGoal(updatedGoal);
      final index = _goals.indexWhere((g) => g.id == updatedGoal.id);
      if (index != -1) {
        _goals[index] = updatedGoal;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating goal: $e');
      rethrow;
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await goalService.deleteGoal(goalId);
      _goals.removeWhere((g) => g.id == goalId);
      notifyListeners();
    } catch (e) {
      print('Error deleting goal: $e');
      rethrow;
    }
  }

  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    try {
      await goalService.updateProgress(goalId, newProgress);
      final goal = _goals.firstWhere((g) => g.id == goalId);
      goal.progress = newProgress;
      notifyListeners();
    } catch (e) {
      print('Error updating goal progress: $e');
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      goal.status = GoalStatus.givenUp;
      await updateGoal(goal);
    } catch (e) {
      print('Error giving up goal: $e');
    }
  }

  Future<void> completeGoal(String goalId) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      goal.status = GoalStatus.completed;
      goal.progress = 100.0;
      goal.isCompleted = true;
      await updateGoal(goal);
    } catch (e) {
      print('Error completing goal: $e');
    }
  }

  Goal? getGoalById(String id) {
    return _goals.firstWhere((g) => g.id == id);
  }
}
