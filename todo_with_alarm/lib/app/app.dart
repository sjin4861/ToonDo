import 'package:flutter/material.dart';
import 'package:todo_with_alarm/app/router.dart'; // AppRouter를 import

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todolist with Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // 초기 화면 설정
      onGenerateRoute: AppRouter.generateRoute, // AppRouter를 통해 라우팅 처리
    );
  }
}