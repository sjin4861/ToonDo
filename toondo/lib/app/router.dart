import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toondo/ui/todo/todo_manage/todo_manage_view.dart';
import 'package:toondo/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:toondo/views/goal/goal_input_screen.dart';
import 'package:toondo/views/goal/goal_management_screen.dart';
import 'package:toondo/views/home/home_screen.dart';
import 'package:toondo/views/goal/goal_progress_screen.dart';
import 'package:toondo/views/my_page/my_page_screen.dart';
// import 'package:toondo/views/todo/todo_submission_screen.dart';
import 'package:toondo/ui/todo/todo_manage/todo_manage_view.dart';
// import 'package:toondo/views/eisenhower_matrix_screen.dart';
import 'package:toondo/views/welcome/welcome_screen.dart';
import 'package:toondo/views/auth/signup_screen.dart';
// import 'package:toondo/views/onboarding/onboarding_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => WelcomeViewModel(),
            child: WelcomeScreen(),
          ),
        );
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
        return MaterialPageRoute(builder: (_) => TodoManageView());
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