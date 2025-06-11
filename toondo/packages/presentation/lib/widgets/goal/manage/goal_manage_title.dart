import 'package:flutter/material.dart';

class GoalManageTitle extends StatelessWidget {
  const GoalManageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '목표 관리하기',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Pretendard Variable',
        height: 1.0,
        letterSpacing: 0.15,
      ),
    );
  }
}
