import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppTipText extends StatelessWidget {
  final String title;
  final String description;

  const AppTipText({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.caption1Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(width: AppSpacing.h14),
        Expanded(
          child: Text(
            description,
            style: AppTypography.caption1Regular.copyWith(color: AppColors.status100_75,),
          ),
        ),
      ],
    );
  }
}
