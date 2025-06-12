import 'package:flutter/material.dart';
import 'package:presentation/views/goal/manage/goal_manage_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';

class GoalManageScreen extends StatelessWidget {
  const GoalManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalManagementViewModel>.value(
      value: GetIt.instance<GoalManagementViewModel>(),
      child: const GoalManageScaffold(),
    );
  }
}
