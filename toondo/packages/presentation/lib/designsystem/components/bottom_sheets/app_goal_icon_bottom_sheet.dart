import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppGoalIconBottomSheet extends StatelessWidget {
  final Map<String, List<String>> iconCategories;
  final void Function(String iconPath) onIconSelected;

  const AppGoalIconBottomSheet({
    super.key,
    required this.iconCategories,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.goalIconBottomSheetHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.status0,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.bottomSheetTopRadius),
          topRight: Radius.circular(AppDimensions.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.spacing16),
          Container(
            width: AppDimensions.bottomSheetHandleWidth,
            height: AppDimensions.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.borderUnselected,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingBottomSheetTop),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: iconCategories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: AppTypography.caption1Regular.copyWith(
                            color: AppColors.status100,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing8),
                        Wrap(
                          spacing: AppSpacing.spacing16,
                          runSpacing: AppSpacing.spacing16,
                          children: entry.value.map((iconPath) {
                            return GestureDetector(
                              onTap: () => onIconSelected(iconPath),
                              child: Container(
                                width: AppDimensions.iconCircleSize,
                                height: AppDimensions.iconCircleSize,
                                padding: const EdgeInsets.all(AppSpacing.spacing8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.borderDisabled,
                                    width: 1,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  iconPath,
                                  width: AppDimensions.iconSize24,
                                  height: AppDimensions.iconSize24,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
