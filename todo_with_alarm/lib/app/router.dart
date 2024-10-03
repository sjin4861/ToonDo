// app/router.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/screens/goal_input_screen.dart';
import 'package:todo_with_alarm/screens/home_screen.dart';
import 'package:todo_with_alarm/screens/goal_progress_screen.dart';
import 'package:todo_with_alarm/screens/todo_submission_screen.dart';
import 'package:todo_with_alarm/screens/eisenhower_matrix_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/goal_input':
        // ignore: non_constant_identifier_names
        return MaterialPageRoute(builder: (_) => GoalInputScreen(onGoalSet: (Goal ) {  },));
      case '/progress':
        return MaterialPageRoute(builder: (_) => GoalProgressScreen());
      case '/todo':
        return MaterialPageRoute(builder: (_) => TodoSubmissionScreen());
      case '/eisenhower':
        return MaterialPageRoute(builder: (_) => EisenhowerMatrixScreen());
      // 필요한 경우 추가 라우트 설정
      default:
        return null;
    }
  }
}