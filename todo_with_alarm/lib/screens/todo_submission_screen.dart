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
            icon: Icon(Icons.add),
            onPressed: () {
              // 목표 관리 화면으로 이동
              // 필요에 따라 구현
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 날짜 선택 및 이동 버튼들
          // 투두 입력 필드
          TextField(
            controller: todoController,
            decoration: InputDecoration(
              labelText: '투두 항목 입력',
              border: OutlineInputBorder(),
            ),
          ),
          // 목표 선택 드롭다운
          DropdownButtonFormField<String>(
            value: selectedGoalId,
            decoration: InputDecoration(
              labelText: '목표 선택 (선택 사항)',
              border: OutlineInputBorder(),
            ),
            items: goalProvider.goals.map((Goal goal) {
              return DropdownMenuItem<String>(
                value: goal.id,
                child: Text(goal.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedGoalId = newValue;
              });
            },
            hint: Text('목표를 선택하세요'),
          ),
          // 투두 추가 버튼
          ElevatedButton(
            onPressed: () {
              if (todoController.text.isNotEmpty) {
                Todo newTodo = Todo(
                  title: todoController.text,
                  date: selectedDate,
                  urgency: 5.0,
                  importance: 5.0,
                  goalId: selectedGoalId,
                  status: 0.0,
                );
                todoProvider.addTodoForDate(selectedDate, newTodo);
                todoController.clear();
                setState(() {
                  selectedGoalId = null;
                });
              }
            },
            child: Text('투두 추가'),
          ),
          // 투두 리스트
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return Dismissible(
                  key: Key(todo.title + todo.date.toIso8601String()),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    todoProvider.deleteTodoForDate(selectedDate, todo);
                  },
                  child: TodoListItem(
                    todo: todo,
                    onUpdate: (updatedTodo) {
                      todoProvider.updateTodoForDate(selectedDate, updatedTodo);
                    },
                    hideCompletionStatus: hideCompletionStatus,
                    onDelete: () {
                      todoProvider.deleteTodoForDate(selectedDate, todo);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}