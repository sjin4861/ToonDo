import 'package:flutter/material.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/data/repositories/todo_repository.dart';

enum FilterOption { all, goal, importance, dDay, daily }

class TodoManageViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository;
  DateTime selectedDate;
  FilterOption selectedFilter = FilterOption.all;
  String? selectedGoalId;
  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];

  TodoManageViewModel({
    required TodoRepository todoRepository,
    DateTime? initialDate,
  })  : _todoRepository = todoRepository,
        selectedDate = initialDate ?? DateTime.now();

  Future<void> loadTodos() async {
    allTodos = _todoRepository.getLocalTodos();
    if (allTodos.isEmpty) {
      await _todoRepository.fetchTodos();
      allTodos = _todoRepository.getLocalTodos();
    }
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

  void updateSelectedGoal(goal) {
    selectedGoalId = goal.id;
    updateSelectedFilter(FilterOption.goal);
  }

  void _filterAndCategorizeTodos() {
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    List<Todo> todosForSelectedDate = allTodos.where((todo) {
      return (todo.startDate.isBefore(selectedDateOnly) || todo.startDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todo.endDate.isAfter(selectedDateOnly) || todo.endDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();

    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => todo.goalId == selectedGoalId).toList();
    } else if (selectedFilter == FilterOption.importance) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => todo.importance == 1).toList();
    } else if (selectedFilter == FilterOption.dDay) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    } else if (selectedFilter == FilterOption.daily) {
      todosForSelectedDate = todosForSelectedDate.where((todo) => !todo.isDDayTodo()).toList();
    }

    dDayTodos = todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    dailyTodos = todosForSelectedDate.where((todo) => !todo.isDDayTodo()).toList();

    dDayTodos.sort((a, b) => a.endDate.difference(selectedDateOnly).inDays.compareTo(
        b.endDate.difference(selectedDateOnly).inDays));
    dailyTodos.sort((a, b) => b.importance.compareTo(a.importance));

    notifyListeners();
  }

  Future<void> updateTodoStatus(Todo todo, double status) async {
    try {
      todo.status = status;
      await _todoRepository.updateTodo(todo);
      final idx = allTodos.indexWhere((t) => t.id == todo.id);
      if (idx != -1) allTodos[idx] = todo;
      _filterAndCategorizeTodos();
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> deleteTodoById(String id) async {
    try {
      final target = allTodos.firstWhere((t) => t.id == id);
      await _todoRepository.deleteTodo(target);
      await loadTodos();
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> updateTodoDates(Todo todo, DateTime newStartDate, DateTime newEndDate) async {
    try {
      todo.startDate = newStartDate;
      todo.endDate = newEndDate;
      await _todoRepository.updateTodo(todo);
      await loadTodos();
    } catch (e) {
      print('Error updating todo dates: $e');
    }
  }
}