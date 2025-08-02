import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/chips/app_daily_chip.dart';
import 'package:presentation/designsystem/components/inputs/app_date_field.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/text_fields/tip.dart';
import 'package:presentation/widgets/todo/input/eisenhower_selector_section.dart';
import 'package:presentation/widgets/todo/input/goal_selection_section.dart';
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
            const SizedBox(height: AppSpacing.spacing32),
            Align(
              alignment: Alignment.centerRight,
              child: AppDailyChip(
                isLeftSelected: !viewModel.isDailyTodo,
                onSelectedChanged: (isLeftSelected) {
                  viewModel.setDailyTodoStatus(!isLeftSelected);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            AppInputField(
              label: '투두 이름',
              controller: viewModel.titleController,
              hintText: '투두의 이름을 입력해주세요.',
              errorText: viewModel.titleError,
              onChanged: (_) => viewModel.onTitleChanged(),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            GoalSelectionSection(viewModel: viewModel),
            const SizedBox(height: AppSpacing.spacing24),
            _buildDateSection(viewModel, context),
            const SizedBox(height: AppSpacing.spacing24),
            EisenhowerSelectorSection(viewModel: viewModel),
            const SizedBox(height: AppSpacing.spacing24),
            const TipWidget(
              title: 'TIP',
              description:
                  '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
                  '앞으로 투두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(TodoInputViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateField(
          label: '시작일',
          date: viewModel.startDate,
          showError: viewModel.startDateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: true),
        ),
        const SizedBox(width: AppSpacing.spacing16),
        AppDateField(
          label: '마감일',
          date: viewModel.endDate,
          showError: viewModel.endDateError != null,
          onTap: () => viewModel.selectDate(context, isStartDate: false),
        ),
      ],
    );
  }
}
