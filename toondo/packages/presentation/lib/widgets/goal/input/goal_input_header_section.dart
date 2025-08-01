import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:provider/provider.dart';

class GoalInputHeaderSection extends StatelessWidget {
  const GoalInputHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();
    final isEditing = viewModel.targetGoal != null;
    final isFromOnboarding = viewModel.isFromOnboarding;

    final title = isFromOnboarding
        ? '목표를 정해 볼까요?'
        : (isEditing ? '목표를 발전시켜봐요' : '목표를 정해주세요!');

    final subtitle = isFromOnboarding
        ? '앞으로 툰두와 함께 달려 나갈 목표를 알려주세요.'
        : '앞으로 툰두와 함께 달려 나갈 목표를 입력해주세요.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h2Bold.copyWith(
            color: AppColors.green500
          )
        ),
        const SizedBox(height: AppSpacing.spacing8),
        Text(
          subtitle,
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75
          )
        ),
      ],
    );
  }
}
