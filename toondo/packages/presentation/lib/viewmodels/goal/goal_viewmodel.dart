import 'package:domain/usecases/goal/read_goals.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal.dart';
import 'package:domain/usecases/goal/update_goal.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GoalViewModel extends ChangeNotifier {
  final ReadGoalsUseCase fetchGoalsUseCase;
  final CreateGoalUseCase createGoalUseCase;
  final UpdateGoalUseCase updateGoalUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  GoalViewModel({
    required this.fetchGoalsUseCase,
    required this.createGoalUseCase,
    required this.updateGoalUseCase,
    required this.deleteGoalUseCase,
  });

  Future<void> loadGoals() async {
    _goals = await fetchGoalsUseCase();
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    final created = await createGoalUseCase(goal);
    _goals.add(created);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    await updateGoalUseCase(goal);
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalUseCase(goalId);
    _goals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }
}
