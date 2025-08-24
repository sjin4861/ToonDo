import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppGoalCategoryToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppGoalCategoryToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;

          return Padding(
            padding: EdgeInsets.only(
              right: index == labels.length - 1 ? 0 : AppSpacing.h8,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.h8),
                  height: AppDimensions.goalCategoryToggleHeight,
                  constraints: BoxConstraints(
                    minWidth: AppDimensions.goalCategoryToggleWidth,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.green100 : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    labels[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (isSelected ? AppTypography.body3Bold : AppTypography.body3Regular).copyWith(
                      color: isSelected ? AppColors.status100 : AppColors.bottomIconColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
