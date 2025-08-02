import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';
import 'package:presentation/widgets/my_page/sync_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'my_page_setting_tile.dart';

class MyPageSettingSection extends StatelessWidget {
  const MyPageSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MyPageViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '설정',
          style: AppTypography.h2SemiBold.copyWith(color: AppColors.status100),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        MyPageSettingTile(
          title: '동기화',
          leadingIcon: Assets.icons.icSync.svg(
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const SyncBottomSheet(),
            );
          },
        ),
        MyPageSettingTile(
          title: '화면',
          leadingIcon: Assets.icons.icDisplay.svg(
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSize16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.displaySetting);
          },
        ),
        MyPageSettingTile(
          title: '소리/알림',
          leadingIcon: Assets.icons.icNotification.svg(
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSize16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.notificationSetting);
          },
        ),
        MyPageSettingTile(
          title: '계정관리',
          leadingIcon: Assets.icons.icAccount.svg(
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSize16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.accountSetting);
          },
        ),
        MyPageSettingTile(
          title: '이용안내',
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSize16,
            color: Color(0xFFD9D9D9),
          ),
          leadingIcon: Assets.icons.icNotificationCircle.svg(
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.helpGuide);
          },
        ),
      ],
    );
  }
}
