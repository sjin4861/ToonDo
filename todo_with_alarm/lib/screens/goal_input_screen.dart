// screens/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:uuid/uuid.dart';
import 'package:todo_with_alarm/widgets/date_picker_field.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/services/goal_service.dart'; // GoalService 임포트

class GoalInputScreen extends StatefulWidget {
  final Goal? targetGoal;

  GoalInputScreen({Key? key, this.targetGoal}) : super(key: key);

  @override
  _GoalInputScreenState createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final _formKey = GlobalKey<FormState>(); // Form의 상태를 관리하기 위한 키

  @override
  void initState() {
    super.initState();

    if (widget.targetGoal != null) {
      _goalNameController.text = widget.targetGoal!.name;
      _startDate = widget.targetGoal!.startDate;
      _endDate = widget.targetGoal!.endDate;
    }
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdating = widget.targetGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdating ? '목표 수정' : '목표 설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Form 위젯에 키 설정
            child: Column(
              children: [
                // 목표 이름 입력 필드
                TextFormField(
                  controller: _goalNameController,
                  decoration: const InputDecoration(
                    labelText: '목표 이름',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '목표 이름을 입력하세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // 시작일 선택
                DatePickerField(
                  label: '시작일',
                  selectedDate: _startDate,
                  onSelectDate: (pickedDate) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 종료일 선택
                DatePickerField(
                  label: '종료일',
                  selectedDate: _endDate,
                  onSelectDate: (pickedDate) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                ),
                const SizedBox(height: 32),
                // 입력 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _setGoal(isUpdating),
                    icon: const Icon(Icons.save),
                    label: Text(isUpdating ? '목표 수정 완료' : '목표 설정 완료'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _setGoal(bool isUpdating) async{
    if (_formKey.currentState!.validate()) {
      // GoalService를 사용하여 날짜 유효성 검사
      String? dateError = GoalService.validateGoalDates(_startDate, _endDate);
      if (dateError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dateError)),
        );
        return;
      }
      final newGoal = Goal(
        id: widget.targetGoal?.id ?? Uuid().v4(), // 기존 ID 유지 또는 새 ID 생성
        name: _goalNameController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        progress: widget.targetGoal?.progress ?? 0.0,
      );

      final goalProvider = Provider.of<GoalProvider>(context, listen: false);

      if (isUpdating) {
        await goalProvider.updateGoal(newGoal);
      } else {
        await goalProvider.addGoal(newGoal);
      }

      Navigator.pop(context);
    }
  }
}