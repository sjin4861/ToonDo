import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/views/goal/goal_input_view.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:provider/provider.dart';

class GoalManageButton extends StatelessWidget {
  const GoalManageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: CustomButton(
        text: '목표 추가하기',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GoalInputView(),
            ),
          ).then((_) {
            final viewModel = Provider.of<GoalManagementViewModel>(context, listen: false);
            viewModel.loadGoals();
            GetIt.instance<HomeViewModel>().loadGoals();
          });
        },
        backgroundColor: const Color(0xFF78B545),
        textColor: const Color(0xFFFCFCFC),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.24,
      ),
    );
  }
}
