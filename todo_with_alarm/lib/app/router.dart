import 'package:flutter/material.dart';
import 'package:todo_with_alarm/views/goal/goal_input_screen.dart';
import 'package:todo_with_alarm/views/goal/goal_management_screen.dart';
import 'package:todo_with_alarm/views/home/home_screen.dart';
import 'package:todo_with_alarm/views/goal/goal_progress_screen.dart';
import 'package:todo_with_alarm/views/my_page/my_page_screen.dart';
import 'package:todo_with_alarm/views/todo/todo_submission_screen.dart';
// import 'package:todo_with_alarm/views/eisenhower_matrix_screen.dart';
import 'package:todo_with_alarm/views/welcome/welcome_screen.dart';
import 'package:todo_with_alarm/views/auth/signup_screen.dart';
// import 'package:todo_with_alarm/views/onboarding/onboarding_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case 'goal_manage':
        return MaterialPageRoute(builder: (_) => GoalManagementScreen());        
      case '/goal_input':
        return MaterialPageRoute(builder: (_) => GoalInputScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => GoalProgressScreen());
      case '/todo':
        return MaterialPageRoute(builder: (_) => TodoSubmissionScreen());
      case '/mypage':
        return MaterialPageRoute(builder: (_) => const MyPageScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('404: ${settings.name} 라우트를 찾을 수 없습니다.'),
            ),
          ),
        );
    }
  }
}