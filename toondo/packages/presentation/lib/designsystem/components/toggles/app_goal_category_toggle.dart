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
              right: index == labels.length - 1 ? 0 : AppSpacing.spacing8,
            ),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing8,
                ),
                height: AppDimensions.goalCategoryToggleHeight,
                constraints: BoxConstraints(
                  minWidth: AppDimensions.goalCategoryToggleWidth,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.green100 : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                    color: const Color(0x401D1B40),
                    width: 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style:
                      isSelected
                          ? AppTypography.body3Bold.copyWith(
                            color: AppColors.status100,
                          )
                          : AppTypography.body3Regular.copyWith(
                            color: const Color(0xFF7F7F7F),
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
