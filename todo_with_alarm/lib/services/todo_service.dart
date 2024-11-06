// services/todo_service.dart

import 'package:todo_with_alarm/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoService {
  // 모든 투두 리스트를 저장하는 메서드
  static Future<void> saveAllTodos(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoStrings = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('all_todos', todoStrings);
  }

  // 모든 투두 리스트를 불러오는 메서드
  static Future<List<Todo>> loadAllTodos() async {
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
}