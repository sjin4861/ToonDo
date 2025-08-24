import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/chips/app_daily_chip.dart';
import 'package:presentation/designsystem/components/inputs/app_date_field.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/components/select_priority/app_eiwenhower_selector.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/designsystem/components/inputs/app_tip_text.dart';
import 'package:presentation/views/todo/widget/goal_selection_section.dart';
import 'package:provider/provider.dart';

class TodoInputBody extends StatelessWidget {
  const TodoInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoInputViewModel>();

    return SingleChildScrollView(
      child: Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.v32),
            if (viewModel.isOnboarding)
              _buildOnboardingHeader(),
            Align(
              alignment: Alignment.centerRight,
              child: AppDailyChip(
                isLeftSelected: !viewModel.isDailyTodo,
                onSelectedChanged: (isLeftSelected) {
                  viewModel.setDailyTodoStatus(!isLeftSelected);
                },
              ),
            ),
            SizedBox(height: AppSpacing.v16),
            AppInputField(
              label: '투두 이름',
              controller: viewModel.titleController,
              hintText: '투두의 이름을 입력해주세요.',
              errorText: viewModel.titleError,
              onChanged: (_) => viewModel.onTitleChanged(),
            ),
            SizedBox(height: AppSpacing.v24),
            GoalSelectionSection(viewModel: viewModel),
            SizedBox(height: AppSpacing.v24),
            if (!viewModel.isDailyTodo)
              _buildDateSection(viewModel, context),
            SizedBox(height: AppSpacing.v24),
            Text(
              '아이젠하워',
              style: AppTypography.caption1Regular.copyWith(
                color: AppColors.status100,
              ),
            ),
            SizedBox(height: AppSpacing.v8),
            AppEisenhowerSelector(
              selectedType: viewModel.selectedEisenhowerType,
              onChanged: viewModel.setEisenhowerType,
            ),
            SizedBox(height: AppSpacing.v24),
            if (viewModel.isOnboarding)
              const AppTipText(
                title: 'TIP',
                description: '아이젠하워는 긴급도과 중요도에 따라 할 일을 정리하는 방법이에요.\n앞으로 툰두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(TodoInputViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateField(
          label: '시작일',
          date: viewModel.startDate,
          showError: viewModel.startDateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: true),
        ),
        SizedBox(width: AppSpacing.h16),
        AppDateField(
          label: '마감일',
          date: viewModel.endDate,
          showError: viewModel.endDateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: false),
        ),
      ],
    );
  }

  Widget _buildOnboardingHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표의 투두를 만들어 볼까요?',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(height: AppSpacing.v8),
        Text(
          '지금 바로 투두(To-Do)를 만들면 나의 목표를 현실로 만들 수 있어요!',
          style: AppTypography.caption1Regular.copyWith(color: AppColors.status100_75),
        ),
        SizedBox(height: AppSpacing.v40),
      ],
    );
  }
}
