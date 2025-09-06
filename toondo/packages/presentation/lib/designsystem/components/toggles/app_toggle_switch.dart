import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class AppToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.radiusPill);

    return Semantics(
      button: true,
      toggled: value,
      onTapHint: value ? '스위치 끄기' : '스위치 켜기',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: AppDimensions.toggleWidth,
            height: AppDimensions.toggleHeight,
            padding: EdgeInsets.all(AppSpacing.a4),
            decoration: BoxDecoration(
              color: value ? AppColors.green500 : AppColors.brown100,
              borderRadius: radius,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: AppDimensions.toggleThumbSize,
                height: AppDimensions.toggleThumbSize,
                decoration: const BoxDecoration(
                  color: AppColors.status0,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
