import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/widgets/goal/manage/goal_filter_menu.dart';
import 'package:presentation/widgets/goal/manage/goal_manage_list_section.dart';
import 'package:presentation/widgets/goal/manage/goal_manage_title.dart';
import 'package:provider/provider.dart';

class GoalManageBody extends StatelessWidget {
  const GoalManageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalManagementViewModel>();
    final emptyMessage = switch (viewModel.filterOption) {
      GoalManagementFilterOption.completed => '완료된 목표가 없습니다.',
      GoalManagementFilterOption.givenUp => '포기한 목표가 없습니다.',
      GoalManagementFilterOption.inProgress => '등록된 목표가 없습니다.',
    };

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoalManageTitle(),
            const SizedBox(height: 32),
            GoalFilterMenu(
              selectedStatus: viewModel.filterOption == GoalManagementFilterOption.inProgress
                  ? Status.active
                  : Status.completed,
              onStatusSelected: (status) {
                viewModel.setFilterOption(
                  status == Status.active
                      ? GoalManagementFilterOption.inProgress
                      : GoalManagementFilterOption.completed,
                );
              },
            ),
            const SizedBox(height: 24),
            viewModel.filteredGoals.isEmpty
                ? Center(child: Text(emptyMessage, style: const TextStyle(fontSize: 14, color: Colors.grey)))
                : GoalManageListSection(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
