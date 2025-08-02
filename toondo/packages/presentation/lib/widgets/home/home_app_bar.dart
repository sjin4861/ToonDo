import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'ToonDo',
        style: AppTypography.h3SemiBold.copyWith(
          color: AppColors.status100,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.spacing16),
          child: IconButton(
            onPressed: () {
              // TODO 추후 상점 화면 이동
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => ()),
              // );
            },
            icon: Assets.icons.icStore.svg(width: AppDimensions.iconCircleSize, height: AppDimensions.iconCircleSize),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
