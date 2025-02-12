// lib/viewmodels/my_page/my_page_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/data/models/user.dart';
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

  /// 1) 로컬 -> 서버: 미동기화 데이터를 서버에 반영(Commit)
  Future<void> commitData() async {
    try {
      // 투두 & 목표 각각 커밋
      await todoService.commitTodos();
      await goalService.commitGoal();
    } catch (e) {
      print('Error while committing data: $e');
    } finally {
      notifyListeners();
    }
  }

  /// 2) 서버 -> 로컬: 서버 데이터 전체를 받아와 로컬에 갱신(Fetch)
  Future<void> fetchData() async {
    try {
      // 투두 & 목표 각각 가져오기
      await todoService.fetchTodos();
      await goalService.fetchGoals();
    } catch (e) {
      print('Error while fetching data: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTodoOnly() async {
    try {
      await todoService.fetchTodos();
    } catch (e) {
      print('Error fetching todo only: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> commitTodoOnly() async {
    try {
      await todoService.commitTodos();
    } catch (e) {
      print('Error committing todo only: $e');
    } finally {
      notifyListeners();
    }
  }
}
