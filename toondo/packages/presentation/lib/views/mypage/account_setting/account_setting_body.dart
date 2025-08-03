import 'package:flutter/material.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/models/my_page_user_ui_model.dart';
import 'package:presentation/utils/profile_utils.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/views/mypage/account_setting/nickname_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/password_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/delete_account_screen.dart';
import 'package:presentation/views/mypage/widget/account_setting/account_setting_tile.dart';
import 'package:provider/provider.dart';

class AccountSettingBody extends StatelessWidget {
  const AccountSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AccountSettingViewModel>();
    final userUiModel = viewModel.userUiModel;

    final isLoading = viewModel.isLoading;
    final user = viewModel.userUiModel;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            const SizedBox(height: AppSpacing.spacing48),
            _buildProfileImage(userUiModel),
            const SizedBox(height: AppSpacing.spacing24),
            AccountSettingTile(
              label: '닉네임',
              value: user?.displayName ?? '',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: const NicknameChangeScreen(),
                        ),
                  ),
                );
              },
            ),
            AccountSettingTile(
              label: '비밀번호',
              value: '변경하기',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider.value(
                          value: viewModel, // 기존 ViewModel 그대로 전달
                          child: PasswordChangeScreen(),
                        ),
                  ),
                );
              },
            ),
            AccountSettingTile(
              label: '계정탈퇴',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeleteAccountScreen(),
                  ),
                );
              },
            ),
          ],
        );
  }

  Widget _buildProfileImage(MyPageUserUiModel? userUiModel) {
    final joinedDays = int.tryParse(userUiModel?.joinedDaysText ?? '0') ?? 0;
    final imageAsset = getProfileImageAssetByJoinedDays(joinedDays);

    return SizedBox(
      width: AppDimensions.profileImageSize,
      height: AppDimensions.profileImageSize,
      child: ClipOval(child: Image.asset(imageAsset, fit: BoxFit.cover)),
    );
  }
}
