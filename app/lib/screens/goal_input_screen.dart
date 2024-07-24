import 'package:flutter/material.dart';

class GoalInputScreen extends StatefulWidget {
  @override
  _GoalInputScreenState createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Enter your goal'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final goal = _goalController.text;
                if (goal.isNotEmpty) {
                  // 목표 저장 및 캐릭터 매칭 로직 호출
                  Navigator.pushNamed(context, '/characterMatch', arguments: goal);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}