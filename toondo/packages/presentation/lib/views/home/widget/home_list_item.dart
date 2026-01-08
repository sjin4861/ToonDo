import 'dart:io';
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
    
    // TODO: 메인화면에서 투두/목표 구분 표시 문제 수정
    // TODO: 기존 문제: 투두 섹션에서 goalToUse?.name을 우선 표시하여 투두 대신 목표 이름이 보임
    // TODO: 해결: 투두가 있으면 투두 제목, 목표가 있으면 목표 이름을 명확히 구분
    final String title = todo?.title ?? goal?.name ?? '';
    
    // 메인화면 투두 리스트 표시 규칙 개선 - 날짜 표시 및 우선순위 정보 추가
    // TODO: 투두와 목표의 날짜 표시 로직 구분
    // 투두인 경우: 투두의 시작일~종료일 사용
    // TODO: 투두/목표 구분 날짜 표시 개선 완료
    // TODO: 투두: startDate/endDate 사용 (실제 날짜)
    // TODO: 목표: startDate/endDate 사용
    final DateTime actualStart = todo?.startDate ?? goal?.startDate ?? DateTime.now();
    final DateTime? actualEnd = todo?.endDate ?? goal?.endDate;
    
    final String dateRange = actualEnd != null
        ? '${DateFormat('yy.MM.dd').format(actualStart)} ~ ${DateFormat('yy.MM.dd').format(actualEnd)}'
        : '${DateFormat('yy.MM.dd').format(actualStart)} ~ 무제한';
    
    // D-Day 계산도 실제 아이템(투두 또는 목표)의 종료일 기준으로 계산
    final String? dDay = actualEnd != null 
        ? () {
            final calculatedDDay = calculateDDay(actualEnd);
            return calculatedDDay >= 0 ? '· D-$calculatedDDay' : '· D-Day';
          }() 
        : null;
    
    // eisenhower 매트릭스 기반 우선순위 표시 기능
    final int priority = todo?.eisenhower ?? 3; // 0=긴급중요, 1=중요비긴급, 2=긴급비중요, 3=비긴급비중요
    final Color priorityColor = _getPriorityColor(priority);
    final String priorityLabel = _getPriorityLabel(priority);
    
    // 진행률 표시 (투두만 해당)
    final double progress = todo?.status ?? 0.0;

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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.body2Bold.copyWith(
                            color: AppColors.status100,
                            height: 1.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // TODO: 투두/목표 구분 표시 개선 완료
                      // TODO: 우선순위 배지는 투두인 경우에만 표시 (목표는 우선순위 개념이 없음)
                      // TODO: 투두: eisenhower 매트릭스 기반 우선순위 배지 표시
                      // TODO: 목표: 우선순위 배지 표시하지 않음
                      if (todo != null) ...[
                        SizedBox(width: AppSpacing.h8),
                        _buildPriorityBadge(priorityColor, priorityLabel),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSpacing.v4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dDay != null ? '$dateRange $dDay' : dateRange,
                          style: AppTypography.caption3Regular.copyWith(
                            color: AppColors.status100_50,
                            height: 1.0,
                          ),
                        ),
                      ),
                      if (todo != null) ...[
                        SizedBox(width: AppSpacing.h8),
                        Text(
                          '${progress.toInt()}%',
                          style: AppTypography.caption3Bold.copyWith(
                            color: progress >= 100 ? AppColors.green300 : AppColors.status100_75,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ],
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
    // TODO: 투두와 목표의 아이콘 표시 로직 개선
    // 투두인 경우: 연결된 목표의 아이콘을 표시하되, 배경색은 투두의 우선순위 색상
    // 목표인 경우: 목표의 아이콘을 표시하고 목표 스타일 적용
    final bool isTodo = todo != null;
    final Color backgroundColor = isTodo 
        ? getBorderColor(todo!) 
        : (goalToUse != null ? Colors.transparent : AppColors.borderLight);
    final Color? borderColor = !isTodo && goalToUse != null ? AppColors.green300 : null;

    final dynamic icon = goalToUse?.icon ?? goal?.icon;
    final bool isCustomIcon = icon is String && icon.startsWith('/');
    
    return Container(
      width: AppDimensions.iconSize24,
      height: AppDimensions.iconSize24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: isCustomIcon
          ? _buildIconFromPath(icon)
          : Padding(
              padding: EdgeInsets.all(AppSpacing.a4),
              child: FittedBox(
                fit: BoxFit.contain,
                child: _buildIconFromPath(icon),
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
      // 커스텀 아이콘인지 확인 (파일 경로인 경우)
      if (icon.startsWith('/')) {
        return ClipOval(
          child: Image.file(
            File(icon),
            width: AppDimensions.iconSize24,
            height: AppDimensions.iconSize24,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.help_outline_rounded, size: 20);
            },
          ),
        );
      }
      return Image.asset(icon, width: 24, height: 24, fit: BoxFit.contain);
    }
    return const Icon(Icons.help_outline_rounded, size: 20);
  }

  Goal? _findGoalById(String? id) {
    if (id == null || allGoals == null) {
      // TODO: 메인화면 투두 아이콘 표시 문제 해결 완료
      // TODO: 이전 문제: allGoals가 null이어서 goalId로 Goal을 찾지 못해 아이콘이 표시되지 않음
      // TODO: 해결: HomeTodoListSection에서 allGoals를 전달받아 HomeListItem에 전달하도록 수정
      // TODO: 결과: 투두의 goalId에 해당하는 Goal의 아이콘이 정상적으로 표시됨
      print('⚠️ allGoals가 null이거나 goalId가 null입니다. id: $id, allGoals: ${allGoals?.length}');
      return null;
    }
    try {
      return allGoals!.firstWhere((g) => g.id == id);
    } catch (_) {
      print('⚠️ goalId로 Goal을 찾을 수 없습니다: $id');
      return null;
    }
  }

  /// eisenhower 매트릭스 기반 우선순위 색상 반환
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 0: // 낮음
        return AppColors.status100_25;
      case 1: // 중요
        return AppColors.yellow300;
      case 2: // 급함
        return AppColors.blue300;
      case 3: // 긴급
      default:
        return AppColors.red300;
    }
  }

  /// eisenhower 매트릭스 기반 우선순위 라벨 반환
  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 0:
        return '낮음';
      case 1:
        return '중요';
      case 2:
        return '급함';
      case 3:
        return '긴급';
      default:
        return '낮음';
    }
  }

  /// 우선순위 배지 위젯 빌드
  Widget _buildPriorityBadge(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h6,
        vertical: AppSpacing.v4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTypography.caption3Bold.copyWith(
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}
