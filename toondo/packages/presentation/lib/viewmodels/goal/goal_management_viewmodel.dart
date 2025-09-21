import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/goal/get_goals_remote.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/get_completed_goals.dart';
import 'package:domain/usecases/goal/get_givenup_goals.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/delete_goal_local.dart';
import 'package:domain/usecases/goal/delete_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_status.dart';
import 'package:domain/usecases/goal/update_goal_progress.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

enum GoalFilterType { inProgress, completed }

enum GoalCompletionFilter { all, succeeded, failed, givenUp }

@injectable
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

  List<Goal> _allGoals = [];
  List<Goal> _filteredGoals = [];

  List<Goal> get filteredGoals => _filteredGoals;

  GoalFilterType _filterType = GoalFilterType.inProgress;

  GoalFilterType get filterType => _filterType;

  GoalCompletionFilter _completionFilter = GoalCompletionFilter.all;

  GoalCompletionFilter get completionFilter => _completionFilter;

  Future<void> loadGoals() async {
    try {
      _allGoals = await getGoalsLocalUseCase();
    } catch (_) {
      _allGoals = [];
    }

    await _autoCompleteExpiredGoals();
    await applyFilter();
  }

  Future<void> syncGoals() async {
    final remoteGoals = await getGoalsRemoteUseCase();
    for (final goal in remoteGoals) {
      await updateGoalLocalUseCase(goal);
    }
    _allGoals = await getGoalsLocalUseCase();
    notifyListeners();
  }

  Future<void> setFilterType(GoalFilterType type) async {
    _filterType = type;
    await applyFilter();
  }

  Future<void> setCompletionFilter(GoalCompletionFilter filter) async {
    _completionFilter = filter;
    await applyFilter();
  }

  Future<void> applyFilter() async {
    if (_filterType == GoalFilterType.inProgress) {
      await _loadInProgressGoals();
    } else {
      await _loadCompletedGoalsWithFilter();
    }
    notifyListeners();
  }

  Future<void> _loadInProgressGoals() async {
    try {
      _filteredGoals = await getInProgressGoalsUseCase();
    } catch (_) {
      _filteredGoals = [];
    }
  }

  Future<void> _loadCompletedGoalsWithFilter() async {
    try {
      final completed = await getCompletedGoalsUseCase();

      _filteredGoals = switch (_completionFilter) {
        GoalCompletionFilter.all => completed,
        GoalCompletionFilter.succeeded =>
          completed.where((g) => g.status == Status.completed).toList(),
        GoalCompletionFilter.failed =>
          completed.where((g) => g.status == Status.failed).toList(),
        GoalCompletionFilter.givenUp =>
          completed.where((g) => g.status == Status.givenUp).toList(),
      };
    } catch (_) {
      _filteredGoals = [];
    }
  }

  Future<void> _autoCompleteExpiredGoals() async {
    final today = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    for (final goal in _allGoals) {
      // TODO: 메인화면 노출 문제 분석 - 자동 완료 로직에서 showOnHome 확인
      // '마감일 없이 할래요' 기능 - endDate가 null인 목표는 자동 완료 대상에서 제외
      if (goal.status == Status.active && goal.endDate != null && goal.endDate!.isBefore(today)) {
        print('🔍 자동 완료 대상 목표: ${goal.name} (showOnHome: ${goal.showOnHome})');
        final updatedGoal = goal.copyWith(status: Status.completed);
        await updateGoalLocalUseCase(updatedGoal);
      }
    }
  }

  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    await updateGoalProgressUseCase(goal, newProgress);

    final updated = goal.copyWith(progress: newProgress);
    await updateGoalLocalUseCase(updated);
    await loadGoals();
    _updateHomeView();
  }

  Future<void> updateGoal(String goalId, Goal updated) async {
    await updateGoalRemoteUseCase(updated);
    await updateGoalLocalUseCase(updated);
    await loadGoals();
    _updateHomeView();
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = _getGoalById(goalId);
    await updateGoalStatusUseCase(goal, Status.givenUp);
    await loadGoals();
    _updateHomeView();
  }

  Future<void> completeGoal(String goalId) async {
    final goal = _getGoalById(goalId);
    await updateGoalStatusUseCase(goal, Status.completed);
    await loadGoals();
    await applyFilter();
    _updateHomeView();
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalRemoteUseCase(goalId);
    await deleteGoalLocalUseCase(goalId);
    await loadGoals();
    _updateHomeView();
  }

  Goal _getGoalById(String id) => _allGoals.firstWhere(
    (g) => g.id == id,
    orElse: () => throw Exception("Goal not found"),
  );

  void _updateHomeView() {
    try {
      GetIt.instance<HomeViewModel>().loadGoals();
    } catch (_) {}
  }
}
