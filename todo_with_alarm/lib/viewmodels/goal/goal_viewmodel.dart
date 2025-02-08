// lib/viewmodels/goal/goal_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import 'package:todo_with_alarm/services/goal_service.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalService goalService;

  // 전체 Goal 목록
  List<Goal> _goals = [];

  List<Goal> get goals => _goals; // 필터 없이 전체 목록

  GoalViewModel({required this.goalService}) {
    loadGoals();
  }

  /// --------------------------
  /// 1) 목표 목록 로딩
  /// --------------------------
  Future<void> loadGoals() async {
    try {
      _goals = await goalService.loadGoals();
      notifyListeners(); // 목록 업데이트
    } catch (e) {
      print('Error loading goals: $e');
    }
  }

  /// --------------------------
  /// 2) 목표 CRUD
  /// --------------------------
  
  // CREATE
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

  // UPDATE
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

  // DELETE
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

  /// --------------------------
  /// 3) 기타 기능
  /// --------------------------

  // 진행률 변경
  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    try {
      await goalService.updateProgress(goalId, newProgress);
      final goal = _goals.firstWhere((g) => g.id == goalId);
      if (goal != null) {
        goal.progress = newProgress;
      }
      notifyListeners();
    } catch (e) {
      print('Error updating goal progress: $e');
    }
  }

  // 목표 포기
  Future<void> giveUpGoal(String goalId) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      if (goal != null) {
        goal.status = GoalStatus.givenUp;
        await updateGoal(goal);
      }
    } catch (e) {
      print('Error giving up goal: $e');
    }
  }

  // 목표 완료
  Future<void> completeGoal(String goalId) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      if (goal != null) {
        goal.status = GoalStatus.completed;
        goal.progress = 100.0;
        goal.isCompleted = true;
        await updateGoal(goal);
      }
    } catch (e) {
      print('Error completing goal: $e');
    }
  }

  // 특정 목표 가져오기
  Goal? getGoalById(String id) {
    return _goals.firstWhere(
      (g) => g.id == id,
    );
  }
}