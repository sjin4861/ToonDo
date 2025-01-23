// lib/viewmodels/goal/goal_input_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/widgets/calendar/calendar_bottom_sheet.dart';

class GoalInputViewModel extends ChangeNotifier {
  final TextEditingController goalNameController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

  DateTime? startDate;
  DateTime? endDate;
  String? selectedIcon;

  String? goalNameError;
  String? dateError;

  final Goal? targetGoal; 
  final GoalService goalService; 

  GoalInputViewModel({
    required this.goalService,
    this.targetGoal,
  }) {
    // 기존 목표가 있으면 (수정 모드) 초기값 세팅
    if (targetGoal != null) {
      goalNameController.text = targetGoal!.name;
      startDate = targetGoal!.startDate;
      endDate = targetGoal!.endDate;
      selectedIcon = targetGoal!.icon;
    }

    // 텍스트 필드 변경 감지
    goalNameController.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  /// 목표 생성/수정
  Future<Goal?> saveGoal(BuildContext context) async {
    if (!validateInput()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력한 정보를 확인해주세요.')),
      );
      return null;
    }

    const String defaultIconPath = 'assets/icons/100point.svg';
    final newGoal = Goal(
      id: targetGoal?.id ?? const Uuid().v4(),
      name: goalNameController.text,
      icon: selectedIcon ?? defaultIconPath,
      startDate: startDate!,
      endDate: endDate!,
      progress: targetGoal?.progress ?? 0.0,
      isCompleted: targetGoal?.isCompleted ?? false,
      status: targetGoal?.status ?? GoalStatus.active,
    );

    try {
      // GoalViewModel에 접근
      final goalVM = Provider.of<GoalViewModel>(context, listen: false);

      if (targetGoal == null) {
        // 새 목표
        await goalVM.addGoal(newGoal); // GoalViewModel.addGoal
      } else {
        // 기존 목표 수정
        await goalVM.updateGoal(newGoal); // GoalViewModel.updateGoal
      }

      // 필요하다면 goalVM.loadGoals()로 다시 서버/DB에서 싱크 가능
      // 하지만 addGoal, updateGoal 내부에서 notifyListeners()가 이미 호출됨
      // goalVM.loadGoals(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표가 성공적으로 저장되었습니다.')),
      );

      // 신규일 경우 입력필드 리셋
      if (targetGoal == null) {
        goalNameController.clear();
        startDate = null;
        endDate = null;
        selectedIcon = null;
        notifyListeners();
      }

      return newGoal;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표 저장 중 오류가 발생했습니다.')),
      );
      print('Error saving goal: $e');
      return null;
    }
  }

  /// 입력 검증
  bool validateInput() {
    bool isValid = true;

    if (goalNameController.text.isEmpty) {
      goalNameError = '목표 이름을 입력해주세요.';
      isValid = false;
    } else {
      goalNameError = null;
    }

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

  /// 아이콘 선택
  void selectIcon(String iconPath) {
    selectedIcon = iconPath;
    notifyListeners();
  }

  /// 시작일 설정
  void selectStartDate(DateTime date) {
    startDate = date;
    // 만약 endDate가 startDate 이전이면 맞춰줌
    if (endDate != null && startDate!.isAfter(endDate!)) {
      endDate = startDate;
    }
    notifyListeners();
  }

  /// 마감일 설정
  void selectEndDate(DateTime date) {
    endDate = date;
    // 만약 startDate가 endDate 이후이면 맞춰줌
    if (startDate != null && endDate!.isBefore(startDate!)) {
      startDate = endDate;
    }
    notifyListeners();
  }

  /// 날짜 BottomSheet 오픈
  Future<void> selectDate(BuildContext context, {required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    if (isStartDate && startDate != null) {
      initialDate = startDate!;
    } else if (!isStartDate && endDate != null) {
      initialDate = endDate!;
    }

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0x00000000),
      builder: (context) => SelectDateBottomSheet(initialDate: initialDate),
    );

    if (pickedDate != null) {
      if (isStartDate) {
        selectStartDate(pickedDate);
      } else {
        selectEndDate(pickedDate);
      }
    }
  }
}