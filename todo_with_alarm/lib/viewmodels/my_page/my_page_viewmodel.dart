// lib/viewmodels/my_page/my_page_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/user.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/services/goal_service.dart';

class MyPageViewModel extends ChangeNotifier {
  final User currentUser;
  final TodoService todoService;
  final GoalService goalService;

  MyPageViewModel({
    required this.currentUser,
    required this.todoService,
    required this.goalService,
  });

  Future<void> syncData() async {
    // 동기화 대상 투두 및 목표 가져오기
    final unsyncedTodos = await todoService.getUnsyncedTodos();
    final unsyncedGoals = await goalService.getUnsyncedGoals();

    for (var todo in unsyncedTodos) {
      await todoService.syncTodo(todo);
    }
    for (var goal in unsyncedGoals) {
      await goalService.syncGoal(goal);
    }
    notifyListeners();
  }
}