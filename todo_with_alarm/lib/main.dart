// main.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/app/router.dart';
import 'package:todo_with_alarm/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // StatefulWidget으로 변경하여 NotificationService를 초기화
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  // NavigatorKey를 사용하여 어디서나 Navigator에 접근 가능하게 함
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // 알림 서비스 초기화 및 알림 예약
  void _initializeNotifications() async {
    await _notificationService.initialize(navigatorKey.currentContext!);
    await _notificationService.scheduleAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todolist with Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey, // navigatorKey 설정
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}