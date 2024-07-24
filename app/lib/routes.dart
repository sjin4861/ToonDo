import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/flower_screen.dart';
import 'screens/activity_input_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/goal_input_screen.dart'; // 새로운 목표 설정 화면
import 'screens/character_match_screen.dart'; // 새로운 캐릭터 매칭 화면

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/onboarding': (context) => OnboardingScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/profile': (context) => ProfileScreen(),
    '/flower': (context) => FlowerScreen(),
    '/activity_input': (context) => ActivityInputScreen(),
    '/goalInput': (context) => GoalInputScreen(), // 새로운 목표 설정 화면 추가
    '/characterMatch': (context) => CharacterMatchScreen(), // 새로운 캐릭터 매칭 화면 추가
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/profile':
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case '/flower':
        return MaterialPageRoute(builder: (context) => FlowerScreen());
      case '/activity_input':
        return MaterialPageRoute(builder: (context) => ActivityInputScreen());
      case '/goalInput':
        return MaterialPageRoute(builder: (context) => GoalInputScreen()); // 새로운 목표 설정 화면
      case '/characterMatch':
        return MaterialPageRoute(builder: (context) => CharacterMatchScreen()); // 새로운 캐릭터 매칭 화면
      default:
        return null; // 알 수 없는 경로일 경우 오류 방지
    }
  }
}