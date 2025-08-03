import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/views/home/widget/home_goal_list_item.dart';

class HomeGoalListSection extends StatelessWidget {
  final List<Goal> goals;

  const HomeGoalListSection({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '설정된 목표가 없습니다. 목표를 추가해보세요!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: HomeGoalListItem(
              goal: goal,
              onTap: () {
                // TODO: 캐릭터 상호작용 등 홈 화면 전용 로직
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
