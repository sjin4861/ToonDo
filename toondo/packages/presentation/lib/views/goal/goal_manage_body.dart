import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/widgets/goal/manage/goal_filter_menu.dart';
import 'package:presentation/widgets/goal/manage/goal_manage_list_section.dart';
import 'package:provider/provider.dart';

class GoalManageBody extends StatelessWidget {
  const GoalManageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalManagementViewModel>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                ? const Center(child: Text('등록된 목표가 없습니다.'))
                : GoalManageListSection(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
