import 'dart:io';
import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/components/icons/app_circle_file_icon.dart';

class GoalDropdownItem {
  final int id;
  final String? iconPath;
  final String title;

  const GoalDropdownItem({
    required this.id,
    required this.iconPath,
    required this.title,
  });
}

class AppGoalDropdown extends StatelessWidget {
  final List<GoalDropdownItem> items;
  final String? selectedId;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<int> onItemSelected;

  const AppGoalDropdown({
    super.key,
    required this.items,
    required this.selectedId,
    required this.isExpanded,
    required this.onToggle,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere(
          (item) => item.id.toString() == selectedId,
      orElse: () => GoalDropdownItem(
        id: -1,
        title: '목표를 선택하세요.',
        iconPath: Assets.icons.icHelpCircle.path,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ▼ Top selected item
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F0D9),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Row(
              children: [
                _buildIcon(
                  selectedItem.iconPath,
                  isSelected: true,
                  fallbackIcon: Icons.help_outline,
                ),
                SizedBox(width: AppSpacing.h16),
                Expanded(
                  child: Text(
                    selectedItem.title,
                    style: AppTypography.body2Regular.copyWith(
                      color: AppColors.status100,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.status100,
                ),
              ],
            ),
          ),
        ),

        // ▼ Dropdown
        if (isExpanded)
          Container(
            margin: EdgeInsets.only(top: AppSpacing.v8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderUnselected, width: 1.w),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: List.generate(items.length * 2 - 1, (rawIndex) {
                if (rawIndex.isOdd) {
                  return Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: AppColors.borderUnselected,
                  );
                }

                final index = rawIndex ~/ 2;
                final item = items[index];
                final isSelected = item.id.toString() == selectedId;

                final isFirst = index == 0;
                final isLast  = index == items.length - 1;

                final BorderRadius rowRadius = (items.length == 1)
                    ? BorderRadius.circular(AppDimensions.radiusPill)
                    : isFirst
                    ? BorderRadius.vertical(
                  top: Radius.circular(24.r),
                )
                    : isLast
                    ? BorderRadius.vertical(
                  bottom: Radius.circular(24.r),
                )
                    : BorderRadius.zero;

                return GestureDetector(
                  onTap: () => onItemSelected(item.id),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.myPageBorder.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: rowRadius,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h12),
                    child: Row(
                      children: [
                        _buildIcon(item.iconPath, isSelected: isSelected),
                        SizedBox(width: AppSpacing.h16),
                        Expanded(
                          child: Text(
                            item.title,
                            style: (isSelected
                                ? AppTypography.body2Medium
                                : AppTypography.body2Regular)
                                .copyWith(color: AppColors.status100),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon(
      String? iconPath, {
        required bool isSelected,
        IconData fallbackIcon = Icons.help_outline,
      }) {
    final Widget iconWidget;
    
    if (iconPath == null) {
      iconWidget = Icon(
        fallbackIcon,
        size: AppDimensions.iconSize16,
        color: Colors.white,
      );
    } else if (iconPath.endsWith('.svg')) {
      // SVG Asset 경로
      iconWidget = SvgPicture.asset(
        iconPath,
        width: AppDimensions.iconSize16,
        height: AppDimensions.iconSize16,
      );
    } else if (iconPath.startsWith('/')) {
      // 커스텀 아이콘 (파일 시스템 경로) - CircleAvatar backgroundImage 사용
      iconWidget = const SizedBox.shrink(); // 실제 아이콘은 CircleAvatar에서 처리
    } else {
      // 일반 Asset 경로 (PNG, JPG 등)
      iconWidget = Image.asset(
        iconPath,
        width: AppDimensions.iconSize16,
        height: AppDimensions.iconSize16,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            fallbackIcon,
            size: AppDimensions.iconSize16,
            color: Colors.white,
          );
        },
      );
    }

    // 커스텀 아이콘은 정수 픽셀 사용 (ScreenUtil 미사용)
    final bool isCustomIcon = iconPath != null && iconPath.startsWith('/');
    
    // 아이콘 크기는 정수 픽셀로 고정 (반픽셀 문제 방지)
    const double iconContainerSize = 24.0; // 정수 픽셀
    const double iconPadding = 4.0; // 정수 픽셀 (SVG/Asset 아이콘용)
    
    if (isCustomIcon) {
      // 커스텀 아이콘은 패딩 없이 원형 컨테이너를 꽉 채움
      // Container의 clipBehavior와 ClipOval 조합으로 완전히 채움
      return ClipOval(
        child: SizedBox(
          width: iconContainerSize,
          height: iconContainerSize,
          child: Image.file(
            File(iconPath!),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0x7FAED28F)
                      : AppColors.borderUnselected.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  fallbackIcon,
                  size: 16.0, // 정수 픽셀
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      );
    }
    
    // SVG/Asset 아이콘은 기존 방식 유지 (ScreenUtil 사용)
    return Container(
      width: AppDimensions.iconSize24,
      height: AppDimensions.iconSize24,
      padding: EdgeInsets.all(AppSpacing.a4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0x7FAED28F)
            : AppColors.borderUnselected.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: iconWidget,
    );
  }
}
