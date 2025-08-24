import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/utils/get_todo_border_color.dart';
import 'package:presentation/utils/goal_utils.dart';

class HomeListItem extends StatelessWidget {
  final Goal? goal;
  final Todo? todo;
  final List<Goal>? allGoals;
  final VoidCallback? onTap;

  const HomeListItem({
    super.key,
    this.goal,
    this.todo,
    this.allGoals,
    this.onTap,
  }) : assert(goal != null || todo != null, 'goal 또는 todo 중 하나는 반드시 있어야 합니다');

  @override
  Widget build(BuildContext context) {
    final goalToUse = goal ?? _findGoalById(todo?.goalId);
    final String title = goalToUse?.name ?? todo?.title ?? '';
    final DateTime start = goalToUse?.startDate ?? todo?.startDate ?? DateTime.now();
    final DateTime end = goalToUse?.endDate ?? todo?.endDate ?? DateTime.now();

    final String dateRange =
        '${DateFormat('yy.MM.dd').format(start)} ~ ${DateFormat('yy.MM.dd').format(end)}';
    final String? dDay = goalToUse != null ? '· D-${calculateDDay(end)}' : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.homeItemHeight,
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
        decoration: BoxDecoration(
          color: AppColors.backgroundNormal,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        child: Row(
          children: [
            _buildIcon(goalToUse),
            SizedBox(width: AppSpacing.h12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body2Bold.copyWith(
                      color: AppColors.status100,
                      height: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.v4),
                  Text(
                    dDay != null ? '$dateRange $dDay' : dateRange,
                    style: AppTypography.caption3Regular.copyWith(
                      color: AppColors.status100_50,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Goal? goalToUse) {
    final Color backgroundColor =
    goalToUse != null ? Colors.transparent : getBorderColor(todo!);
    final Color? borderColor = goalToUse != null ? AppColors.green300 : null;

    return Container(
      width: AppDimensions.iconSize24,
      height: AppDimensions.iconSize24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.a4),
        child: FittedBox(
          fit: BoxFit.contain,
          child: _buildIconFromPath(goalToUse?.icon),
        ),
      ),
    );
  }

  Widget _buildIconFromPath(dynamic icon) {
    if (icon is SvgGenImage) return icon.svg(width: 24, height: 24, fit: BoxFit.contain);
    if (icon is AssetGenImage) return icon.image(width: 24, height: 24, fit: BoxFit.contain);
    if (icon is String && icon.endsWith('.svg')) {
      return SvgPicture.asset(icon, width: 24, height: 24, fit: BoxFit.contain);
    }
    if (icon is String) {
      return Image.asset(icon, width: 24, height: 24, fit: BoxFit.contain);
    }
    return const Icon(Icons.help_outline_rounded, size: 20);
  }

  Goal? _findGoalById(String? id) {
    if (id == null || allGoals == null) return null;
    try {
      return allGoals!.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
