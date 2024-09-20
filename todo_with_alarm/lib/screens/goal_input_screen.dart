// screens/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class GoalInputScreen extends StatefulWidget {
  final Function(Goal) onGoalSet;
  final Goal? existingGoal;

  const GoalInputScreen({Key? key, required this.onGoalSet, this.existingGoal})
      : super(key: key);

  @override
  _GoalInputScreenState createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final TextEditingController goalNameController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

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
      id: widget.existingGoal?.id ?? Uuid().v4(), // 기존 ID 유지
      name: goalNameController.text,
      startDate: startDate!,
      endDate: endDate!,
      progress: widget.existingGoal?.progress ?? 0.0,
    );

    widget.onGoalSet(newGoal);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '목표 수정' : '목표 설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 목표 이름 입력 필드
              TextField(
                controller: goalNameController,
                decoration: const InputDecoration(
                  labelText: '목표 이름',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // 시작일 선택
              Row(
                children: [
                  Expanded(
                    child: Text(
                      startDate == null
                          ? '시작일을 선택하세요'
                          : '시작일: ${DateFormat('yyyy-MM-dd').format(startDate!)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectStartDate,
                    child: Text('시작일 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 종료일 선택
              Row(
                children: [
                  Expanded(
                    child: Text(
                      endDate == null
                          ? '종료일을 선택하세요'
                          : '종료일: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectEndDate,
                    child: Text('종료일 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveGoal,
                  icon: Icon(Icons.save),
                  label: Text(isEditing ? '목표 수정 완료' : '목표 설정 완료'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 시작일 선택 함수
  Future<void> _selectStartDate() async {
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
  }

  // 종료일 선택 함수
  Future<void> _selectEndDate() async {
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
  }
}