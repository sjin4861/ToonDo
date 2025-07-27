import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/models/eisenhower_model.dart';

class AppEisenhowerSelector extends StatelessWidget {
  final EisenhowerType selectedType;
  final ValueChanged<EisenhowerType> onChanged;

  const AppEisenhowerSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: eisenhowerOptions.map((option) {
        final isSelected = option.type == selectedType;

        return GestureDetector(
          onTap: () => onChanged(option.type),
          child: SizedBox(
            width: AppDimensions.eisenhowerButtonWidth,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: isSelected ? option.bgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                border: Border.all(
                  color: isSelected
                      ? option.borderColor
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    option.iconPath,
                    width: AppDimensions.eisenhowerIconSize,
                    height: AppDimensions.eisenhowerIconSize,
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                          option.selectedColor,
                          BlendMode.srcIn,
                        )
                        : ColorFilter.mode(
                      AppColors.eisenhowerUnselectedContent,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTypography.caption3Bold.copyWith(color: option.selectedColor)
                        : AppTypography.caption3Regular.copyWith(color: option.unselectedColor),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
