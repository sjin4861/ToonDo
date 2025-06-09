import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/todo/common/dday_daily_chip.dart';

class DdayDailyChipSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const DdayDailyChipSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: DdayDailyChip(
        isDailySelected: viewModel.isDailyTodo,
        onToggle: viewModel.setDailyTodoStatus,
      ),
    );
  }
}