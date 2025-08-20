import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/designsystem/components/bottom_sheets/goal_edit_bottom_sheet.dart';
import 'package:presentation/designsystem/components/items/app_goal_item.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/utils/goal_utils.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';


class GoalManageListSection extends StatelessWidget {
  final GoalManagementViewModel viewModel;

  const GoalManageListSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final type = viewModel.filterType;
    final filter = viewModel.completionFilter;

    if (type == GoalFilterType.inProgress) {
      return _GoalCategory(goals: viewModel.filteredGoals, viewModel: viewModel);
    }

    if (type == GoalFilterType.completed && filter == GoalCompletionFilter.all) {
      final grouped = groupGoalsByCompletion(viewModel.filteredGoals);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => _GoalCategory(goals: entry.value, viewModel: viewModel))
            .toList(),
      );
    }

    // 나머지 필터 (성공, 실패, 포기)
    return _GoalCategory(
      goals: viewModel.filteredGoals,
      viewModel: viewModel,
    );
  }
}

class _GoalCategory extends StatelessWidget {
  final List<Goal> goals;
  final GoalManagementViewModel viewModel;

  const _GoalCategory({required this.goals, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.spacing12),
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing8),
              child: AppGoalItem(
                dismissKey: ValueKey(goal.id),
                onDelete: () { viewModel.deleteGoal(goal.id); },
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => GoalEditBottomSheet(
                      title: goal.name,
                      iconPath: goal.icon ?? Assets.icons.icGoal.path,
                      onEdit: () {
                        Navigator.pop(context);
                        _navigateToEdit(context, goal);
                      },
                      onDelete: () {
                        Navigator.pop(context);
                        viewModel.deleteGoal(goal.id);
                      },
                    ),
                  );
                },
                title: goal.name,
                iconPath: goal.icon,
                subTitle: buildGoalSubtitle(goal.startDate, goal.endDate),
                isChecked: isGoalChecked(goal.status),
                onCheckedChanged: (value) {
                  if (value) {
                    viewModel.completeGoal(goal.id);
                  } else {
                    viewModel.giveUpGoal(goal.id);
                  }
                },
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.spacing16),
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
