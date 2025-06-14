import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/goal/input/goal_input_date_field.dart';
import 'package:provider/provider.dart';

class GoalDateSelectionSection extends StatelessWidget {
  const GoalDateSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();
    return Row(
      children: [
        Expanded(
          child: GoalInputDateField(
            viewModel: viewModel,
            label: '시작일',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GoalInputDateField(
            viewModel: viewModel,
            label: '마감일',
          ),
        ),
      ],
    );
  }
}
