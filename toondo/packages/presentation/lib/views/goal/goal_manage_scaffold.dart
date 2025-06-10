import 'package:flutter/material.dart';
import 'package:presentation/views/goal/goal_manage_body.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/goal/manage/goal_manage_button.dart';

class GoalManageScaffold extends StatelessWidget {
  const GoalManageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: '목표 관리하기'),
      body: const GoalManageBody(),
      bottomNavigationBar: const GoalManageButton(),
    );
  }
}
