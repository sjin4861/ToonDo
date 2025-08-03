import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';


class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const AppNavBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.status0,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing24, vertical: AppSpacing.spacing14),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: AppDimensions.iconSize16, color: AppColors.status100),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          title,
          style: AppTypography.h2Regular.copyWith(
            color: AppColors.status100,
            height: 1.0,
          ),
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(
          color: Color(0x3F1C1D1B),
          height: 0.5,
          thickness: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}