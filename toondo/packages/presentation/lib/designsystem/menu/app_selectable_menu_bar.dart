import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';

class AppSelectableMenuBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppSelectableMenuBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.menuBarHeight,
      width: AppDimensions.menuBarWidth,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green200),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          final isFirst = index == 0;
          final isLast = index == labels.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                height: AppDimensions.menuBarHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.green500 : Colors.transparent,
                  borderRadius:
                      isSelected
                          ? BorderRadius.circular(AppDimensions.radiusPill)
                          : BorderRadius.only(
                            topLeft:
                                isFirst
                                    ? Radius.circular(AppDimensions.radiusPill)
                                    : Radius.zero,
                            bottomLeft:
                                isFirst
                                    ? Radius.circular(AppDimensions.radiusPill)
                                    : Radius.zero,
                            topRight:
                                isLast
                                    ? Radius.circular(AppDimensions.radiusPill)
                                    : Radius.zero,
                            bottomRight:
                                isLast
                                    ? Radius.circular(AppDimensions.radiusPill)
                                    : Radius.zero,
                          ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    labels[index],
                    style:
                        isSelected
                            ? AppTypography.body1Bold.copyWith(
                              color: AppColors.status0,
                            )
                            : AppTypography.h3Regular.copyWith(
                              color: AppColors.status100.withOpacity(0.8),
                            ),
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
