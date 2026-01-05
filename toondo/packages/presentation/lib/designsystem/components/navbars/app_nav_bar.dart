import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showBackButton;

  const AppNavBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.status0,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              padding: EdgeInsets.only(left: AppSpacing.h20),
              icon: Icon(
                Icons.arrow_back_ios,
                size: AppDimensions.iconSize16,
                color: AppColors.status100,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      centerTitle: false,
      titleSpacing: showBackButton ? 0 : AppSpacing.h24,
      title: Text(
        title,
        style: AppTypography.h2Regular.copyWith(
          color: AppColors.status100,
          height: 1.0,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(
          color: AppColors.dividerLight,
          height: 0.5.h,
          thickness: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}
