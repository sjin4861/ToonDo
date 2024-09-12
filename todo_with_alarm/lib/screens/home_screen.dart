import 'package:flutter/material.dart';
import 'package:todo_with_alarm/services/notification_service.dart'; // NotificationService 경로

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initialize(); // 알림 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Go to Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/progress');
              },
              child: Text('Go to Progress'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/todo'); // TodoSubmissionScreen으로 이동
              },
              child: Text('Go to Todo Submission'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _notificationService.showImmediateNotification();
              },
              child: const Text('즉각 알림 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}