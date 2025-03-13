import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:domain/usecases/goal/update_goal.dart';
import 'package:domain/usecases/goal/read_goals.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/get_givenup_goals.dart';
import 'package:domain/usecases/goal/get_completed_goals.dart';
import 'package:domain/usecases/goal/update_goal_progress.dart';
import 'package:domain/usecases/goal/update_goal_status.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/status.dart';

enum GoalManagementFilterOption { inProgress, givenUp, completed }

@LazySingleton()
class GoalManagementViewModel extends ChangeNotifier {
  final ReadGoalsUseCase readGoalsUseCase;
  final UpdateGoalUseCase updateGoalUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;
  final GetInProgressGoalsUseCase getInProgressGoalsUseCase;
  final GetGivenUpGoalsUseCase getGivenUpGoalsUseCase;
  final GetCompletedGoalsUseCase getCompletedGoalsUseCase;
  final UpdateGoalProgressUseCase updateGoalProgressUseCase;
  final UpdateGoalStatusUseCase updateGoalStatusUseCase;

  List<Goal> _allGoals = [];
  List<Goal> _filteredGoals = [];
  List<Goal> get filteredGoals => _filteredGoals;

  GoalManagementFilterOption _filterOption = GoalManagementFilterOption.inProgress;
  GoalManagementFilterOption get filterOption => _filterOption;

  GoalManagementViewModel({
    required this.readGoalsUseCase,
    required this.updateGoalUseCase,
    required this.deleteGoalUseCase,
    required this.getInProgressGoalsUseCase,
    required this.getGivenUpGoalsUseCase,
    required this.getCompletedGoalsUseCase,
    required this.updateGoalProgressUseCase,
    required this.updateGoalStatusUseCase,
  }) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    // 전체 목표 목록 업데이트 (옵션)
    _allGoals = await readGoalsUseCase();
    await applyFilter();
  }

  void setFilterOption(GoalManagementFilterOption newFilterOption) {
    _filterOption = newFilterOption;
    applyFilter();
  }

  Future<void> applyFilter() async {
    switch (_filterOption) {
      case GoalManagementFilterOption.inProgress:
        _filteredGoals = await getInProgressGoalsUseCase();
        break;
      case GoalManagementFilterOption.givenUp:
        _filteredGoals = await getGivenUpGoalsUseCase();
        break;
      case GoalManagementFilterOption.completed:
        _filteredGoals = await getCompletedGoalsUseCase();
        break;
    }
    notifyListeners();
  }

  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    // 신규 UpdateGoalProgressUseCase로 진행률 업데이트
    await updateGoalProgressUseCase(goal, newProgress);
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    // 신규 UpdateGoalStatusUseCase로 포기 상태 업데이트
    await updateGoalStatusUseCase(goal, Status.givenUp);
  }

  Future<void> completeGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    await updateGoalStatusUseCase(goal, Status.completed);
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalUseCase(goalId);
    applyFilter();
  }
}
