// services/todo_service.dart

import 'package:todo_with_alarm/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum FilterOption { all, goal, importance }

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

  // 선택된 날짜에 해당하는 투두 필터링 메서드
  static List<Todo> filterTodosByDate(
      List<Todo> todos, DateTime selectedDate) {
    DateTime selectedDateOnly =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    return todos.where((todo) {
      DateTime todoStartDate = DateTime(
          todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate =
          DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) ||
              todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todoEndDate.isAfter(selectedDateOnly) ||
              todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();
  }

  // 투두 필터링 메서드 (필터 옵션 적용)
  static List<Todo> applyFilter(
      List<Todo> todos, FilterOption selectedFilter, String? selectedGoalId) {
    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      return todos.where((todo) => todo.goalId == selectedGoalId).toList();
    } else if (selectedFilter == FilterOption.importance) {
      return todos.where((todo) => todo.importance >= 3).toList();
    } else {
      return todos;
    }
  }
}