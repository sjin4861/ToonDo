// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_viewmodel.dart';
import 'package:todo_with_alarm/app/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_with_alarm/services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoalViewModel(goalService: GoalService())..loadGoals(),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoViewModel(TodoService())..loadTodos(),
        ),
      ],
      child: MyApp(),
    ),
  );
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
    // Delay the notification initialization until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionsAndInitializeNotifications();
    });
  }

  // 알림 권한 요청 및 알림 서비스 초기화
  Future<void> _requestPermissionsAndInitializeNotifications() async {
    // 알림 권한 요청
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      // 권한 요청
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      // 권한이 부여된 경우 알림 서비스 초기화 및 알림 예약
      if (navigatorKey.currentContext != null) {
        await _notificationService.initialize(navigatorKey.currentContext!);
        await _notificationService.scheduleAllNotifications();
      } else {
        print("Navigator context is null, cannot initialize notifications.");
      }
    } else if (status.isPermanentlyDenied) {
      // 사용자가 권한을 영구적으로 거부한 경우 설정으로 유도
      bool opened = await openAppSettings();
      if (!opened) {
        print("설정 앱을 열 수 없습니다.");
      }
    } else {
      print("알림 권한이 거부되었습니다.");
    }
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