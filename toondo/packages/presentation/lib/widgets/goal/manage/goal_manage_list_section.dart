import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/widgets/goal/common/goal_list_item.dart';
import 'package:presentation/widgets/goal/manage/goal_options_bottom_sheet.dart';

class GoalManageListSection extends StatelessWidget {
  final GoalManagementViewModel viewModel;

  const GoalManageListSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.filterOption == GoalManagementFilterOption.completed) {
      final completedGoals = viewModel.getCompletedGoals();
      final givenUpGoals = viewModel.getGivenUpGoals();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completedGoals.isNotEmpty)
            _GoalCategoryList(title: '성공', goals: completedGoals),
          if (givenUpGoals.isNotEmpty)
            _GoalCategoryList(title: '포기', goals: givenUpGoals),
        ],
      );
    } else {
      return _GoalCategoryList(title: null, goals: viewModel.filteredGoals);
    }
  }
}

class _GoalCategoryList extends StatelessWidget {
  final String? title;
  final List<Goal> goals;

  const _GoalCategoryList({
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: GoalListItem(
                goal: goal,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (_) => GoalInputScreen(goal: goal),
                  ),
                  );
                }
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
