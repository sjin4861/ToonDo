import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

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
            height: 40,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F0D9),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius24),
            ),
            child: Row(
              children: [
                _buildIcon(
                  selectedItem.iconPath,
                  isSelected: true,
                  fallbackIcon: Icons.help_outline,
                ),
                SizedBox(width: AppSpacing.spacing16),
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
                  color: const Color(0xFF1C1D1B),
                ),
              ],
            ),
          ),
        ),

        // ▼ Dropdown
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.spacing8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: List.generate(items.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFDDDDDD),
                  );
                } else {
                  final item = items[index ~/ 2];
                  final isSelected = item.id.toString() == selectedId;

                  return GestureDetector(
                    onTap: () => onItemSelected(item.id),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 40,
                        color:
                        isSelected
                            ? const Color(0x80E4F0DA) // 선택 항목 배경
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing12,
                        ),
                        child: Row(
                            children: [
                            _buildIcon(item.iconPath, isSelected: isSelected),
                        const SizedBox(width: AppSpacing.spacing16),
                        Expanded(
                          child: Text(
                            item.title,
                            style:
                            isSelected
                                ? AppTypography.body2Medium.copyWith(
                              color: AppColors.status100,
                            )
                                : AppTypography.body2Regular.copyWith(
                              color: AppColors.status100,
                            ),
                          ),
                        ),
                      ],),
                    ),
                  ),);
              }
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon(String? iconPath, {
    required bool isSelected,
    IconData fallbackIcon = Icons.help_outline,
  }) {
    Widget iconWidget;
    if (iconPath != null && iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        width: AppDimensions.iconSize16,
        height: AppDimensions.iconSize16,
      );
    } else {
      iconWidget = Icon(
        fallbackIcon,
        size: AppDimensions.iconSize16,
        color: Colors.white,
      );
    }

    return Container(
      width: AppDimensions.iconSize24,
      height: AppDimensions.iconSize24,
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color:
        isSelected
            ? const Color(0x7FAED28F) // 선택됨
            : const Color(0x7FDDDDDD), // 비선택
        shape: BoxShape.circle,
      ),
      child: iconWidget,
    );
  }
}
