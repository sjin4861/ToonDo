import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/inputs/app_date_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
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
          child: AppDateField(
            label: '시작일',
            date: viewModel.startDate,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: viewModel.startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                viewModel.startDate = picked;
              }
            },
          ),
        ),
        const SizedBox(width: AppSpacing.spacing16),
        Expanded(
          child: AppDateField(
            label: '마감일',
            date: viewModel.endDate,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: viewModel.endDate ?? viewModel.startDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                viewModel.endDate = picked;
              }
            },
          ),
        ),
      ],
    );
  }
}
