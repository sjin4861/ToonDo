// lib/viewmodels/goal/goal_input_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';

class GoalInputViewModel extends ChangeNotifier {
  final TextEditingController goalNameController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String? selectedIcon;

  String? goalNameError;
  String? dateError;

  Goal? targetGoal; // 수정 시 사용할 목표 객체
  final GoalService goalService; // GoalService 인스턴스

  GoalInputViewModel({required this.goalService, this.targetGoal}) {
    if (targetGoal != null) {
      goalNameController.text = targetGoal!.name;
      startDate = targetGoal!.startDate;
      endDate = targetGoal!.endDate;
      selectedIcon = targetGoal!.icon;
    }

    // 텍스트 필드의 변경 사항을 감지하여 테두리 색상 업데이트
    goalNameController.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  // 목표 저장 또는 업데이트 메서드
  Future<void> saveGoal(BuildContext context) async {
    if (!validateInput()) {
      return;
    }

    final newGoal = Goal(
      id: targetGoal?.id ?? const Uuid().v4(),
      name: goalNameController.text,
      icon: selectedIcon,
      startDate: startDate!,
      endDate: endDate!,
      progress: targetGoal?.progress ?? 0.0,
    );

    try {
      if (targetGoal == null) {
        // 새로운 목표 추가
        await goalService.createGoal(newGoal);
      } else {
        // 기존 목표 업데이트
        await goalService.updateGoal(newGoal);
      }

      // GoalViewModel을 통해 목표 리스트 새로고침
      Provider.of<GoalViewModel>(context, listen: false).loadGoals();

      // 성공적으로 저장되었음을 사용자에게 알림 (예: SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('목표가 성공적으로 저장되었습니다.')),
      );

      // 입력 필드 초기화 (새로운 목표 추가 시)
      if (targetGoal == null) {
        goalNameController.clear();
        startDate = null;
        endDate = null;
        selectedIcon = null;
        notifyListeners();
      }
    } catch (e) {
      // 에러 처리: 사용자에게 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('목표 저장 중 오류가 발생했습니다.')),
      );
      print('Error saving goal: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
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