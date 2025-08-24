import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final radius = BorderRadius.circular(AppDimensions.borderRadius8);

    return Wrap(
      spacing: AppSpacing.h22,
      runSpacing: AppSpacing.v16,
      children: eisenhowerOptions.map((option) {
        final bool isSelected = option.type == selectedType;

        return SizedBox(
          width: AppDimensions.eisenhowerButtonWidth,
          child: Semantics(
            button: true,
            selected: isSelected,
            label: option.label,
            onTapHint: '${option.label} 선택',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: radius,
                onTap: () => onChanged(option.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.all(AppSpacing.a4),
                  decoration: BoxDecoration(
                    color: isSelected ? option.bgColor : Colors.transparent,
                    borderRadius: radius,
                    border: Border.all(
                      color: isSelected ? option.borderColor : Colors.transparent,
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        option.iconPath,
                        width: AppDimensions.eisenhowerIconSize,
                        height: AppDimensions.eisenhowerIconSize,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? option.selectedColor
                              : AppColors.eisenhowerUnselectedContent,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: AppSpacing.v4),
                      Text(
                        option.label,
                        textAlign: TextAlign.center,
                        style: (isSelected
                            ? AppTypography.caption3Bold
                            : AppTypography.caption3Regular)
                            .copyWith(
                          color: isSelected
                              ? option.selectedColor
                              : option.unselectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
