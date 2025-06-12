import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/text_fields/goal_name_input_field.dart';
import 'package:provider/provider.dart';

class GoalNameSection extends StatelessWidget {
  const GoalNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();
    return GoalNameInputField(
      controller: viewModel.goalNameController,
      errorText: viewModel.goalNameError,
    );
  }
}
