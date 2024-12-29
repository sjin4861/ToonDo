// lib/viewmodels/goal/goal_management_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../services/goal_service.dart';

class GoalManagementViewModel extends ChangeNotifier {
  final GoalService goalService;
  List<Goal> allGoals = [];
  List<Goal> filteredGoals = [];
  String filter = '전체';

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
      filteredGoals = allGoals.where((goal) => goal.isCompleted).toList();
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
    await goalService.giveUpGoal(goalId);
    await loadGoals(); // 목표 목록 다시 로드
  }
  // 기타 필요한 메서드 추가
}