// lib/viewmodels/goal/goal_management_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import '../../models/goal.dart';
import '../../services/goal_service.dart';

class GoalManagementViewModel extends ChangeNotifier {
  final GoalService goalService;
  List<Goal> allGoals = [];
  List<Goal> filteredGoals = [];
  String filter = '전체';
  // 서브 필터 없이 '완료' 탭에서만 두 가지 상태를 표시하도록 수정

  GoalManagementViewModel(this.goalService) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    allGoals = await goalService.loadGoals();
    applyFilter();
  }

  void setFilter(String newFilter) {
    filter = newFilter;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    if (filter == '전체') {
      filteredGoals = allGoals;
    } else if (filter == '완료') {
      // '완료' 탭에서는 status가 completed 또는 givenUp인 목표만 필터링
      filteredGoals = allGoals.where((goal) =>
          goal.status == GoalStatus.completed ||
          goal.status == GoalStatus.givenUp).toList();
    }
    notifyListeners();
  }

  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    Goal? goal = allGoals.firstWhere((goal) => goal.id == goalId);
    if (goal != null) {
      goal.progress = newProgress;
      await goalService.updateGoal(goal);
      notifyListeners();
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    Goal? goal = allGoals.firstWhere((goal) => goal.id == goalId);
    if (goal != null) {
      goal.status = GoalStatus.givenUp;
      await goalService.updateGoal(goal);
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    await goalService.deleteGoal(goalId);
    await loadGoals(); // 목표 목록 다시 로드
  }

  Future<void> completeGoal(String goalId) async {
    Goal? goal = allGoals.firstWhere((goal) => goal.id == goalId);
    if (goal != null) {
      goal.status = GoalStatus.completed;
      goal.progress = 100.0;
      goal.isCompleted = true;
      await goalService.updateGoal(goal);
      notifyListeners();
    }
  }
}