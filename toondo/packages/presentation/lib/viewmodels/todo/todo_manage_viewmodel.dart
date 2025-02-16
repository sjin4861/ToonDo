import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:domain/usecases/todo/commit_todos.dart';
import 'package:domain/usecases/todo/create_todo.dart';

enum FilterOption { all, goal, importance, dDay, daily }

class TodoManageViewModel extends ChangeNotifier {
  final FetchTodos _fetchTodosUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final CommitTodos _commitTodosUseCase;
  final CreateTodo _createTodoUseCase;
  final GetAllTodosUseCase _getTodosUseCase;
  final UpdateTodoStatus _updateTodoStatusUseCase;
  final UpdateTodoDates _updateTodoDatesUseCase;

  DateTime selectedDate;
  FilterOption selectedFilter = FilterOption.all;
  String? selectedGoalId;
  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];

  TodoManageViewModel({
    required FetchTodos fetchTodosUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required CommitTodos commitTodosUseCase,
    required CreateTodo createTodoUseCase,
    required GetAllTodosUseCase getTodosUseCase,
    required UpdateTodoStatus updateTodoStatusUseCase,
    required UpdateTodoDates updateTodoDatesUseCase,
    DateTime? initialDate,
  }) : _fetchTodosUseCase = fetchTodosUseCase,
       _deleteTodoUseCase = deleteTodoUseCase,
       _commitTodosUseCase = commitTodosUseCase,
       _createTodoUseCase = createTodoUseCase,
       _getTodosUseCase = getTodosUseCase,
       _updateTodoStatusUseCase = updateTodoStatusUseCase,
       _updateTodoDatesUseCase = updateTodoDatesUseCase,
       selectedDate = initialDate ?? DateTime.now();

  Future<void> loadTodos() async {
    allTodos = await _fetchTodosUseCase();
    _filterAndCategorizeTodos();
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

  void updateSelectedGoal(goal) {
    selectedGoalId = goal.id;
    updateSelectedFilter(FilterOption.goal);
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
