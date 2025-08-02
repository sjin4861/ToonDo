import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/models/my_page_user_ui_model.dart';
import 'package:presentation/utils/profile_utils.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';
import 'package:common/gen/assets.gen.dart';

class MyPageProfileSection extends StatelessWidget {
  const MyPageProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final userUiModel = context.watch<MyPageViewModel>().userUiModel;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 프로필 이미지 렌더링
        _buildProfileImage(userUiModel),
        const SizedBox(width: AppSpacing.spacing24),
        // 사용자 이름 및 사용 일 수 정보
        _buildProfileInfo(userUiModel),
      ],
    );
  }

  /// 사용자 가입 일 수에 따라 다른 프로필 이미지를 표시하는 위젯
  Widget _buildProfileImage(MyPageUserUiModel? userUiModel) {
    final joinedDays = int.tryParse(userUiModel?.joinedDaysText ?? '0') ?? 0;
    final imageAsset = getProfileImageAssetByJoinedDays(joinedDays);

    return SizedBox(
      width: AppDimensions.profileImageSize,
      height: AppDimensions.profileImageSize,
      child: ClipOval(child: Image.asset(imageAsset, fit: BoxFit.cover)),
    );
  }

  /// 사용자 이름과 ToonDo 사용일 정보를 표시하는 텍스트 정보 위젯
  Widget _buildProfileInfo(MyPageUserUiModel? userUiModel) {
    final joinedDaysText = userUiModel?.joinedDaysText ?? '0';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.spacing16),
        Text(
          userUiModel?.displayName ?? '이름 없음',
          style: AppTypography.h2SemiBold.copyWith(color: Colors.black, height: 1.0),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'ToonDo',
                style: AppTypography.caption1SemiBold.copyWith(
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: '와 함께한 지 ',
                style: AppTypography.caption1Regular.copyWith(
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: '$joinedDaysText',
                style: AppTypography.caption1Regular.copyWith(
                  color: AppColors.green500,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: '일째',
                style: AppTypography.caption1Regular.copyWith(
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.spacing38),
      ],
    );
  }
}
