import 'package:flutter/material.dart';
import 'package:presentation/views/todo/todo_manage_body.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/todo/common/bottom_spacer.dart';

class TodoManageScaffold extends StatelessWidget {
  const TodoManageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: '투두리스트'),
      body: const TodoManageBody(),
      bottomNavigationBar: const BottomSpacer(),
    );
  }
}
