import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppGoalItem extends StatefulWidget {
  final Key dismissKey;
  final String title;
  final String? iconPath;
  final String? subTitle;
  final bool isChecked;
  final Color backgroundColor;
  final ValueChanged<bool>? onCheckedChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AppGoalItem({
    super.key,
    required this.dismissKey,
    required this.title,
    this.iconPath,
    this.subTitle,
    this.isChecked = false,
    this.backgroundColor = AppColors.backgroundNormal,
    this.onCheckedChanged,
    this.onTap,
    this.onDelete,
  });

  @override
  State<AppGoalItem> createState() => _AppGoalItemState();
}

class _AppGoalItemState extends State<AppGoalItem> {
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
        if (mounted) setState(() => _dragOffset = 0.0);
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
    final radius = BorderRadius.circular(AppDimensions.goalItemBorderRadius.r);

    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDrag = constraints.maxWidth;

        return SizedBox(
          height: AppDimensions.goalItemHeight.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.green500,
                    borderRadius: radius,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.h12),
                  child: Center(
                    child: GestureDetector(
                      onTap: _handleDelete,
                      child: Container(
                        width: 312.w,
                        height: AppDimensions.goalItemHeight.h,
                        decoration: BoxDecoration(
                          color: AppColors.green500,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusPill.r),
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
                      onTap: () {
                        setState(() => _dragOffset = 0.0);
                        widget.onTap?.call();
                      },
                      borderRadius: radius,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.h12,
                          AppSpacing.v12,
                          AppSpacing.h16,
                          AppSpacing.v12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          border: Border.all(
                            color: widget.isChecked
                                ? AppColors.itemCompletedBorder
                                : AppColors.green300,
                            width: AppDimensions.goalItemBorderWidth.w,
                          ),
                          color: widget.isChecked
                              ? AppColors.itemCompletedBackground
                              : widget.backgroundColor,
                        ),
                        child: Row(
                          children: [
                            _buildIcon(),
                            SizedBox(width: AppSpacing.h12),
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
    final Color borderColor = widget.isChecked
        ? AppColors.itemCompletedBorder.withAlpha(127) // withOpacity(0.5)
        : AppColors.green300;

    final String? iconPath = widget.iconPath ?? Assets.icons.icHelpCircle.path;
    final bool isCustomIcon = iconPath != null && iconPath.startsWith('/');

    // 아이콘 크기는 정수 픽셀로 고정 (반픽셀 문제 방지)
    const double iconSize = 24.0; // 정수 픽셀
    const double innerPadding = 4.0; // 정수 픽셀

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundNormal,
        border: Border.all(
          color: borderColor,
          width: 1.0, // 정수 픽셀
        ),
      ),
      clipBehavior: Clip.antiAlias,
      padding: isCustomIcon ? EdgeInsets.zero : EdgeInsets.all(innerPadding),
      child: isCustomIcon
          ? ClipOval(
              child: SizedBox.expand(
                child: Image.file(
                  File(iconPath!),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.help_outline_rounded,
                      size: iconSize,
                      color: widget.isChecked ? AppColors.status100_50 : AppColors.status100,
                    );
                  },
                ),
              ),
            )
          : SvgPicture.asset(
              iconPath!,
              width: iconSize - innerPadding * 2,
              height: iconSize - innerPadding * 2,
              colorFilter: ColorFilter.mode(
                widget.isChecked ? AppColors.status100_50 : AppColors.status100,
                BlendMode.srcIn,
              ),
            ),
    );
  }

  Widget _buildTitleWithOptionalSubtitle() {
    if (widget.subTitle == null || widget.subTitle!.isEmpty) {
      return Text(
        widget.title,
        style: AppTypography.body2Bold.copyWith(
          color: widget.isChecked
              ? AppColors.status100.withOpacity(0.3)
              : AppColors.status100,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: AppTypography.body2Bold.copyWith(
            color: widget.isChecked
                ? AppColors.status100.withOpacity(0.3)
                : AppColors.status100,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSpacing.v4),
        Text(
          widget.subTitle!,
          style: AppTypography.caption3Regular.copyWith(
            color: widget.isChecked
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
      width: AppDimensions.checkboxSize.w,
      height: AppDimensions.checkboxSize.h,
      child: Checkbox(
        value: widget.isChecked,
        onChanged: (value) {
          if (value != null) widget.onCheckedChanged?.call(value);
        },
        side: BorderSide(
          color: AppColors.borderLight,
          width: AppDimensions.checkboxBorderWidth.w,
        ),
        activeColor: AppColors.itemCompletedBorder,
        checkColor: AppColors.status0,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
