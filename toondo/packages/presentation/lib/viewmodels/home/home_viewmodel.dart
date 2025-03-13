// lib/viewmodels/home/home_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HomeViewModel extends ChangeNotifier {
  final GetInProgressGoalsUseCase getInProgressGoalsUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;

  List<Goal> _inProgressGoals = [];
  List<Goal> get inProgressGoals => _inProgressGoals;

  HomeViewModel({
    required this.getInProgressGoalsUseCase,
    required this.deleteGoalUseCase,
  }) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    _inProgressGoals = await getInProgressGoalsUseCase();
    notifyListeners();
  }

  /// 진행 중인 목표 중 D-Day(마감일 기준) 가장 가까운 3개
  List<Goal> get dDayClosestThree {
    final sortedGoals = List<Goal>.from(_inProgressGoals)
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    return sortedGoals.take(3).toList();
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalUseCase(goalId);
    await loadGoals();
  }
}
