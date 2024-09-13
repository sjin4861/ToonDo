// services/todo_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_alarm/models/todo.dart';

class TodoService {
  static const String todoKeyPrefix = 'todos_'; // 날짜별로 키를 구분하기 위한 접두사

  // 특정 날짜의 투두 리스트를 저장하는 메서드
  static Future<void> saveTodos(DateTime date, List<Todo> todos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = todoKeyPrefix + date.toIso8601String().split('T')[0]; // yyyy-MM-dd 형식

    // Todo 리스트를 JSON으로 변환 후 저장
    List<String> jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  // 특정 날짜의 투두 리스트를 불러오는 메서드
  static Future<List<Todo>> loadTodos(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = todoKeyPrefix + date.toIso8601String().split('T')[0]; // yyyy-MM-dd 형식

    List<String>? jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return []; // 저장된 Todo가 없으면 빈 리스트 반환
    }

    // JSON 데이터를 Todo 객체 리스트로 변환
    List<Todo> todos = jsonList.map((jsonTodo) {
      Map<String, dynamic> todoMap = jsonDecode(jsonTodo);
      return Todo.fromJson(todoMap);
    }).toList();

    return todos;
  }

  // 특정 날짜의 투두 리스트를 삭제하는 메서드
  static Future<void> clearTodos(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = todoKeyPrefix + date.toIso8601String().split('T')[0]; // yyyy-MM-dd 형식
    await prefs.remove(key); // 저장된 Todo 리스트 삭제
  }
}