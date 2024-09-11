import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_alarm/models/todo.dart';

class TodoService {
  static const String todoKey = 'todos'; // SharedPreferences에 저장할 키

  // Todo 항목을 저장하는 메서드
  static Future<void> saveTodos(List<Todo> todos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Todo 리스트를 JSON으로 변환 후 저장
    List<String> jsonList = todos.map((todo) => jsonEncode({
      'title': todo.title,
      'isCompleted': todo.isCompleted,
    })).toList();

    await prefs.setStringList(todoKey, jsonList);
  }

  // 저장된 Todo 리스트를 불러오는 메서드
  static Future<List<Todo>> loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList(todoKey);
    if (jsonList == null) {
      return []; // 저장된 Todo가 없으면 빈 리스트 반환
    }

    // JSON 데이터를 Todo 객체 리스트로 변환
    List<Todo> todos = jsonList.map((jsonTodo) {
      Map<String, dynamic> todoMap = jsonDecode(jsonTodo);
      return Todo(
        title: todoMap['title'],
        isCompleted: todoMap['isCompleted'],
      );
    }).toList();

    return todos;
  }

  // Todo 리스트를 삭제하는 메서드
  static Future<void> clearTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(todoKey); // 저장된 Todo 리스트 삭제
  }
}