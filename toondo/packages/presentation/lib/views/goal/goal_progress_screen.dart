// screens/goal_progress_screen.dart

import 'package:flutter/material.dart';

class GoalProgressScreen extends StatelessWidget {
  const GoalProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // viewmodel 없이 임시 상태
    return Scaffold(
      appBar: AppBar(
        title: Text('목표 진행률'),
      ),
      body: Center(
        child: Text('준비 중입니다.'),
      ),
    );
  }
}