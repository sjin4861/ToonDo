import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/todo_filter_option.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TodoManageViewModel extends ChangeNotifier {
  final DeleteTodoUseCase _deleteTodoUseCase;
  final GetAllTodosUseCase _getTodosUseCase;
  final UpdateTodoStatusUseCase _updateTodoStatusUseCase;
  final UpdateTodoDatesUseCase _updateTodoDatesUseCase;
  final GetGoalsLocalUseCase _getGoalsLocalUseCase;

  DateTime selectedDate;
  TodoFilterOption selectedFilter = TodoFilterOption.all;
  String? selectedGoalId;
  List<Todo> allTodos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];
  List<Goal> goals = [];

  TodoManageViewModel({
    required DeleteTodoUseCase deleteTodoUseCase,
    required GetAllTodosUseCase getTodosUseCase,
    required UpdateTodoStatusUseCase updateTodoStatusUseCase,
    required UpdateTodoDatesUseCase updateTodoDatesUseCase,
    required GetGoalsLocalUseCase getGoalsLocalUseCase,
    DateTime? initialDate,
  }) : _deleteTodoUseCase = deleteTodoUseCase,
       _getTodosUseCase = getTodosUseCase,
       _updateTodoStatusUseCase = updateTodoStatusUseCase,
       _updateTodoDatesUseCase = updateTodoDatesUseCase,
       _getGoalsLocalUseCase = getGoalsLocalUseCase,
       selectedDate = initialDate ?? DateTime.now();

  Future<void> loadTodos() async {
    try {
      // NOTE 원격 서버에서 가져오는 대신 로컬 데이터베이스에서만 Todo 불러오기 (수정필)
      allTodos = _getTodosUseCase();
      goals = await _getGoalsLocalUseCase();
      _filterAndCategorizeTodos();
      notifyListeners();
    } catch (e) {
      print('Error loading todos from local storage: $e');
    }
  }

  Future<List<Todo>> getTodos() async {
    return _getTodosUseCase();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    _filterAndCategorizeTodos();
    notifyListeners();
  }

  void updateSelectedFilter(TodoFilterOption filter, {String? goalId}) {
    selectedFilter = filter;
    selectedGoalId = goalId;
    _filterAndCategorizeTodos();
    notifyListeners();
  }

  void updateSelectedGoal(Goal goal) {
    selectedGoalId = goal.id;
    updateSelectedFilter(TodoFilterOption.goal, goalId: goal.id);
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
                  _isSameDay(todo.startDate, selectedDateOnly)) &&
              (todo.endDate.isAfter(selectedDateOnly) ||
                  _isSameDay(todo.endDate, selectedDateOnly));
        }).toList();

    if (selectedFilter == TodoFilterOption.goal && selectedGoalId != null) {
      todosForSelectedDate =
          todosForSelectedDate
              .where((todo) => todo.goalId == selectedGoalId)
              .toList();
    } else if (selectedFilter == TodoFilterOption.importance) {
      // eisenhower 필드로 변경 - 중요하고 긴급한 항목들(2: 중요, 3: 중요+긴급)
      todosForSelectedDate =
          todosForSelectedDate.where((todo) => todo.eisenhower >= 2).toList();
    } else if (selectedFilter == TodoFilterOption.dDay) {
      todosForSelectedDate =
          todosForSelectedDate.where((todo) => todo.isDDayTodo()).toList();
    } else if (selectedFilter == TodoFilterOption.daily) {
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
    // eisenhower 필드로 정렬 - 중요도 순으로 정렬 (높은 값이 더 중요)
    dailyTodos.sort((a, b) => b.eisenhower.compareTo(a.eisenhower));

    notifyListeners();
  }

  Future<void> updateTodoStatus(Todo todo, double status) async {
    try {
      await _updateTodoStatusUseCase(todo, status);
      final idx = allTodos.indexWhere((t) => t.id == todo.id);
      if (idx != -1) {
        // 상태 변경된 새 Todo 생성 후 반영 - eisenhower 필드로 변경
        final updated = Todo(
          id: todo.id,
          title: todo.title,
          startDate: todo.startDate,
          endDate: todo.endDate,
          goalId: todo.goalId,
          status: status,
          comment: todo.comment,
          eisenhower: todo.eisenhower,
        );
        allTodos[idx] = updated;
      }
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

  Future<void> delayTodoToTomorrow(Todo todo) async {
    try {
      final newStartDate = todo.startDate.add(const Duration(days: 1));
      final newEndDate = todo.endDate.add(const Duration(days: 1));
      await updateTodoDates(todo, newStartDate, newEndDate);
    } catch (e) {
      print('Error delaying todo: $e');
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

  int get selectedGoalIndex {
    return goals.indexWhere((g) => g.id == selectedGoalId);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
