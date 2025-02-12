// // viewmodels/goal_progress_viewmodel.dart

// import 'package:flutter/material.dart';
// import 'package:todo_with_alarm/models/goal.dart';
// import 'package:todo_with_alarm/models/todo.dart';
// import 'package:todo_with_alarm/services/todo_service.dart';
// import 'package:todo_with_alarm/services/goal_service.dart';
// import 'package:intl/intl.dart';

// class GoalProgressViewModel extends ChangeNotifier {
//   final GoalService goalService;
//   final TodoService todoService;

//   GoalProgressViewModel({
//     required this.goalService,
//     required this.todoService,
//   });

//   Future<List<GoalTodoData>> getGoalTodoDataForLastWeek() async {
//     DateTime now = DateTime.now();
//     DateTime lastWeekStart = _getLastWeekStart(now);
//     DateTime lastWeekEnd = _getLastWeekEnd(lastWeekStart);

//     return await _calculateGoalTodoData(lastWeekStart, lastWeekEnd);
//   }

//   DateTime _getLastWeekStart(DateTime now) {
//     return now.subtract(Duration(days: now.weekday + 6)); // 지난 주 월요일
//   }

//   DateTime _getLastWeekEnd(DateTime lastWeekStart) {
//     return lastWeekStart.add(Duration(days: 6)); // 지난 주 일요일
//   }

//   Future<List<GoalTodoData>> _calculateGoalTodoData(DateTime lastWeekStart, DateTime lastWeekEnd) async {
//     // 지난 주에 수행한 Todo의 목록을 가져옴
//     // 이후 해당 Todo의 연관 목표를 찾아서 진행률을 계산
//     List<Todo> todos = await todoService.getTodos();
//     List<Goal> goals = await goalService.getGoals();

//     List<GoalTodoData> goalTodoData = [];

//     for (Goal goal in goals) {
//       int totalTodos = _getTotalTodosCount(todos, goal.id, lastWeekStart, lastWeekEnd);
//       int completedTodos = _getCompletedTodosCount(todos, lastWeekStart, lastWeekEnd);

//       double percentage = _calculatePercentage(completedTodos, totalTodos);
//       goalTodoData.add(GoalTodoData(goalName: goal.name, percentage: percentage));
//     }
//   }

//   int _getCompletedTodosCount(List<Todo> todos, DateTime lastWeekStart, DateTime lastWeekEnd) {
//     return todos.where((todo) {
//       return todo.status == 100.0 &&
//           todo.startDate.isAfter(lastWeekStart) &&
//           todo.endDate.isBefore(lastWeekEnd);
//     }).length;
//   }

//   double _calculatePercentage(int completedTodos, int totalTodos) {
//     return totalTodos > 0 ? (completedTodos / totalTodos) * 100 : 0;
//   }
// }

// class GoalTodoData {
//   final String goalName;
//   final double percentage;

//   GoalTodoData({required this.goalName, required this.percentage});
// }
