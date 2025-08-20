import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/views/home/widget/home_list_item.dart';

class HomeGoalListSection extends StatelessWidget {
  final List<Goal> goals;

  const HomeGoalListSection({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.spacing32),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '설정된 목표가 없습니다. 목표를 추가해보세요!',
            style: AppTypography.h3Regular.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children:
            goals.map((goal) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.spacing12,
                ),
                child: HomeListItem(
                  goal: goal,
                  onTap: () {
                    // todo Handle goal item tap
                  },
                ),
              );
            }).toList(),
      ),
    );
  }
}
