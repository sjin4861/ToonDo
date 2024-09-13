// screens/todo_submission_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/widgets/todo_list_item.dart';
import 'package:intl/intl.dart';

class TodoSubmissionScreen extends StatefulWidget {
  @override
  _TodoSubmissionScreenState createState() => _TodoSubmissionScreenState();
}

class _TodoSubmissionScreenState extends State<TodoSubmissionScreen> {
  DateTime selectedDate = DateTime.now();
  List<Todo> todos = [];
  final TextEditingController todoController = TextEditingController();
  bool hideCompletionStatus = false; // 수행 여부 숨김 여부

  @override
  void initState() {
    super.initState();
    _loadTodos(); // 현재 날짜의 투두 리스트 불러오기
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  // 특정 날짜의 투두 리스트 불러오기
  Future<void> _loadTodos() async {
    List<Todo> loadedTodos = await TodoService.loadTodos(selectedDate);
    setState(() {
      todos = loadedTodos;
    });
  }

  // 투두 항목 추가
  void _addTodo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todos.add(Todo(title: todoController.text, date: selectedDate));
        todoController.clear();
      });
      TodoService.saveTodos(selectedDate, todos); // 저장
    }
  }

  // 투두 항목 삭제
  void _removeTodoAt(int index) {
    setState(() {
      todos.removeAt(index);
    });
    TodoService.saveTodos(selectedDate, todos); // 저장
  }

  // 투두 항목 업데이트
  void _updateTodo(Todo updatedTodo) {
    int index = todos.indexWhere((todo) => todo.title == updatedTodo.title);
    if (index != -1) {
      setState(() {
        todos[index] = updatedTodo;
      });
      TodoService.saveTodos(selectedDate, todos); // 저장
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
      _loadTodos(); // 선택한 날짜의 투두 리스트 불러오기
    }
  }

  // 다음날로 이동
  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
    _loadTodos();
  }

  // 이전날로 이동
  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
    _loadTodos();
  }

  // 수행 여부 가리기 토글 함수
  void _toggleHideCompletionStatus() {
    setState(() {
      hideCompletionStatus = !hideCompletionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('투두리스트 ($formattedDate)'),
        actions: [
          IconButton(
            icon: Icon(
              hideCompletionStatus ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: _toggleHideCompletionStatus,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 날짜 선택 및 이동 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goToPreviousDay,
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: Text(formattedDate),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _goToNextDay,
                ),
              ],
            ),
            // 투두 입력 필드
            TextField(
              controller: todoController,
              decoration: InputDecoration(
                labelText: '투두 항목 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // 투두 추가 버튼
            ElevatedButton(
              onPressed: _addTodo,
              child: Text('투두 추가'),
            ),
            SizedBox(height: 20),
            // 투두 리스트
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(todos[index].title + todos[index].date.toIso8601String()),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      _removeTodoAt(index);
                    },
                    child: TodoListItem(
                      todo: todos[index],
                      onUpdate: _updateTodo,
                      hideCompletionStatus: hideCompletionStatus,
                      onDelete: () => _removeTodoAt(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}