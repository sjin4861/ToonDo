import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import '../../models/goal.dart';
import '../../services/goal_service.dart';

// (1) 2가지 필터옵션
enum GoalFilterOption {
  inProgress,
  completed,
}

class GoalManagementViewModel extends ChangeNotifier {
  final GoalService goalService;

  List<Goal> allGoals = [];
  List<Goal> filteredGoals = [];

  // 기본 필터: "진행 중"
  GoalFilterOption filterOption = GoalFilterOption.inProgress;

  GoalManagementViewModel(this.goalService) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    allGoals = await goalService.loadGoals();
    applyFilter();
  }

  // (2) 필터옵션 변경
  void setFilterOption(GoalFilterOption newFilterOption) {
    filterOption = newFilterOption;
    applyFilter();
  }

  // (3) Extension으로 GoalStatus를 간단히 분류
  void applyFilter() {
    if (filterOption == GoalFilterOption.inProgress) {
      // 진행 중: status.isInProgress == true (즉 active)
      filteredGoals = allGoals.where((goal) => goal.status.isInProgress).toList();
    } else {
      // GoalFilterOption.completed
      // 진행 완료: status.isCompleted == true (즉 completed or givenUp)
      filteredGoals = allGoals.where((goal) => goal.status.isCompleted).toList();
    }

    notifyListeners();
  }

  // 이하 목표 진행도 / 포기 / 삭제 / 완료 메서드는 동일
  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    final goal = allGoals.firstWhere((g) => g.id == goalId);
    if (goal != null) {
      goal.progress = newProgress;
      await goalService.updateGoal(goal);
      notifyListeners();
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = allGoals.firstWhere((g) => g.id == goalId);
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
    final goal = allGoals.firstWhere((g) => g.id == goalId);
    if (goal != null) {
      goal.status = GoalStatus.completed;
      goal.progress = 100.0;
      goal.isCompleted = true; // 모델에 따라
      await goalService.updateGoal(goal);
      notifyListeners();
    }
  }
}