// lib/viewmodels/goal/goal_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:uuid/uuid.dart';

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
      // 에러 처리
      print('Error loading goals: $e');
    }
  }

  Future<void> addGoal(Goal goal) async {
    try {
      final newGoal = await goalService.createGoal(goal);
      _goals.add(newGoal);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print('Error adding goal: $e');
      throw e;
    }
  }

  Future<void> updateGoal(Goal updatedGoal) async {
    try {
      await goalService.updateGoal(updatedGoal);
      int index = _goals.indexWhere((goal) => goal.id == updatedGoal.id);
      if (index != -1) {
        _goals[index] = updatedGoal;
        notifyListeners();
      }
    } catch (e) {
      // 에러 처리
      print('Error updating goal: $e');
      throw e;
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await goalService.deleteGoal(id);
      _goals.removeWhere((goal) => goal.id.toString() == id);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print('Error deleting goal: $e');
      throw e;
    }
  }

  // 특정 목표 가져오기
  Goal? getGoalById(String id) {
    return _goals.firstWhere((goal) => goal.id.toString() == id, orElse: () => Goal(name: '', startDate: DateTime.now(), endDate: DateTime.now()));
  }
}