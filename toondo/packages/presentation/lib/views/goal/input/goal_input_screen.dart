import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'goal_input_scaffold.dart';

class GoalInputScreen extends StatelessWidget {
  final Goal? goal;

  const GoalInputScreen({super.key, this.goal});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalInputViewModel>(
      create: (_) => GoalInputViewModel(
        createGoalRemoteUseCase: GetIt.instance<CreateGoalRemoteUseCase>(),
        saveGoalLocalUseCase: GetIt.instance<SaveGoalLocalUseCase>(),
        updateGoalRemoteUseCase: GetIt.instance<UpdateGoalRemoteUseCase>(),
        updateGoalLocalUseCase: GetIt.instance<UpdateGoalLocalUseCase>(),
        targetGoal: goal,
      ),
      child: const GoalInputScaffold(),
    );
  }
}