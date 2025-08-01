import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/goal/input/goal_input_body.dart';
import 'package:provider/provider.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart'; // 이게 필요하다면 import
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart'; // 이것도 필요
import 'package:presentation/widgets/goal/input/goal_setting_bottom_sheet.dart'; // 추가로 이 위젯도 필요

class GoalInputScreen extends StatelessWidget {
  final Goal? goal;
  final bool isFromOnboarding;

  const GoalInputScreen({super.key, this.goal, this.isFromOnboarding = false});

  @override
  Widget build(BuildContext context) {
    final String title =
    isFromOnboarding ? '시작하기' : (goal != null ? '목표 수정하기' : '목표 설정하기');

    return ChangeNotifierProvider<GoalInputViewModel>(
      create: (_) => GoalInputViewModel(
        createGoalRemoteUseCase: GetIt.instance<CreateGoalRemoteUseCase>(),
        saveGoalLocalUseCase: GetIt.instance<SaveGoalLocalUseCase>(),
        updateGoalRemoteUseCase: GetIt.instance<UpdateGoalRemoteUseCase>(),
        updateGoalLocalUseCase: GetIt.instance<UpdateGoalLocalUseCase>(),
        targetGoal: goal,
        isFromOnboarding: isFromOnboarding,
      ),
      child: Builder(
        builder: (context) {
          final viewModel = context.read<GoalInputViewModel>();

          return BaseScaffold(
            title: title,
            body: const GoalInputBody(),
            bottomWidget: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing24, vertical: AppSpacing.spacing8),
                child: AppButton(
                  label: '작성하기',
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
