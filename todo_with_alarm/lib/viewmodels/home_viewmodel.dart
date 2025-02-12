// lib/viewmodels/home/home_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/data/models/goal.dart';
import 'package:todo_with_alarm/data/models/goal_status.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  final GoalViewModel goalViewModel;

  HomeViewModel({required this.goalViewModel});

  /// 진행 중인 목표 중 D-Day가 가장 가까운 3개
  List<Goal> get dDayClosestThree {
    // 진행 중인(goal.status.isInProgress) 목표만 필터
    final inProgressGoals = goalViewModel.goals
        .where((g) => g.status.isInProgress)
        .toList();

    // 종료일(마감일) 기준 오름차순 정렬
    inProgressGoals.sort((a, b) => a.endDate.compareTo(b.endDate));

    // 상위 3개만
    return inProgressGoals.take(3).toList();
  }

  // 홈화면에서 다른 로직이 필요하면 추가 (e.g. 특정 목표 삭제 등)
  Future<void> deleteGoal(String goalId) async {
    await goalViewModel.deleteGoal(goalId);
    // goalViewModel이 notifyListeners()를 이미 호출 → 
    // 필요하면 HomeViewModel도 추가적으로 처리 → notifyListeners();
  }
}