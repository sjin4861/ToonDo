import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal.dart';
import 'package:domain/usecases/goal/update_goal.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:domain/usecases/goal/read_goals.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoalViewModel extends ChangeNotifier {
  final CreateGoal _createGoalUseCase;
  final UpdateGoal _updateGoalUseCase;
  final DeleteGoal _deleteGoalUseCase;
  final ReadGoals _readGoalsUseCase;

  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  GoalViewModel(
    this._createGoalUseCase,
    this._updateGoalUseCase,
    this._deleteGoalUseCase,
    this._readGoalsUseCase,
  ) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    _goals = await _readGoalsUseCase();
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    final newGoal = await _createGoalUseCase(goal);
    _goals.add(newGoal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    await _updateGoalUseCase(goal);
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    await _deleteGoalUseCase(goalId);
    _goals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }
}
