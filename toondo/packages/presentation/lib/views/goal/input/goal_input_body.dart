import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/inputs/app_date_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/goal/input/goal_input_header_section.dart';
import 'package:presentation/widgets/text_fields/goal_name_input_field.dart';
import 'package:presentation/widgets/text_fields/tip.dart';
import 'package:provider/provider.dart';

class GoalInputBody extends StatelessWidget {
  const GoalInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();

    return  SingleChildScrollView(
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
              _buildTipSection(),
            ],
          ),
      ),
    );
  }

  Widget _buildTipSection() {
    return TipWidget(
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
}