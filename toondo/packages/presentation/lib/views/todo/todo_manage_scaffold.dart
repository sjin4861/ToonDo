import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/todo/bottom_spacer.dart';
import 'package:presentation/widgets/todo/manage/goal_selection_bar.dart';
import 'package:presentation/widgets/todo/manage/todo_filter_section.dart';
import 'package:presentation/widgets/todo/manage/todo_list_section.dart';
import 'package:presentation/widgets/todo/manage/week_selector_section.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:provider/provider.dart';

class TodoManageScaffold extends StatelessWidget {
  const TodoManageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoManageViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: '투두리스트'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            child: Column(
              children: [
                WeekSelectorSection(
                  selectedDate: viewModel.selectedDate,
                  onDateSelected: viewModel.updateSelectedDate,
                ),
                const SizedBox(height: 32.0),
                TodoFilterSection(
                  selectedFilter: viewModel.selectedFilter,
                  onFilterSelected: viewModel.updateSelectedFilter,
                ),
                if (viewModel.selectedFilter == FilterOption.goal)
                  GoalSelectionBar(
                    goals: viewModel.goals,
                    selectedGoalId: viewModel.selectedGoalId,
                    onGoalSelected:
                        (goalId) => viewModel.updateSelectedFilter(
                          FilterOption.goal,
                          goalId: goalId,
                        ),
                  ),
                const SizedBox(height: 28.0),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodoListSection(
                      title: '디데이 투두',
                      todos: viewModel.dDayTodos,
                      viewModel: viewModel,
                      isDDay: true,
                    ),
                    const SizedBox(height: 8.0),
                    TodoListSection(
                      title: '데일리 투두',
                      todos: viewModel.dailyTodos,
                      viewModel: viewModel,
                      isDDay: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const BottomSpacer(),
        ],
      ),
    );
  }
}
