// viewmodels/todo_submission_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

enum FilterOption { all, goal, importance }

class TodoSubmissionViewModel extends ChangeNotifier {
  final TodoService _todoService = TodoService();

  DateTime selectedDate;
  FilterOption selectedFilter = FilterOption.all;
  String? selectedGoalId;

  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];

  TodoSubmissionViewModel({DateTime? initialDate})
      : selectedDate = initialDate ?? DateTime.now();

  Future<void> loadTodos() async {
    allTodos = await _todoService.loadTodoList();
    _filterAndCategorizeTodos();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    _filterAndCategorizeTodos();
    notifyListeners();
  }

  void updateSelectedFilter(FilterOption filter, {String? goalId}) {
    selectedFilter = filter;
    selectedGoalId = goalId;
    _filterAndCategorizeTodos();
    notifyListeners();
  }

  void _filterAndCategorizeTodos() {
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // 선택된 날짜에 해당하는 투두 필터링
    List<Todo> todosForSelectedDate = allTodos.where((todo) {
      DateTime todoStartDate = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) ||
              todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todoEndDate.isAfter(selectedDateOnly) ||
              todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();

    // 선택된 필터에 따라 추가 필터링 적용
    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => todo.goalId == selectedGoalId).toList();
    } else if (selectedFilter == FilterOption.importance) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => todo.importance == 1).toList();
    }

    // D-Day 투두와 데일리 투두 분류
    dDayTodos = todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    dailyTodos = todosForSelectedDate.where((todo) => !todo.isDDayTodo()).toList();

    // D-Day 투두 정렬
    dDayTodos.sort((a, b) {
      int aDDay = a.endDate.difference(selectedDateOnly).inDays;
      int bDDay = b.endDate.difference(selectedDateOnly).inDays;
      return aDDay.compareTo(bDDay);
    });

    // 데일리 투두 정렬
    dailyTodos.sort((a, b) => b.importance.compareTo(a.importance));

    notifyListeners();
  }

  // 투두 상태 업데이트 메서드
  Future<void> updateTodoStatus(Todo todo, double status) async {
    todo.status = status;
    await _todoService.updateTodoStatus(todo.id, status);
    notifyListeners();
  }

  // 투두 삭제 메서드
  Future<void> deleteTodoById(String id) async {
    await _todoService.deleteTodoById(id);
    await loadTodos();
    notifyListeners();
  }

  // 투두 날짜 업데이트 메서드
  Future<void> updateTodoDates(Todo todo, DateTime newStartDate, DateTime newEndDate) async {
    todo.startDate = newStartDate;
    todo.endDate = newEndDate;
    await _todoService.updateTodoDates(todo);
    await loadTodos();
    notifyListeners();
  }
}