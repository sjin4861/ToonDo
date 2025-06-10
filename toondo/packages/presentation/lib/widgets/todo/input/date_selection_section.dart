import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/todo/common/todo_input_date_field.dart';

class DateSelectionSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const DateSelectionSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isDailyTodo) return const SizedBox();
    return Row(
      children: [
        DateField(viewModel: viewModel, label: "시작일"),
        const SizedBox(width: 16),
        DateField(viewModel: viewModel, label: "마감일"),
      ],
    );
  }
}
