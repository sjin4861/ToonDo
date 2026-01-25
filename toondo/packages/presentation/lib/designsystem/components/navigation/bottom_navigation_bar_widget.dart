import 'package:common/gen/assets.gen.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
import 'package:presentation/views/goal/manage/goal_manage_screen.dart';
import 'package:presentation/views/mypage/my_page_screen.dart';
import 'package:presentation/views/todo/input/todo_input_screen.dart';
import 'package:presentation/views/todo/manage/todo_manage_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackOn = context.select<AppNotificationViewModel, bool>(
      (vm) => vm.settings.all && vm.settings.sound,
    );
    return BottomAppBar(
      // ScreenUtil(.h) 스케일링으로 특정 기기에서 지나치게 작아지면
      // 아이콘+라벨이 들어갈 공간이 부족해 RenderFlex overflow가 발생할 수 있어 최소 높이를 보장합니다.
      // (Material 내부 패딩까지 고려해 64px를 하한으로 둡니다)
      height: math.max(AppDimensions.bottomNavBarHeight, 64.0),
      color: AppColors.status0,
      elevation: 2.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // (1) 투두 리스트
          _buildNavButton(
            context,
            feedbackOn: feedbackOn,
            label: '투두리스트',
            iconPath: Assets.icons.icBottomTodo.path,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoManageScreen()),
              );
            },
          ),

          // (2) 목표 관리
          _buildNavButton(
            context,
            feedbackOn: feedbackOn,
            label: '목표관리',
            iconPath: Assets.icons.icBottomGoal.path,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalManageScreen()),
              );
            },
          ),

          // (3) 투두 추가
          _buildNavButton(
            context,
            feedbackOn: feedbackOn,
            label: '투두추가',
            iconPath: Assets.icons.icBottomAdd.path,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoInputScreen()),
              );
            },
          ),

          // (4) 마이페이지
          _buildNavButton(
            context,
            feedbackOn: feedbackOn,
            label: '마이페이지',
            iconPath: Assets.icons.icBottomUser.path,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyPageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String iconPath,
    String? label,
    required VoidCallback onTap,
    required bool feedbackOn,
  }) {
    return InkWell(
      enableFeedback: feedbackOn,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          SvgPicture.asset(
            iconPath,
            width: AppDimensions.iconSize24,
            height: AppDimensions.iconSize24,
            colorFilter: const ColorFilter.mode(
              AppColors.bottomIconColor,
              BlendMode.srcIn,
            ),
          ),
          // 일부 디바이스/스케일에서 BottomAppBar 내부 제약 높이가 작아
          // icon(24) + spacing + label이 1~2px 오버플로우가 발생할 수 있어 간격을 최소화합니다.
          const SizedBox(height: 2),
          if (label != null)
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption3Regular.copyWith(
                color: AppColors.bottomIconColor,
                height: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}
