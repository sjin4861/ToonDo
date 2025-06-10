import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/widgets/goal/common/goal_list_item.dart';

class HomeGoalListSection extends StatelessWidget {
  final List<Goal> goals;

  const HomeGoalListSection({
    Key? key,
    required this.goals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(
        child: Text(
          '설정된 목표가 없습니다. 목표를 추가해보세요!',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: GoalListItem(
              goal: goal,
              enableSwipeToDelete: false,
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
