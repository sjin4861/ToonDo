  // viewmodels/goal/goal_input_viewmodel.dart

  import 'package:flutter/material.dart';
  import 'package:todo_with_alarm/models/goal.dart';
  import 'package:todo_with_alarm/services/goal_service.dart';
  import 'package:uuid/uuid.dart';
  import 'goal_viewmodel.dart'; // GoalViewModel을 import

  class GoalInputViewModel extends ChangeNotifier {
    final TextEditingController goalNameController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    String? selectedIcon;

    String? goalNameError;
    String? dateError;

    Goal? targetGoal; // 수정 시 사용할 목표 객체
    final GoalViewModel goalViewModel = GoalViewModel(goalService: GoalService()); // GoalViewModel 인스턴스

      GoalInputViewModel({this.targetGoal}) {  if (targetGoal != null) {
        goalNameController.text = targetGoal!.name;
        startDate = targetGoal!.startDate;
        endDate = targetGoal!.endDate;
        selectedIcon = targetGoal!.icon;
      }
    }

    @override
    void dispose() {
      goalNameController.dispose();
      super.dispose();
    }

    // 목표 저장 또는 업데이트 메서드
    void saveGoal() {
      if (!validateInput()) {
        return;
      }

      final newGoal = Goal(
        id: targetGoal?.id ?? Uuid().v4(),
        name: goalNameController.text,
        icon: selectedIcon,
        startDate: startDate!,
        endDate: endDate!,
        progress: targetGoal?.progress ?? 0.0,
      );

      if (targetGoal == null) {
        // 새로운 목표 추가
        goalViewModel.addGoal(newGoal);
      } else {
        // 기존 목표 업데이트
        goalViewModel.updateGoal(newGoal);
      }
    }

    // 입력 유효성 검사
    bool validateInput() {
      bool isValid = true;

      // 목표 이름 검사
      if (goalNameController.text.isEmpty) {
        goalNameError = '목표 이름을 입력해주세요.';
        isValid = false;
      } else {
        goalNameError = null;
      }

      // 날짜 검사
      if (startDate == null || endDate == null) {
        dateError = '시작일과 마감일을 모두 선택해주세요.';
        isValid = false;
      } else if (endDate!.isBefore(startDate!)) {
        dateError = '마감일은 시작일 이후여야 합니다.';
        isValid = false;
      } else {
        dateError = null;
      }

      notifyListeners();
      return isValid;
    }

    // 아이콘 선택 메서드
    void selectIcon(String iconPath) {
      selectedIcon = iconPath;
      notifyListeners();
    }

    // 시작일 선택 메서드
    void selectStartDate(DateTime date) {
      startDate = date;
      notifyListeners();
    }

    // 마감일 선택 메서드
    void selectEndDate(DateTime date) {
      endDate = date;
      notifyListeners();
    }
  }