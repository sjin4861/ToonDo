import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  final GoalViewModel goalViewModel;

  HomeViewModel({required this.goalViewModel});

  List<Goal> get goals => goalViewModel.goals;

  Future<void> deleteGoal(String id) async {
    await goalViewModel.deleteGoal(id);
    notifyListeners(); // UI 업데이트
  }
} 