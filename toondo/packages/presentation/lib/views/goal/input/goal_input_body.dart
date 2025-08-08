import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_date_field.dart';
import 'package:presentation/designsystem/components/inputs/app_tip_text.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/views/goal/widget/goal_input_header_section.dart';
import 'package:presentation/views/goal/widget/goal_name_input_field.dart';
import 'package:provider/provider.dart';

class GoalInputBody extends StatelessWidget {
  const GoalInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();

    return SingleChildScrollView(
      child: Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.spacing48),
            GoalInputHeaderSection(),
            SizedBox(height: AppSpacing.spacing40),
            GoalNameInputField(
              controller: viewModel.goalNameController,
              errorText: viewModel.goalNameError,
            ),
            SizedBox(height: AppSpacing.spacing24),
            _buildDateSection(viewModel, context),
            SizedBox(height: AppSpacing.spacing18),
            _buildOptions(viewModel),
            SizedBox(height: AppSpacing.spacing24),
            _buildTipSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection() {
    return AppTipText(
      title: 'TIP',
      description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
    );
  }

  Widget _buildDateSection(GoalInputViewModel viewModel, BuildContext context) {
    return Row(
      children: [
        AppDateField(
          label: '시작일',
          date: viewModel.startDate,
          showError: viewModel.dateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: true),
        ),
        const SizedBox(width: AppSpacing.spacing12),
        AppDateField(
          label: '마감일',
          date: viewModel.endDate,
          showError: viewModel.dateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: false),
        ),
      ],
    );
  }

  Widget _buildOptions(GoalInputViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomCheckbox(
          label: '마감일 없이 할래요.',
          value: viewModel.withoutDeadline,
          onChanged: (v) => viewModel.toggleWithoutDeadline(v),
        ),
        SizedBox(height: AppSpacing.spacing8),
        _buildCustomCheckbox(
          label: '메인화면 노출',
          value: viewModel.showOnHome,
          onChanged: (v) => viewModel.toggleShowOnHome(v),
        ),
      ],
    );
  }

  Widget _buildCustomCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppDimensions.iconSize12,
              height: AppDimensions.iconSize12,
              decoration: BoxDecoration(
                color: value ? AppColors.green500 : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
              child: value
                  ? const Icon(
                Icons.check,
                size: 10,
                color: Colors.white,
              )
                  : null,
            ),
            const SizedBox(width: AppSpacing.spacing12),
            Baseline(
              baseline: 9,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                label,
                style: AppTypography.caption1Regular.copyWith(
                  color: AppColors.status100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
