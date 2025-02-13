// lib/viewmodels/goal/goal_management_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/data/models/goal_status.dart';
import 'package:toondo/viewmodels/goal/goal_filter_option.dart';
import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';

class GoalManagementViewModel extends ChangeNotifier {
  final GoalViewModel goalViewModel; // 의존성: CRUD는 여기가 아니라 goalViewModel이 담당

  // 필터된 결과
  List<Goal> _filteredGoals = [];

  List<Goal> get filteredGoals => _filteredGoals;

  // 현재 필터 옵션
  GoalFilterOption _filterOption = GoalFilterOption.inProgress;
  GoalFilterOption get filterOption => _filterOption;

  GoalManagementViewModel({required this.goalViewModel}) {
    // 초기 로딩: goalViewModel에 리스너 등록
    // goalViewModel이 notifyListeners() 할 때마다 applyFilter()를 다시 실행
    goalViewModel.addListener(_onGoalsChanged);
    applyFilter();
  }

  void _onGoalsChanged() {
    // goalViewModel이 업데이트되면, filteredGoals 재계산
    applyFilter();
  }

  /// 필터 옵션 바꾸기
  void setFilterOption(GoalFilterOption newFilterOption) {
    _filterOption = newFilterOption;
    applyFilter();
  }

  /// 실제 필터 로직
  void applyFilter() {
    final allGoals = goalViewModel.goals; // goalViewModel로부터 전체 목록
    if (_filterOption == GoalFilterOption.inProgress) {
      _filteredGoals = allGoals.where((g) => g.status.isInProgress).toList();
    } else {
      _filteredGoals = allGoals.where((g) => g.status.isCompleted).toList();
    }
    notifyListeners();
  }

  /// --------------------------------------------------------
  /// 아래 로직은, 필요하다면 GoalManagementViewModel에서
  /// goalViewModel의 CRUD 메서드를 호출하여 "위임"할 수 있음
  /// --------------------------------------------------------

  // 진행률 업데이트
  Future<void> updateGoalProgress(String goalId, double newProgress) async {
    await goalViewModel.updateGoalProgress(goalId, newProgress);
    // goalViewModel이 notifyListeners() → _onGoalsChanged() → applyFilter()
  }

  // 포기
  Future<void> giveUpGoal(String goalId) async {
    await goalViewModel.giveUpGoal(goalId);
  }

  // 완료
  Future<void> completeGoal(String goalId) async {
    await goalViewModel.completeGoal(goalId);
  }

  // 삭제
  Future<void> deleteGoal(String goalId) async {
    await goalViewModel.deleteGoal(goalId);
  }
  
  // etc. 필요하다면 CRUD 메서드 모두 위임

  @override
  void dispose() {
    // ViewModel 해제 시, goalViewModel 리스너도 제거
    goalViewModel.removeListener(_onGoalsChanged);
    super.dispose();
  }
}