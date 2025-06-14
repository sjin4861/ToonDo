import 'package:flutter/material.dart';
import 'package:presentation/widgets/text_fields/tip.dart';

class GoalTipSection extends StatelessWidget {
  const GoalTipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TipWidget(
      title: 'TIP',
      description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
    );
  }
}
