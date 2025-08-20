import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';

class SyncBottomSheet extends StatelessWidget {
  const SyncBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MyPageViewModel>();

    return AppBottomSheet(
      fixedHeight: AppDimensions.goalEditBottomSheetHeight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: AppSpacing.spacing32),
          _buildLoadButton(context, viewModel),
          SizedBox(height: AppSpacing.spacing16),
          _buildSaveButton(context, viewModel),
          SizedBox(height: AppSpacing.spacing44),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '동기화 하기',
      style: AppTypography.h1Bold.copyWith(
        color: AppColors.status100,
      ),
    );
  }

  /// 불러오기 버튼 (fetchTodoOnly)
  Widget _buildLoadButton(BuildContext context, MyPageViewModel viewModel) {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () async {
          await viewModel.fetchTodoOnly();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing40,
            vertical: AppSpacing.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius20),
          ),
        ),
        child: Text(
          '불러오기',
          style: AppTypography.h2Bold.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  /// 저장하기 버튼 (commitTodoOnly)
  Widget _buildSaveButton(BuildContext context, MyPageViewModel viewModel) {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton(
        onPressed: () async {
          await viewModel.commitTodoOnly();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing40,
            vertical: AppSpacing.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius20),
          ),
          side: const BorderSide(color: AppColors.green500),
        ),
        child: Text(
          '저장하기',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
      ),
    );
  }
}
