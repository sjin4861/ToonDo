import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:presentation/widgets/goal/input/goal_setting_bottom_sheet.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'goal_input_body.dart';

class GoalInputScaffold extends StatelessWidget {
  const GoalInputScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: CustomAppBar(
        title: viewModel.targetGoal != null ? '목표 수정하기' : '목표 설정하기',
      ),
      body: const GoalInputBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: CustomButton(
          text: '작성하기',
          onPressed: () async {
            final newGoal = await viewModel.saveGoal(context);
            if (newGoal != null) {
              Navigator.pop(context, newGoal);
              GetIt.instance<HomeViewModel>().loadGoals();
              GetIt.instance<GoalManagementViewModel>().loadGoals();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (_) => GoalSettingBottomSheet(goal: newGoal),
              );
            }
          },
          backgroundColor: const Color(0xFF78B545),
          textColor: const Color(0xFFFCFCFC),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.24,
          padding: 16.0,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}