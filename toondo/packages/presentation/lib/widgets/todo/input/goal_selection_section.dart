import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/goal/goal_list_dropdown.dart';
import 'package:domain/entities/status.dart';

class GoalSelectionSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const GoalSelectionSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.fetchGoals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error loading goals');
        }
        final goals = (snapshot.data ?? []).where((g) => g.status == Status.active).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '목표',
              style: TextStyle(
                color: Color(0xFF1C1D1B),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
                fontFamily: 'Pretendard Variable',
              ),
            ),
            const SizedBox(height: 8),
            GoalListDropdown(
              selectedGoalId: viewModel.selectedGoalId,
              goals: goals,
              isDropdownOpen: viewModel.showGoalDropdown,
              onGoalSelected: viewModel.selectGoal,
              toggleDropdown: viewModel.toggleGoalDropdown,
            ),
          ],
        );
      },
    );
  }
}