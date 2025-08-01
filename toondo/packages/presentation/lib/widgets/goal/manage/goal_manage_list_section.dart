import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/items/app_goal_item.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/widgets/goal/common/goal_list_item.dart';

class GoalManageListSection extends StatelessWidget {
  final GoalManagementViewModel viewModel;

  const GoalManageListSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final type = viewModel.filterType;
    final filter = viewModel.completionFilter;

    if (type == GoalFilterType.inProgress) {
      return _GoalCategory(title: null, goals: viewModel.filteredGoals);
    }

    if (type == GoalFilterType.completed &&
        filter == GoalCompletionFilter.all) {
      final now = DateTime.now();
      final succeeded =
          viewModel.filteredGoals
              .where((g) => g.status == Status.completed)
              .toList();
      final failed =
          viewModel.filteredGoals
              .where(
                (g) => g.status == Status.active && g.endDate.isBefore(now),
              )
              .toList();
      final givenUp =
          viewModel.filteredGoals
              .where((g) => g.status == Status.givenUp)
              .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (succeeded.isNotEmpty)
            _GoalCategory(title: '성공', goals: succeeded),
          if (failed.isNotEmpty) _GoalCategory(title: '실패', goals: failed),
          if (givenUp.isNotEmpty) _GoalCategory(title: '포기', goals: givenUp),
        ],
      );
    }

    // 나머지 필터 (성공, 실패, 포기)
    return _GoalCategory(
      title: _filterLabel(filter),
      goals: viewModel.filteredGoals,
    );
  }

  String? _filterLabel(GoalCompletionFilter filter) {
    return switch (filter) {
      GoalCompletionFilter.succeeded => '성공',
      GoalCompletionFilter.failed => '실패',
      GoalCompletionFilter.givenUp => '포기',
      GoalCompletionFilter.all => null,
    };
  }
}

class _GoalCategory extends StatelessWidget {
  final String? title;
  final List<Goal> goals;

  const _GoalCategory({this.title, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title!,
              style: AppTypography.h2SemiBold.copyWith(
                color: AppColors.status100,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AppGoalItem(
                dismissKey: ValueKey(goal.id),
                onTap: () => _navigateToEdit(context, goal),
                title: goal.name,
                iconPath: goal.icon,
                subTitle: goal.startDate.toString().substring(0, 10) +
                    ' ~ ' +
                    goal.endDate.toString().substring(0, 10),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _navigateToEdit(BuildContext context, Goal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GoalInputScreen(goal: goal)),
    );
  }
}
