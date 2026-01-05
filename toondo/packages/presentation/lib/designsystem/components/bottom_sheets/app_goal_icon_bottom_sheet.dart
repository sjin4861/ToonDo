import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/goal/goal_icon_bottom_sheet_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class AppGoalIconBottomSheet extends StatelessWidget {
  final Map<String, List<String>> iconCategories;
  final void Function(String iconPath) onIconSelected;

  const AppGoalIconBottomSheet({
    super.key,
    required this.iconCategories,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalIconBottomSheetViewModel>(
      create: (_) => GetIt.instance<GoalIconBottomSheetViewModel>(),
      child: Consumer<GoalIconBottomSheetViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            height: AppDimensions.goalIconBottomSheetHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.status0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.bottomSheetTopRadius),
                topRight: Radius.circular(AppDimensions.bottomSheetTopRadius),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.v16),
                Container(
                  width: AppDimensions.bottomSheetHandleWidth,
                  height: AppDimensions.bottomSheetHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.borderUnselected,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingBottomSheetTop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 커스텀 아이콘 섹션
                        _buildCustomIconSection(context, viewModel),
                        // 기존 카테고리 아이콘들
                        ...iconCategories.entries.map((entry) {
                          return _buildCategorySection(entry.key, entry.value);
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomIconSection(
    BuildContext context,
    GoalIconBottomSheetViewModel viewModel,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.v16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '커스텀',
            style: AppTypography.caption1Regular.copyWith(
              color: AppColors.status100,
            ),
          ),
          SizedBox(height: AppSpacing.v8),
          Wrap(
            spacing: AppSpacing.h14,
            runSpacing: AppSpacing.v16,
            children: [
              // + 버튼 (가장 왼쪽)
              _buildAddIconButton(context, viewModel),
              // 기존 커스텀 아이콘들
              ...viewModel.customIconPaths.map((iconPath) {
                return _buildCustomIconItem(context, viewModel, iconPath);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddIconButton(
    BuildContext context,
    GoalIconBottomSheetViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () async {
        final bottomSheetContext = context;
        final savedPath = await viewModel.pickImageFromGallery(context);

        if (savedPath != null) {
          if (bottomSheetContext.mounted) {
            Navigator.of(bottomSheetContext).pop(savedPath);
          }
        } else if (viewModel.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.errorMessage!)),
          );
        }
      },
      child: Container(
        width: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
        height: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderDisabled,
            width: 1.0, // 정수 픽셀
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.green500,
          size: 24.0, // 정수 픽셀
        ),
      ),
    );
  }

  Widget _buildCustomIconItem(
    BuildContext context,
    GoalIconBottomSheetViewModel viewModel,
    String iconPath,
  ) {
    return GestureDetector(
      onTap: () async {
        await viewModel.updateLastUsed(iconPath);
        // 선택된 아이콘 전달 (이 콜백에서 Navigator.pop이 호출됨)
        onIconSelected(iconPath);
      },
      onLongPress: () {
        _showDeleteDialog(context, viewModel, iconPath);
      },
      child: Container(
        width: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
        height: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderDisabled,
            width: 1.0, // 정수 픽셀
          ),
        ),
        clipBehavior: Clip.antiAlias,
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
                  size: 24.0, // 정수 픽셀
                  color: AppColors.status100,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    GoalIconBottomSheetViewModel viewModel,
    String iconPath,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius10),
          ),
          title: Text(
            '아이콘 삭제',
            style: AppTypography.h2Bold.copyWith(
              color: AppColors.status100,
            ),
          ),
          content: Text(
            '이 커스텀 아이콘을 삭제하시겠습니까?',
            style: AppTypography.body2Regular.copyWith(
              color: AppColors.status100,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                '취소',
                style: AppTypography.body2Regular.copyWith(
                  color: AppColors.status100_50,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await viewModel.deleteCustomIcon(iconPath);
                if (context.mounted && viewModel.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage!)),
                  );
                }
              },
              child: Text(
                '삭제',
                style: AppTypography.body2Bold.copyWith(
                  color: const Color(0xFFEE0F12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(String categoryName, List<String> iconPaths) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.v16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: AppTypography.caption1Regular.copyWith(
              color: AppColors.status100,
            ),
          ),
          SizedBox(height: AppSpacing.v8),
          Wrap(
            spacing: AppSpacing.h14,
            runSpacing: AppSpacing.v16,
            children: iconPaths.map((iconPath) {
              return GestureDetector(
                onTap: () {
                  // 선택된 아이콘 전달 (이 콜백에서 Navigator.pop이 호출됨)
                  onIconSelected(iconPath);
                },
                child: Container(
                  width: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
                  height: 40.0, // 정수 픽셀 (ScreenUtil 미사용)
                  padding: EdgeInsets.all(8.0), // 정수 픽셀
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.borderDisabled,
                      width: 1.0, // 정수 픽셀
                    ),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24.0, // 정수 픽셀
                    height: 24.0, // 정수 픽셀
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
