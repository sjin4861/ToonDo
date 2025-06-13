import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:provider/provider.dart';

class GoalInputHeaderSection extends StatelessWidget {
  const GoalInputHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GoalInputViewModel>();
    final isEditing = viewModel.targetGoal != null;

    final title = isEditing ? '목표를 발전시켜봐요' : '목표를 정해주세요!';
    const subtitle = '앞으로 투둡와 함께 달려 나갈 목표를 입력해주세요.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF78B545),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
            height: 1.5,
            fontFamily: 'Pretendard Variable',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
            height: 1.5,
            fontFamily: 'Pretendard Variable',
          ),
        ),
      ],
    );
  }
}
