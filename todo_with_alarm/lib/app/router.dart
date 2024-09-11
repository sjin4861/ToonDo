import 'package:flutter/material.dart';
import 'package:todo_with_alarm/screens/home_screen.dart';
import 'package:todo_with_alarm/screens/settings_screen.dart';
import 'package:todo_with_alarm/screens/progress_screen.dart';
import 'package:todo_with_alarm/screens/todo_submission_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => ProgressScreen());
      case '/todo': // TodoSubmissionScreen 경로 추가
        return MaterialPageRoute(builder: (_) => TodoSubmissionScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}