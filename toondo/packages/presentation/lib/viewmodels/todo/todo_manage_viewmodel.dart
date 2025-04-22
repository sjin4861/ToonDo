import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:flutter/material.dart'; // New dependency
import 'package:injectable/injectable.dart';

enum FilterOption { all, goal, importance, dDay, daily }

@LazySingleton()
class TodoManageViewModel extends ChangeNotifier {
  final FetchTodosUseCase _fetchTodosUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final GetAllTodosUseCase _getTodosUseCase;
  final UpdateTodoStatusUseCase _updateTodoStatusUseCase;
  final UpdateTodoDatesUseCase _updateTodoDatesUseCase;
  final GetGoalsLocalUseCase _getGoalsLocalUseCase;

  DateTime selectedDate;
  FilterOption selectedFilter = FilterOption.all;
  String? selectedGoalId;
  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];
  List<Goal> goals = [];

  TodoManageViewModel({
    required FetchTodosUseCase fetchTodosUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required GetAllTodosUseCase getTodosUseCase,
    required UpdateTodoStatusUseCase updateTodoStatusUseCase,
    required UpdateTodoDatesUseCase updateTodoDatesUseCase,
    required GetGoalsLocalUseCase getGoalsLocalUseCase,
    DateTime? initialDate,
  }) : _fetchTodosUseCase = fetchTodosUseCase,
       _deleteTodoUseCase = deleteTodoUseCase,
       _getTodosUseCase = getTodosUseCase,
       _updateTodoStatusUseCase = updateTodoStatusUseCase,
       _updateTodoDatesUseCase = updateTodoDatesUseCase,
       _getGoalsLocalUseCase = getGoalsLocalUseCase,
       selectedDate = initialDate ?? DateTime.now();

  Future<void> loadTodos() async {
    try {
      // 원격 서버에서 가져오는 대신 로컬 데이터베이스에서만 Todo 불러오기
      allTodos = await _getTodosUseCase();
      goals = await _getGoalsLocalUseCase();
      _filterAndCategorizeTodos();
    } catch (e) {
      print('Error loading todos from local storage: $e');
    }
  }

  Future<List<Todo>> getTodos() async {
    return await _getTodosUseCase();
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

  void updateSelectedGoal(Goal goal) {
    selectedGoalId = goal.id;
    updateSelectedFilter(FilterOption.goal, goalId: goal.id);
  }

  void _filterAndCategorizeTodos() {
    DateTime selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    List<Todo> todosForSelectedDate =
        allTodos.where((todo) {
          return (todo.startDate.isBefore(selectedDateOnly) ||
                  todo.startDate.isAtSameMomentAs(selectedDateOnly)) &&
              (todo.endDate.isAfter(selectedDateOnly) ||
                  todo.endDate.isAtSameMomentAs(selectedDateOnly));
        }).toList();

    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      todosForSelectedDate =
          todosForSelectedDate
              .where((todo) => todo.goalId == selectedGoalId)
              .toList();
    } else if (selectedFilter == FilterOption.importance) {
      todosForSelectedDate =
          todosForSelectedDate.where((todo) => todo.importance == 1).toList();
    } else if (selectedFilter == FilterOption.dDay) {
      todosForSelectedDate =
          todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    } else if (selectedFilter == FilterOption.daily) {
      todosForSelectedDate =
          todosForSelectedDate.where((todo) => !todo.isDDayTodo()).toList();
    }

    dDayTodos =
        todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    dailyTodos =
        todosForSelectedDate.where((todo) => !todo.isDDayTodo()).toList();

    dDayTodos.sort(
      (a, b) => a.endDate
          .difference(selectedDateOnly)
          .inDays
          .compareTo(b.endDate.difference(selectedDateOnly).inDays),
    );
    dailyTodos.sort((a, b) => b.importance.compareTo(a.importance));

    notifyListeners();
  }

  Future<void> updateTodoStatus(Todo todo, double status) async {
    try {
      await _updateTodoStatusUseCase(todo, status);
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
      await _deleteTodoUseCase(target);
      await loadTodos();
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> updateTodoDates(
    Todo todo,
    DateTime newStartDate,
    DateTime newEndDate,
  ) async {
    try {
      await _updateTodoDatesUseCase(todo, newStartDate, newEndDate);
      await loadTodos();
    } catch (e) {
      print('Error updating todo dates: $e');
    }
  }
}
