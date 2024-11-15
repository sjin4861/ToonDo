// services/todo_service.dart

import 'package:todo_with_alarm/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoService {
  // 투두 저장 메서드
  Future<void> saveTodoList(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoStrings =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('all_todos', todoStrings);
  }

  // 투두 로드 메서드
  Future<List<Todo>> loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoStrings = prefs.getStringList('all_todos');
    if (todoStrings != null) {
      return todoStrings
          .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> updateTodoStatus(String todoId, double status) async {
    // 투두 리스트 로드
    List<Todo> todos = await loadTodoList();
    // 해당 투두 찾기
    int index = todos.indexWhere((todo) => todo.id == todoId);
    if (index != -1) {
      todos[index].status = status;
      // 투두 리스트 저장
      await saveTodoList(todos);
    }
  }

  Future<void> deleteTodoById(String id) async {
    // 투두 리스트 로드
    List<Todo> todos = await loadTodoList();
    // 해당 투두 삭제
    todos.removeWhere((todo) => todo.id == id);
    // 투두 리스트 저장
    await saveTodoList(todos);
  }

  Future<void> updateTodoDates(Todo todo) async {
    // 투두 리스트 로드
    List<Todo> todos = await loadTodoList();
    // 해당 투두 업데이트
    int index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      // 투두 리스트 저장
      await saveTodoList(todos);
    }
  }
}