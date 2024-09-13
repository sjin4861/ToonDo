import 'package:flutter/material.dart';

class GoalProgressScreen extends StatelessWidget {
  const GoalProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 목표 진행률을 표시하는 위젯 구현
    return Scaffold(
      appBar: AppBar(
        title: Text('목표 진행률'),
      ),
      body: Center(
        child: Text('목표 진행률 화면입니다.'),
      ),
    );
  }
}