import 'dart:io';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_goal_icon_bottom_sheet.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_goal_icon_categories.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalNameInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const GoalNameInputField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  State<GoalNameInputField> createState() => _GoalNameInputFieldState();
}

class _GoalNameInputFieldState extends State<GoalNameInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표 이름',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        Row(
          children: [
            // 아이콘 선택 버튼
            Consumer<GoalInputViewModel>(
              builder:
                  (context, viewModel, child) => GestureDetector(
                    onTap: () async {
                      // 아이콘 선택 BottomSheet 열기
                      final bottomSheetContext = context;
                      String? selectedIcon = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (bottomSheetBuilderContext) => AppGoalIconBottomSheet(
                          iconCategories: goalIconCategories,
                          onIconSelected: (selectedIcon) {
                            // 바텀시트만 닫기 (상위 화면은 유지)
                            if (bottomSheetBuilderContext.mounted) {
                              Navigator.of(bottomSheetBuilderContext).pop(selectedIcon);
                            }
                          },
                        ),
                      );

                      if (selectedIcon != null) {
                        viewModel.selectIcon(selectedIcon);
                      }
                    },
                    child: Container(
                      width: 40, // 작은 동그라미 크기
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              viewModel.selectedIcon != null
                                  ? AppColors.green500
                                  : AppColors.borderUnselected,
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child:
                          viewModel.selectedIcon != null
                              ? _buildIconWidget(viewModel.selectedIcon!)
                              : Icon(
                                Icons.add,
                                color: AppColors.green500,
                                size: AppDimensions.iconSize16,
                              ),
                    ),
                  ),
            ),
            SizedBox(width: AppSpacing.h8),
            Expanded(
              child: SizedBox(
                height: AppDimensions.inputFieldHeight,
                child: TextFormField(
                  controller: widget.controller,
                  cursorColor: AppColors.green500,
                  style: AppTypography.body2Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  decoration: InputDecoration(
                    hintText: '목표 이름을 입력해주세요.',
                    hintStyle: AppTypography.body2Regular.copyWith(
                      color: AppColors.status100_25,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                      borderSide: BorderSide(
                        width: 1.0,
                        color:
                            widget.controller.text.isNotEmpty
                                ? AppColors.green500
                                : AppColors.borderUnselected,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                      borderSide: BorderSide(
                        color:
                            widget.controller.text.isNotEmpty
                                ? AppColors.green500
                                : AppColors.borderUnselected,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: AppSpacing.v4),
          Text(
            widget.errorText!,
            style: AppTypography.caption1Regular.copyWith(
              color: AppColors.red500,
            ),
          ),
        ],
      ],
    );
  }

  /// 아이콘 경로에 따라 적절한 위젯 반환
  Widget _buildIconWidget(String iconPath) {
    // 아이콘 크기는 정수 픽셀로 고정 (반픽셀 문제 방지)
    const double iconContainerSize = 40.0; // 정수 픽셀
    const double iconPadding = 8.0; // 정수 픽셀
    const double svgIconSize = 24.0; // 정수 픽셀

    // 커스텀 아이콘인지 확인 (파일 시스템 경로)
    if (iconPath.startsWith('/')) {
      return SizedBox(
        width: iconContainerSize,
        height: iconContainerSize,
        child: ClipOval(
          child: SizedBox.expand(
            child: Image.file(
              File(iconPath),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.help_outline_rounded,
                  size: svgIconSize,
                  color: AppColors.status100,
                );
              },
            ),
          ),
        ),
      );
    }
    // SVG 아이콘
    return Container(
      width: iconContainerSize,
      height: iconContainerSize,
      padding: EdgeInsets.all(iconPadding),
      child: SvgPicture.asset(
        iconPath,
        width: svgIconSize,
        height: svgIconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
