import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppTodoItem extends StatefulWidget {
  final String title;
  final String? iconPath;
  final String? subTitle;
  final bool isChecked;
  final Color levelColor;
  final ValueChanged<bool>? onCheckedChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AppTodoItem({
    super.key,
    required this.title,
    this.iconPath,
    this.subTitle,
    this.isChecked = false,
    this.levelColor = AppColors.eisenhowerSelectedBg1,
    this.onCheckedChanged,
    this.onTap,
    this.onDelete,
  });

  @override
  State<AppTodoItem> createState() => _AppTodoItemState();
}

class _AppTodoItemState extends State<AppTodoItem> {
  double _dragOffset = 0.0;
  double _maxDrag = 120.0;
  Timer? _resetTimer;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _resetTimer?.cancel();

    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-_maxDrag, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_maxDrag * 0.8) {
      setState(() {
        _dragOffset = -_maxDrag;
      });
      _resetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _dragOffset = 0.0);
        }
      });
    } else {
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  void _handleDelete() {
    _resetTimer?.cancel();
    widget.onDelete?.call();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.todoItemBorderRadius);

    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDrag = constraints.maxWidth;

        return SizedBox(
          height: AppDimensions.todoItemHeight,
          child: Stack(
            children: [
              // 전체 배경
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.todoItemBorderRadius,
                  ),
                  child: Container(
                    color: AppColors.green500,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h12,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _handleDelete,
                        child: Container(
                          width: 312.w,
                          height: AppDimensions.todoItemHeight,
                          decoration: BoxDecoration(
                            color: AppColors.green500,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.delete, color: AppColors.status0),
                              Text(
                                '삭제하기',
                                style: AppTypography.body1Bold.copyWith(
                                  color: AppColors.status0,
                                ),
                              ),
                              SizedBox(width: AppSpacing.h24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 카드
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _dragOffset,
                right: -_dragOffset,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: radius,
                      child: Container(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingTodoItem,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          border: Border.all(
                            color:
                                widget.isChecked
                                    ? AppColors.itemCompletedBorder
                                    : widget.levelColor,
                            width: AppDimensions.todoItemBorderWidth,
                          ),
                          color:
                              widget.isChecked
                                  ? AppColors.itemCompletedBackground
                                  : AppColors.backgroundNormal,
                        ),
                        child: Row(
                          children: [
                            _buildIcon(),
                            SizedBox(width: AppSpacing.h12),
                            // TODO: RenderFlex overflow 추가 대안 - Expanded를 Flexible로 변경하여 flex 조정
                            // TODO: 현재 Expanded는 남은 공간을 모두 차지하지만 내용이 overflow될 수 있음
                            Expanded(child: _buildTitleWithOptionalSubtitle()),
                            SizedBox(width: AppSpacing.h12),
                            _buildCheckbox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    final backgroundColor =
        widget.isChecked ? AppColors.itemCompletedBorder : widget.levelColor;

    return CircleAvatar(
      radius: AppDimensions.goalIconRadius,
      backgroundColor: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.goalIconInnerPadding),
        child: SvgPicture.asset(
          widget.iconPath ?? Assets.icons.icHelpCircle.path,
          width: AppDimensions.goalIconSize,
          height: AppDimensions.goalIconSize,
          colorFilter: ColorFilter.mode(
            widget.isChecked ? AppColors.status100_50 : AppColors.status100,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWithOptionalSubtitle() {
    if (widget.subTitle == null || widget.subTitle!.isEmpty) {
      return Text(
        widget.title,
        style: AppTypography.body2Bold.copyWith(
          color:
              widget.isChecked
                  ? AppColors.status100.withOpacity(0.3)
                  : AppColors.status100,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // TODO: RenderFlex overflow 버그 수정 - 디데이 투두에서 0.653 pixels 오버플로우 발생
    // TODO: 문제 원인: 고정된 todoItemHeight 내에서 title + subtitle + spacing이 공간을 초과
    // TODO: 해결 방안 1: Column을 Flexible 또는 Expanded로 감싸기
    // TODO: 해결 방안 2: MainAxisSize.min 대신 MainAxisAlignment.center 사용
    // TODO: 해결 방안 3: SizedBox(height: 2)를 1로 축소 (적용됨)
    // TODO: 해결 방안 4: 폰트 크기나 라인 높이 조정
    // TODO: 해결 방안 5: todoItemHeight 값 증가 고려
    // TODO: 추가 해결: MainAxisAlignment.center로 수직 중앙 정렬하여 공간 부족 문제 완화
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬 추가
      children: [
        Text(
          widget.title,
          style: AppTypography.body2Bold.copyWith(
            color:
                widget.isChecked
                    ? AppColors.status100.withOpacity(0.3)
                    : AppColors.status100,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1), // TODO: RenderFlex overflow 수정 - 2에서 1로 줄임 (0.653 pixels 절약)
        Text(
          widget.subTitle!,
          style: AppTypography.caption3Regular.copyWith(
            color:
                widget.isChecked
                    ? AppColors.status100.withOpacity(0.3)
                    : AppColors.status100.withOpacity(0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return SizedBox(
      width: AppDimensions.checkboxSize,
      height: AppDimensions.checkboxSize,
      child: Checkbox(
        value: widget.isChecked,
        onChanged: (value) {
          if (value != null) widget.onCheckedChanged?.call(value);
        },
        side: BorderSide(
          color: AppColors.borderLight,
          width: AppDimensions.checkboxBorderWidth,
        ),
        activeColor: AppColors.itemCompletedBorder,
        checkColor: AppColors.status0,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
