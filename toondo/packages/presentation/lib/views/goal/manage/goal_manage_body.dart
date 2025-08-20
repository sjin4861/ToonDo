import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/menu/app_selectable_menu_bar.dart';
import 'package:presentation/designsystem/components/toggles/app_goal_category_toggle.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/views/goal/widget/goal_manage_list_section.dart';
import 'package:provider/provider.dart';

class GoalManageBody extends StatelessWidget {
  const GoalManageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalManagementViewModel>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.spacing20),
          _HeaderSection(viewModel: viewModel),
          SizedBox(height: AppSpacing.spacing24),
          viewModel.filteredGoals.isEmpty
              ? _EmptyMessage(viewModel: viewModel)
              : GoalManageListSection(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final GoalManagementViewModel viewModel;

  const _HeaderSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표 관리하기',
          style: AppTypography.h2Bold.copyWith(color: AppColors.status100),
        ),
        SizedBox(height: AppSpacing.spacing28),
        AppSelectableMenuBar(
          labels: const ['진행', '완료'],
          selectedIndex: _filterTypeToIndex(viewModel.filterType),
          onChanged: (index) {
            viewModel.setFilterType(_indexToFilterType(index));
          },
        ),
        SizedBox(height: AppSpacing.spacing16),
        if (viewModel.filterType == GoalFilterType.completed)
          AppGoalCategoryToggle(
            labels: const ['성공리스트', '실패리스트', '포기리스트'],
            selectedIndex: _completionFilterToIndex(viewModel.completionFilter),
            onChanged: (index) {
              viewModel.setCompletionFilter(_indexToCompletionFilter(index));
            },
          ),
      ],
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final GoalManagementViewModel viewModel;

  const _EmptyMessage({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final text = _getMessage(viewModel);
    return Text(
      text,
      style: AppTypography.h3Regular.copyWith(
        color: AppColors.status100_50
      )
    );
  }

  String _getMessage(GoalManagementViewModel vm) {
    if (vm.filterType == GoalFilterType.inProgress) return '진행중인 목표가 없습니다.';
    return switch (vm.completionFilter) {
      GoalCompletionFilter.succeeded => '성공한 목표가 없습니다.',
      GoalCompletionFilter.failed => '실패한 목표가 없습니다.',
      GoalCompletionFilter.givenUp => '포기한 목표가 없습니다.',
      GoalCompletionFilter.all => '완료된 목표가 없습니다.',
    };
  }
}

int _filterTypeToIndex(GoalFilterType type) =>
    type == GoalFilterType.inProgress ? 0 : 1;

GoalFilterType _indexToFilterType(int index) =>
    index == 0 ? GoalFilterType.inProgress : GoalFilterType.completed;

int _completionFilterToIndex(GoalCompletionFilter filter) {
  switch (filter) {
    case GoalCompletionFilter.succeeded:
      return 0;
    case GoalCompletionFilter.failed:
      return 1;
    case GoalCompletionFilter.givenUp:
      return 2;
    case GoalCompletionFilter.all:
      return 3;
  }
}

GoalCompletionFilter _indexToCompletionFilter(int index) {
  switch (index) {
    case 0:
      return GoalCompletionFilter.succeeded;
    case 1:
      return GoalCompletionFilter.failed;
    case 2:
      return GoalCompletionFilter.givenUp;
    default:
      return GoalCompletionFilter.all;
  }
}
