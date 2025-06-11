import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:presentation/widgets/text_fields/goal_name_input_field.dart';
import 'package:presentation/widgets/goal/input/goal_input_date_field.dart';
import 'package:presentation/widgets/text_fields/tip.dart';

class GoalInputBody extends StatelessWidget {
  const GoalInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SingleChildScrollView(
        child: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalNameInputField(
                controller: viewModel.goalNameController,
                errorText: viewModel.goalNameError,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GoalInputDateField(
                      viewModel: viewModel,
                      label: '시작일',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GoalInputDateField(
                      viewModel: viewModel,
                      label: '마감일',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TipWidget(
                title: 'TIP',
                description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
