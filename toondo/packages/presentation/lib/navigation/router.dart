import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/views/todo/todo_manage_view.dart';
import 'package:provider/provider.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/goal/goal_progress_screen.dart';
import 'package:presentation/views/welcome/welcome_screen.dart';
import 'package:presentation/views/auth/signup_screen.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'package:presentation/views/goal/goal_manage_view.dart';
import 'package:presentation/views/goal/goal_input_view.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.root:
        return MaterialPageRoute(
          builder:
              (_) => ChangeNotifierProvider(
                create: (_) => WelcomeViewModel(),
                child: WelcomeScreen(),
              ),
        );
      case RoutePaths.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutePaths.goalManage:
        return MaterialPageRoute(builder: (_) => GoalManageView());
      case RoutePaths.goalInput:
        return MaterialPageRoute(builder: (_) => GoalInputView());
      case RoutePaths.goalAnalisys:
        return MaterialPageRoute(builder: (_) => GoalProgressScreen());
      case RoutePaths.todoManage:
        return MaterialPageRoute(builder: (_) => TodoManageView());
      case RoutePaths.mypage:
        return MaterialPageRoute(builder: (_) => MyPageScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('404: ${settings.name} 라우트를 찾을 수 없습니다.'),
                ),
              ),
        );
    }
  }
}
