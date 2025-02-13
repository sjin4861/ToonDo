// lib/widgets/goal/goal_list_section.dart

import 'package:flutter/material.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/widgets/goal/goal_list_item.dart';

class GoalListSection extends StatelessWidget {
  final List<Goal> topGoals;

  const GoalListSection({Key? key, required this.topGoals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (topGoals.isEmpty) {
      return const Center(
        child: Text(
          '설정된 목표가 없습니다. 목표를 추가해보세요!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: topGoals.map((goal) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GoalListItem(
            goal: goal,
            onTap: () {
              // TODO: 캐릭터 상호작용 등
            },
          ),
        );
      }).toList(),
    );
  }
}