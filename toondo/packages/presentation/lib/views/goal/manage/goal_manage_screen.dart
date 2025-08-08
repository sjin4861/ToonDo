import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/views/goal/manage/goal_manage_body.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';

class GoalManageScreen extends StatelessWidget {
  const GoalManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalManagementViewModel>.value(
      value: GetIt.instance<GoalManagementViewModel>(),
      child: BaseScaffold(
        title: '목표',
        body: Align(alignment: Alignment.topCenter, child: GoalManageBody()),
        bottomWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing24,
              vertical: AppSpacing.spacing8,
            ),
            child: AppButton(
              label: '목표 추가하기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoalInputScreen(),
                  ),
                ).then((_) {
                  final viewModel = Provider.of<GoalManagementViewModel>(
                    context,
                    listen: false,
                  );
                  viewModel.loadGoals();
                  GetIt.instance<HomeViewModel>().loadGoals();
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
