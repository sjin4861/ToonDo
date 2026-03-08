import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class NicknameChangeBody extends StatelessWidget {
  final TextEditingController controller;
  final String currentNickname;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const NicknameChangeBody({
    super.key,
    required this.controller,
    required this.currentNickname,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v24),
        _buildTitle(),
        SizedBox(height: AppSpacing.v24),
        _buildCurrentNicknameField(currentNickname),
        SizedBox(height: AppSpacing.v24),
        _buildNewNicknameField(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      '닉네임을 입력해주세요',
      style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
    );
  }

  Widget _buildCurrentNicknameField(String currentNickname) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '현재 닉네임',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100.withOpacity(0.4),
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        Container(
          height: AppDimensions.inputFieldHeight,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
          decoration: BoxDecoration(
            color: AppColors.status0,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(
              color: AppColors.status100.withOpacity(0.1),
            ),
          ),
          child: Text(
            currentNickname,
            style: AppTypography.body2Regular.copyWith(
              color: AppColors.status100.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewNicknameField() {
    final baseBorderColor = AppColors.status100.withOpacity(0.2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '새 닉네임',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        SizedBox(
          height: AppDimensions.inputFieldHeight,
          child: TextField(
            controller: controller,
            cursorColor: AppColors.green500,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.name,
            enableSuggestions: false,
            autocorrect: false,
            maxLines: 1,
            style: AppTypography.body2Regular.copyWith(
              color: AppColors.status100,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: '2~10자의 닉네임 입력',
              hintStyle: AppTypography.body2Regular.copyWith(
                color: AppColors.status100.withOpacity(0.2),
              ),
              filled: true,
              fillColor: AppColors.status0,
              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
              enabledBorder: _inputBorder(baseBorderColor),
              focusedBorder: _inputBorder(AppColors.green500),
              errorBorder: _inputBorder(AppColors.red500),
              focusedErrorBorder: _inputBorder(AppColors.red500),
              errorText: errorText,
              errorStyle: AppTypography.caption2Medium.copyWith(
                color: AppColors.red500,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      borderSide: BorderSide(color: color, width: 1.w),
    );
  }
}
