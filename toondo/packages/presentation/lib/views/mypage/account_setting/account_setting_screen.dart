import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_profile_section.dart';
import 'package:presentation/widgets/my_page/account_setting/account_setting_tile.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: CustomAppBar(title: '계정관리'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 40),
            AccountSettingProfileSection(),
            SizedBox(height: 40),
            AccountSettingTile(label: '닉네임', value: '드리머즈'),
            AccountSettingTile(label: '비밀번호', value: 'happyhappy202'),
            AccountSettingTile(label: '전화번호', value: '010-0000-0000'),
            AccountSettingTile(label: '계정탈퇴'),
          ],
        ),
      ),
    );
  }
}
