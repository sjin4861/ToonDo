// services/todo_service.dart

import 'package:todo_with_alarm/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoService {
  // 특정 날짜의 투두 리스트 저장
  static Future<void> saveTodos(DateTime date, List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'todos_${date.toIso8601String().split('T')[0]}';
    List<String> todoStrings = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    prefs.setStringList(key, todoStrings);
  }

  // 특정 날짜의 투두 리스트 불러오기
  static Future<List<Todo>> loadTodos(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'todos_${date.toIso8601String().split('T')[0]}';
    List<String>? todoStrings = prefs.getStringList(key);
    if (todoStrings != null) {
      return todoStrings
          .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
          .toList();
    } else {
      return [];
    }
  }
}