// lib/viewmodels/goal/goal_input_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/widgets/calendar/calendar_bottom_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GoalInputViewModel extends ChangeNotifier {
  final TextEditingController goalNameController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

  DateTime? startDate;
  DateTime? endDate;
  String? selectedIcon;

  String? goalNameError;
  String? dateError;

  final Goal? targetGoal;
  final CreateGoalRemoteUseCase createGoalRemoteUseCase;
  final SaveGoalLocalUseCase saveGoalLocalUseCase;
  final UpdateGoalRemoteUseCase updateGoalRemoteUseCase;
  final UpdateGoalLocalUseCase updateGoalLocalUseCase;

  GoalInputViewModel({
    required this.createGoalRemoteUseCase,
    required this.saveGoalLocalUseCase,
    required this.updateGoalRemoteUseCase,
    required this.updateGoalLocalUseCase,
    this.targetGoal,
  }) {
    if (targetGoal != null) {
      goalNameController.text = targetGoal!.name;
      startDate = targetGoal!.startDate;
      endDate = targetGoal!.endDate;
      selectedIcon = targetGoal!.icon;
    }

    goalNameController.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  Future<Goal?> saveGoal(BuildContext context) async {
    if (!validateInput()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('입력한 정보를 확인해주세요.')));
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
    );

    try {
      if (targetGoal == null) {
        final created = await createGoalRemoteUseCase(newGoal);
        await saveGoalLocalUseCase(created);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('목표가 성공적으로 저장되었습니다.')));
        // Reset input fields for new goal.
        goalNameController.clear();
        startDate = null;
        endDate = null;
        selectedIcon = null;
        notifyListeners();
        return created;
      } else {
        await updateGoalRemoteUseCase(newGoal);
        await updateGoalLocalUseCase(newGoal);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('목표가 성공적으로 수정되었습니다.')));
        return newGoal;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('목표 저장 중 오류가 발생했습니다.')));
      print('Error saving goal: $e');
      return null;
    }
  }

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

  void selectIcon(String iconPath) {
    selectedIcon = iconPath;
    notifyListeners();
  }

  void selectStartDate(DateTime date) {
    startDate = date;
    if (endDate != null && startDate!.isAfter(endDate!)) {
      endDate = startDate;
    }
    notifyListeners();
  }

  void selectEndDate(DateTime date) {
    endDate = date;
    if (startDate != null && endDate!.isBefore(startDate!)) {
      startDate = endDate;
    }
    notifyListeners();
  }

  Future<void> selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
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
