import 'package:flutter/material.dart';
import 'package:todo_with_alarm/app/router.dart';
import 'package:todo_with_alarm/services/goal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 앱의 목표 설정 여부를 확인
  bool isGoalSet = await GoalService.isGoalSet();

  runApp(MyApp(isGoalSet: isGoalSet));
}

class MyApp extends StatelessWidget {
  final bool isGoalSet;

  const MyApp({Key? key, required this.isGoalSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todolist with Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 목표가 설정되었는지에 따라 초기 화면 결정
      initialRoute: isGoalSet ? '/' : '/settings',
      onGenerateRoute: AppRouter.generateRoute, // AppRouter 설정
    );
  }
}