import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/dropdowns/app_goal_dropdown.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:domain/entities/status.dart';

class GoalSelectionSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const GoalSelectionSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final activeGoals = viewModel.goals
        .where((g) => g.status == Status.active)
        .toList();
    
    final dropdownItems = activeGoals.map(
          (g) => GoalDropdownItem(
        id: int.tryParse(g.id) ?? 0,
        title: g.name,
        iconPath: g.icon,
      ),
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        AppGoalDropdown(
          items: dropdownItems,
          selectedId: viewModel.selectedGoalId,
          isExpanded: viewModel.showGoalDropdown,
          onToggle: viewModel.toggleGoalDropdown,
          onItemSelected: (id) => viewModel.selectGoal(id.toString()),
        ),
      ],
    );
  }
}
