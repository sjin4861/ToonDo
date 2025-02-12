// lib/viewmodels/todo/todo_submission_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/data/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

enum FilterOption { all, goal, importance }

class TodoSubmissionViewModel extends ChangeNotifier {
  final TodoService _todoService;
  
  DateTime selectedDate;
  FilterOption selectedFilter = FilterOption.all;
  String? selectedGoalId;

  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];

  TodoSubmissionViewModel({
    required TodoService todoService,
    DateTime? initialDate,
  })  : _todoService = todoService,
        selectedDate = initialDate ?? DateTime.now();

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

    // print("Filtered Todos for selected date: ${todosForSelectedDate.length}");
    // todosForSelectedDate.forEach((todo) {
    //   print("Todo: ${todo.title}, isDDay: ${todo.isDDayTodo()}");
    //   // 날짜 데이터 확인해보기
    //   print("Todo Start Date: ${todo.startDate}");
    //   print("Todo End Date: ${todo.endDate}");
    // });

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
    try {
      todo.status = status;
      await _todoService.updateTodoStatus(todo.id, status);
      // 특정 Todo만 업데이트
      int index = allTodos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        allTodos[index] = todo;
        _filterAndCategorizeTodos();
      }
    } catch (e) {
      print('Error updating todo status: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }

  // 투두 삭제 메서드
  Future<void> deleteTodoById(String id) async {
    try {
      await _todoService.deleteTodoById(id);
      await loadTodos();
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }

  // 투두 날짜 업데이트 메서드
  Future<void> updateTodoDates(Todo todo, DateTime newStartDate, DateTime newEndDate) async {
    try {
      todo.startDate = newStartDate;
      todo.endDate = newEndDate;
      await _todoService.updateTodoDates(todo);
      await loadTodos();
      notifyListeners();
    } catch (e) {
      print('Error updating todo dates: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }
}