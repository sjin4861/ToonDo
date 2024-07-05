import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/flower_screen.dart';
import 'screens/activity_input_screen.dart';
import 'screens/onboarding_screen.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/onboarding': (context) => OnboardingScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/profile': (context) => ProfileScreen(),
    '/flower': (context) => FlowerScreen(),
    '/activity_input': (context) => ActivityInputScreen(),
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
      default:
        return null; // null을 반환하여 알 수 없는 경로일 경우 오류 방지
    }
  }
}