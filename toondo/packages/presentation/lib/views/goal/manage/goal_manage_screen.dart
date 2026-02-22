import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/views/goal/manage/goal_manage_body.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';

class GoalManageScreen extends StatefulWidget {
  const GoalManageScreen({super.key});

  @override
  State<GoalManageScreen> createState() => _GoalManageScreenState();
}

class _GoalManageScreenState extends State<GoalManageScreen> {
  late final GoalManagementViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<GoalManagementViewModel>();
    _viewModel.loadGoals();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalManagementViewModel>.value(
      value: _viewModel,
      child: BaseScaffold(
        title: '목표',
        body: Align(alignment: Alignment.topCenter, child: GoalManageBody()),
        bottomWidget: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h24,
              vertical: AppSpacing.v8,
            ),
            child: AppButton(
              label: '목표 추가하기',
              onPressed: () async {
                final result = await Navigator.push<Goal?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoalInputScreen(
                      goalManagementViewModel: _viewModel,
                    ),
                  ),
                );

                if (result != null) {
                  await _viewModel.upsertGoalAndRefresh(result);
                } else {
                  await _viewModel.loadGoals();
                }

                await GetIt.instance<HomeViewModel>().loadGoals();
              },
            ),
          ),
        ),
      ),
    );
  }
}
