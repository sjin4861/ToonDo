import 'package:flutter/material.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_profile_section.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_tile.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO : 하드코딩 된 부분 뷰모델 연결 후 상태로 대체
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: const CustomAppBar(title: '계정관리'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AccountSettingProfileSection(),
            const SizedBox(height: 40),
            AccountSettingTile(
              label: '닉네임',
              value: '드리머즈',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.accountSettingNicknameChange,
                );
              },
            ),
            AccountSettingTile(
              label: '비밀번호',
              value: 'happyhappy202',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.accountSettingPasswordChange,
                );
              },
            ),
            AccountSettingTile(
              label: '전화번호',
              value: '010-0000-0000',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.accountSettingPhoneChange,
                );
              },
            ),
            AccountSettingTile(label: '계정탈퇴'),
          ],
        ),
      ),
    );
  }
}
