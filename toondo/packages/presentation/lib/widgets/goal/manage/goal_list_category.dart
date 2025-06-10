import 'package:domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:presentation/widgets/goal/common/goal_list_item.dart';
import 'package:presentation/widgets/goal/manage/goal_options_bottom_sheet.dart';

class GoalListCategory extends StatelessWidget {
  final String? title;
  final List<Goal> goals;

  const GoalListCategory({
    super.key,
    this.title,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.16,
            ),
          ),
          const SizedBox(height: 8),
        ],
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GoalListItem(
                goal: goal,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => GoalOptionsBottomSheet(goal: goal),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
