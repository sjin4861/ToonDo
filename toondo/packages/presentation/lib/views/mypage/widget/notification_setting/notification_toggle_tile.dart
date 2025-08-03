import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/toggles/app_toggle_switch.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class NotificationToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.spacing14, 0, AppSpacing.spacing14 + AppSpacing.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.body1Regular.copyWith(
            color: AppColors.status100
          )),
          AppToggleSwitch(value: value, onChanged: onChanged ?? (_) {}),
        ],
      ),
    );
  }
}
