import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:toondo/viewmodels/goal/goal_filter_option.dart';
import 'package:domain/usecases/goal/read_goals.dart';
import 'package:domain/usecases/goal/update_goal.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:injectable/injectable.dart';

enum GoalManagementFilterOption { inProgress, completed }

@LazySingleton()
class GoalManagementViewModel extends ChangeNotifier {
  final ReadGoalsUseCase readGoalsUseCase;
  final UpdateGoalUseCase updateGoalUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;

  List<Goal> _allGoals = [];
  List<Goal> _filteredGoals = [];
  List<Goal> get filteredGoals => _filteredGoals;

  GoalManagementFilterOption _filterOption =
      GoalManagementFilterOption.inProgress;
  GoalManagementFilterOption get filterOption => _filterOption;

  GoalManagementViewModel({
    required this.readGoalsUseCase,
    required this.updateGoalUseCase,
    required this.deleteGoalUseCase,
  }) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    _allGoals = await readGoalsUseCase();
    applyFilter();
  }

  void setFilterOption(GoalManagementFilterOption newFilterOption) {
    _filterOption = newFilterOption;
    applyFilter();
  }

  void applyFilter() {
    if (_filterOption == GoalManagementFilterOption.inProgress) {
      _filteredGoals = _allGoals.where((g) => g.status.isInProgress).toList();
    } else {
      _filteredGoals = _allGoals.where((g) => g.status.isCompleted).toList();
    }
    notifyListeners();
  }

  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    // Retrieve the goal and update its progress property as needed.
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    final updatedGoal = goal.copyWith(progress: newProgress);
    await updateGoalUseCase(updatedGoal);
    final index = _allGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _allGoals[index] = updatedGoal;
      applyFilter();
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    final updatedGoal = goal.copyWith(status: goal.status.givenUp);
    await updateGoalUseCase(updatedGoal);
    final index = _allGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _allGoals[index] = updatedGoal;
      applyFilter();
    }
  }

  Future<void> completeGoal(String goalId) async {
    final goal = _allGoals.firstWhere((g) => g.id == goalId);
    final updatedGoal = goal.copyWith(status: goal.status.completed);
    await updateGoalUseCase(updatedGoal);
    final index = _allGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _allGoals[index] = updatedGoal;
      applyFilter();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalUseCase(goalId);
    _allGoals.removeWhere((g) => g.id == goalId);
    applyFilter();
  }
}
