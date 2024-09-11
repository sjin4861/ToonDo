import 'package:flutter/material.dart';
import 'package:todo_with_alarm/services/goal_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController goal1Controller = TextEditingController();
  final TextEditingController goal2Controller = TextEditingController();
  final TextEditingController goal3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('목표 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: goal1Controller,
              decoration: InputDecoration(labelText: '첫 번째 목표'),
            ),
            TextField(
              controller: goal2Controller,
              decoration: InputDecoration(labelText: '두 번째 목표'),
            ),
            TextField(
              controller: goal3Controller,
              decoration: InputDecoration(labelText: '세 번째 목표'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 목표를 설정하고 저장하는 로직
                await GoalService.setGoal(true);
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('목표 설정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}