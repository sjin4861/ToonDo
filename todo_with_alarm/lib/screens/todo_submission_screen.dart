// screens/todo_submission_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/widgets/todo_list_item.dart';
import 'package:intl/intl.dart';

class TodoSubmissionScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const TodoSubmissionScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  _TodoSubmissionScreenState createState() => _TodoSubmissionScreenState();
}

class _TodoSubmissionScreenState extends State<TodoSubmissionScreen> {
  late DateTime selectedDate;
  final TextEditingController todoController = TextEditingController();
  String? selectedGoalId;
  bool hideCompletionStatus = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();
    Provider.of<TodoProvider>(context, listen: false)
        .loadTodosForDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final goalProvider = Provider.of<GoalProvider>(context);

    List<Todo> todos = todoProvider.getTodosForDate(selectedDate);

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('투두리스트 ($formattedDate)'),
        actions: [
          IconButton(
            icon: Icon(
              hideCompletionStatus ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                hideCompletionStatus = !hideCompletionStatus;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Column(
        children: [
          // 날짜 선택 및 이동 버튼들
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goToPreviousDay,
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _goToNextDay,
                ),
              ],
            ),
          ),
          Divider(),
          // 입력 섹션
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 투두 입력 필드
                    TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        labelText: '투두 항목 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // 목표 선택 드롭다운
                    DropdownButtonFormField<String>(
                      value: selectedGoalId,
                      decoration: const InputDecoration(
                        labelText: '해당하는 목표 선택 (선택 사항)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('해당 없음'),
                        ),
                        ...goalProvider.goals.map((Goal goal) {
                          return DropdownMenuItem<String>(
                            value: goal.id,
                            child: Text(goal.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGoalId = newValue;
                        });
                      },
                      hint: Text('목표를 선택하세요'),
                    ),
                    SizedBox(height: 16),
                    // 투두 추가 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addTodo,
                        child: Text('투두 추가'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          // 투두 리스트
          Expanded(
            child: todos.isNotEmpty
                ? ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];
                      return Dismissible(
                        key: Key(
                            todo.title + todo.date.toIso8601String()),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          todoProvider.deleteTodoForDate(selectedDate, todo);
                        },
                        child: ChangeNotifierProvider.value(
                          value: todo,
                          child: TodoListItem(
                            todo: todo,
                            onUpdate: (updatedTodo) {
                              // 진행률 업데이트 시 저장
                              todoProvider.updateTodoForDate(selectedDate, updatedTodo);
                            },
                            hideCompletionStatus: hideCompletionStatus,
                            onDelete: () {
                              todoProvider.deleteTodoForDate(selectedDate, todo);
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      '할 일이 없습니다.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // 투두 추가 메서드 분리
  void _addTodo() {
    if (todoController.text.isNotEmpty) {
      Todo newTodo = Todo(
        title: todoController.text,
        date: selectedDate,
        urgency: 5.0,
        importance: 5.0,
        goalId: selectedGoalId,
        status: 0.0,
      );
      Provider.of<TodoProvider>(context, listen: false)
          .addTodoForDate(selectedDate, newTodo);
      todoController.clear();
      setState(() {
        selectedGoalId = null;
      });
    }
  }

  // 날짜 선택 함수
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      Provider.of<TodoProvider>(context, listen: false)
          .loadTodosForDate(selectedDate);
    }
  }

  // 다음날로 이동
  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
    Provider.of<TodoProvider>(context, listen: false)
        .loadTodosForDate(selectedDate);
  }

  // 이전날로 이동
  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
    Provider.of<TodoProvider>(context, listen: false)
        .loadTodosForDate(selectedDate);
  }
}