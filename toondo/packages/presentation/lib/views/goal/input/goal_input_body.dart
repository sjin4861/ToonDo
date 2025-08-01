import 'package:flutter/material.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/goal/input/goal_date_selection_section.dart';
import 'package:presentation/widgets/goal/input/goal_input_header_section.dart';
import 'package:presentation/widgets/goal/input/goal_name_section.dart';
import 'package:presentation/widgets/goal/input/goal_tip_section.dart';
import 'package:provider/provider.dart';

class GoalInputBody extends StatelessWidget {
  const GoalInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();

    return  SingleChildScrollView(
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: AppSpacing.spacing48),
              GoalInputHeaderSection(),
              SizedBox(height: AppSpacing.spacing40),
              GoalNameSection(),
              SizedBox(height: AppSpacing.spacing24),
              GoalDateSelectionSection(),
              SizedBox(height: AppSpacing.spacing18),
              GoalTipSection(),
            ],
          ),
      ),
    );
  }
}
