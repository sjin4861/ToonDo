import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/toggles/app_goal_category_toggle.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/menu/app_selectable_menu_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/utils/todo_utils.dart';
import 'package:presentation/widgets/calendar/calendar.dart';
import 'package:presentation/widgets/todo/manage/todo_list_section.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:domain/entities/todo_filter_option.dart';

class TodoManageBody extends StatelessWidget {
  const TodoManageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoManageViewModel>();

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(viewModel),
            const SizedBox(height: AppSpacing.spacing32),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.todoMaxContentWidth,
              ),
              child: _buildContent(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TodoManageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.spacing40),
        Calendar(
          selectedDate: viewModel.selectedDate,
          onDateSelected: viewModel.updateSelectedDate,
        ),
      ],
    );
  }

  Widget _buildContent(TodoManageViewModel viewModel) {
    return SizedBox(
      width: AppDimensions.todoMaxContentWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuSection(viewModel),
          const SizedBox(height: AppSpacing.spacing16),
          _buildTodoList(viewModel),
        ],
      ),
    );
  }

  Widget _buildMenuSection(TodoManageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppSelectableMenuBar(
          labels: const ['전체', '목표', '중요'],
          selectedIndex: viewModel.selectedFilter.toIndex(),
          onChanged: (index) {
            viewModel.updateSelectedFilter(index.toFilter());
          },
        ),
        const SizedBox(height: AppSpacing.spacing16),
        _buildGoalToggle(viewModel),
      ],
    );
  }

  Widget _buildGoalToggle(TodoManageViewModel viewModel) {
    if (viewModel.selectedFilter != TodoFilterOption.goal) {
      return const SizedBox(height: AppSpacing.spacing8);
    }

    return AppGoalCategoryToggle(
      labels: viewModel.goals.map((g) => g.name).toList(),
      selectedIndex: viewModel.selectedGoalIndex,
      onChanged: (index) {
        final goal = viewModel.goals[index];
        viewModel.updateSelectedFilter(TodoFilterOption.goal, goalId: goal.id);
      },
    );
  }

  Widget _buildTodoList(TodoManageViewModel viewModel) {
    return SingleChildScrollView(
      child: SizedBox(
        width: AppDimensions.todoMaxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TodoListSection(
              title: '디데이 투두',
              todos: viewModel.dDayTodos,
              viewModel: viewModel,
              isDDay: true,
            ),
            const SizedBox(height: AppSpacing.spacing28),
            TodoListSection(
              title: '데일리 투두',
              todos: viewModel.dailyTodos,
              viewModel: viewModel,
              isDDay: false,
            ),
          ],
        ),
      ),
    );
  }
}
