import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/views/mypage/account_setting/nickname_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/password_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/phone_number_change_screen.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_profile_section.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_tile.dart';
import 'package:provider/provider.dart';

class AccountSettingScaffold extends StatelessWidget {
  const AccountSettingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AccountSettingViewModel>();

    final isLoading = viewModel.isLoading;
    final user = viewModel.userUiModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: '계정관리'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    const SizedBox(height: 40),
                    const AccountSettingProfileSection(),
                    const SizedBox(height: 40),
                    AccountSettingTile(
                      label: '닉네임',
                      value: user?.nickname ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
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
                            builder: (_) => ChangeNotifierProvider.value(
                              value: viewModel, // 기존 ViewModel 그대로 전달
                              child: PasswordChangeScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    AccountSettingTile(
                      label: '전화번호',
                      value: user?.phoneNumber ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: viewModel, // 기존 ViewModel 그대로 전달
                              child: PhoneNumberChangeScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    const AccountSettingTile(label: '계정탈퇴'),
                  ],
                ),
      ),
    );
  }
}
