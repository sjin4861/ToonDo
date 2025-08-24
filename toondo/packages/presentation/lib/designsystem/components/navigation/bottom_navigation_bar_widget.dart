import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/views/goal/manage/goal_manage_screen.dart';
import 'package:presentation/views/mypage/my_page_screen.dart';
import 'package:presentation/views/todo/input/todo_input_screen.dart';
import 'package:presentation/views/todo/manage/todo_manage_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: AppDimensions.bottomNavBarHeight,
      color: AppColors.status0,
      elevation: 2.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // (1) 투두 리스트
          _buildNavButton(
            context,
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
      }) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
          SizedBox(height: AppSpacing.v4),
          if (label != null)
            Text(
              label,
              style: AppTypography.caption3Regular.copyWith(
                color: AppColors.bottomIconColor,
              ),
            ),
        ],
      ),
    );
  }
}
