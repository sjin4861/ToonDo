import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/get_givenup_goals.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/goal/get_goals_remote.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:domain/usecases/goal/delete_goal_remote.dart';
import 'package:domain/usecases/goal/delete_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_status.dart';
import 'package:domain/usecases/goal/update_goal_progress.dart';
import 'package:domain/usecases/goal/get_completed_goals.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

enum GoalManagementFilterOption { inProgress, givenUp, completed }

@LazySingleton()
class GoalManagementViewModel extends ChangeNotifier {
  final GetGoalsLocalUseCase getGoalsLocalUseCase;
  final GetGoalsRemoteUseCase getGoalsRemoteUseCase;
  final UpdateGoalRemoteUseCase updateGoalRemoteUseCase;
  final UpdateGoalLocalUseCase updateGoalLocalUseCase;
  final DeleteGoalRemoteUseCase deleteGoalRemoteUseCase;
  final DeleteGoalLocalUseCase deleteGoalLocalUseCase;
  final GetInProgressGoalsUseCase getInProgressGoalsUseCase;
  final GetCompletedGoalsUseCase getCompletedGoalsUseCase;
  final GetGivenUpGoalsUseCase getGivenUpGoalsUseCase;
  final UpdateGoalStatusUseCase updateGoalStatusUseCase;
  final UpdateGoalProgressUseCase updateGoalProgressUseCase;

  List<Goal> _allGoals = [];
  List<Goal> _filteredGoals = [];
  List<Goal> get filteredGoals => _filteredGoals;

  GoalManagementFilterOption _filterOption = GoalManagementFilterOption.inProgress;
  GoalManagementFilterOption get filterOption => _filterOption;

  GoalManagementViewModel({
    required this.getGoalsLocalUseCase,
    required this.getGoalsRemoteUseCase,
    required this.updateGoalRemoteUseCase,
    required this.updateGoalLocalUseCase,
    required this.deleteGoalRemoteUseCase,
    required this.deleteGoalLocalUseCase,
    required this.getInProgressGoalsUseCase,
    required this.getCompletedGoalsUseCase,
    required this.getGivenUpGoalsUseCase,
    required this.updateGoalStatusUseCase,
    required this.updateGoalProgressUseCase,
  }) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    _allGoals = await getGoalsLocalUseCase();
    await applyFilter();  // _filteredGoals 갱신 및 notify
  }

  Future<void> syncGoals() async {
    final remoteGoals = await getGoalsRemoteUseCase();
    for (var goal in remoteGoals) {
      await updateGoalLocalUseCase(goal);
    }
    _allGoals = await getGoalsLocalUseCase();
    notifyListeners();
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
    // 1. 서버에 진행률 업데이트
    await updateGoalProgressUseCase(goal, newProgress);
    // 2. 로컬 DB에도 진행률 저장
    final updatedGoal = Goal(
      id: goal.id,
      name: goal.name,
      icon: goal.icon,
      progress: newProgress,
      startDate: goal.startDate,
      endDate: goal.endDate,
      status: goal.status,
    );
    await updateGoalLocalUseCase(updatedGoal);
    // 3. 목록 재로드 및 필터 갱신
    await loadGoals();
    // 4. 홈 화면에도 반영
    GetIt.instance<HomeViewModel>().loadGoals();
  }

  Future<void> updateGoal(String goalId, Goal updated) async {
    await updateGoalRemoteUseCase(updated);
    await updateGoalLocalUseCase(updated);
    await loadGoals();
    GetIt.instance<HomeViewModel>().loadGoals();
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    await updateGoalStatusUseCase(goal, Status.givenUp);
    await loadGoals();
    GetIt.instance<HomeViewModel>().loadGoals();
  }

  Future<void> completeGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    await updateGoalStatusUseCase(goal, Status.completed);
    await loadGoals();
    GetIt.instance<HomeViewModel>().loadGoals();
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalRemoteUseCase(goalId);
    await deleteGoalLocalUseCase(goalId);
    await loadGoals();
    GetIt.instance<HomeViewModel>().loadGoals();
  }

  List<Goal> getCompletedGoals() {
    return _allGoals.where((g) => g.status == Status.completed).toList();
  }

  List<Goal> getGivenUpGoals() {
    return _allGoals.where((g) => g.status == Status.givenUp).toList();
  }
}
