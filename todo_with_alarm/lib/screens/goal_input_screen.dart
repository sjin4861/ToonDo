// screens/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:intl/intl.dart';

class GoalInputScreen extends StatefulWidget {
  final Function(Goal) onGoalSet; // 목표를 설정한 후 전달할 콜백
  final Goal? existingGoal; // 기존 목표가 있으면 받을 수 있게

  const GoalInputScreen({super.key, required this.onGoalSet, this.existingGoal});

  @override
  // ignore: library_private_types_in_public_api
  _GoalInputScreenState createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final TextEditingController goalNameController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

    // 기존 목표가 있으면 그 값을 설정해줌
    if (widget.existingGoal != null) {
      goalNameController.text = widget.existingGoal!.name;
      startDate = widget.existingGoal!.startDate;
      endDate = widget.existingGoal!.endDate;
    }
  }

  // 목표 저장 함수
  void _saveGoal() {
    if (goalNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표 이름을 입력하세요.')),
      );
      return;
    }

    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시작일을 선택하세요.')),
      );
      return;
    }

    if (endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('종료일을 선택하세요.')),
      );
      return;
    }

    if (startDate!.isAfter(endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시작일은 종료일 이전이어야 합니다.')),
      );
      return;
    }

    final newGoal = Goal(
      name: goalNameController.text,
      startDate: startDate!,
      endDate: endDate!,
    );

    widget.onGoalSet(newGoal); // 설정된 목표를 전달
    Navigator.pop(context); // 이전 화면으로 복귀
  }

  @override
  void dispose() {
    goalNameController.dispose(); // TextField의 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '목표 수정' : '목표 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: goalNameController,
              decoration: const InputDecoration(labelText: '목표 이름'),
            ),
            const SizedBox(height: 16),
            // 시작일 선택 버튼
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (selectedDate != null) {
                  setState(() {
                    startDate = selectedDate;
                  });
                }
              },
              child: Text(startDate == null
                  ? '시작일 선택'
                  : '시작일: ${DateFormat('yyyy-MM-dd').format(startDate!)}'),
            ),
            // 종료일 선택 버튼
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (selectedDate != null) {
                  setState(() {
                    endDate = selectedDate;
                  });
                }
              },
              child: Text(endDate == null
                  ? '종료일 선택'
                  : '종료일: ${DateFormat('yyyy-MM-dd').format(endDate!)}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGoal,
              child: Text(isEditing ? '목표 수정 완료' : '목표 설정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}