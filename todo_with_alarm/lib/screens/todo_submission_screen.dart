import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

class TodoSubmissionScreen extends StatefulWidget {
  @override
  _TodoSubmissionScreenState createState() => _TodoSubmissionScreenState();
}

class _TodoSubmissionScreenState extends State<TodoSubmissionScreen> {
  // Todo 항목을 저장할 리스트
  List<Todo> todos = [];

  // TextField의 컨트롤러
  final TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos(); // 저장된 Todo 리스트 불러오기
  }

  @override
  void dispose() {
    todoController.dispose(); // TextField의 컨트롤러 해제
    super.dispose();
  }

  // 저장된 Todo 리스트 불러오기
  Future<void> _loadTodos() async {
    List<Todo> loadedTodos = await TodoService.loadTodos();
    setState(() {
      todos = loadedTodos;
    });
  }

  // Todo 항목을 추가하는 함수
  void _addTodo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todos.add(Todo(title: todoController.text));
        todoController.clear(); // 입력 필드 초기화
      });
      TodoService.saveTodos(todos); // 추가 후 저장
    }
  }

  // Todo 항목을 삭제하는 함수
  void _removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    TodoService.saveTodos(todos); // 삭제 후 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Todo 입력 필드
            TextField(
              controller: todoController,
              decoration: InputDecoration(
                labelText: 'Enter a new todo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Todo 추가 버튼
            ElevatedButton(
              onPressed: _addTodo,
              child: Text('Add Todo'),
            ),
            SizedBox(height: 20),
            // Todo 리스트를 보여주는 영역
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index].title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTodo(index),
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