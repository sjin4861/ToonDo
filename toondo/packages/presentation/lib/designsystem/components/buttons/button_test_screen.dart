import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_google_login_button.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/buttons/app_kakao_login_button.dart';
import 'package:presentation/designsystem/components/buttons/app_phone_login_button.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/views/home/home_screen.dart';

import 'app_button.dart';

class ButtonTestScreen extends StatelessWidget {
  const ButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'Auth Button Test',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '📌 구글 로그인 버튼 테스트',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppGoogleLoginButton(
              onPressed: () {
                debugPrint('구글 버튼 클릭됨');
              },
            ),
            const SizedBox(height: 24),

            const Text(
              '📌카카오 로그인 버튼 테스트',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppKakaoLoginButton(
              onPressed: () {
                debugPrint('구글 버튼 클릭됨');
              },
            ),
            const SizedBox(height: 24),

            const Text(
              '📌 번호 로그인 버튼',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppPhoneLoginButton(
              onPressed: () {
                debugPrint('번호 로그인 버튼 클릭됨');
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '📌 small 버튼',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: '다음',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              size: AppButtonSize.small,
            ),
            const SizedBox(height: 16),
            const Text(
              '📌 medium 버튼',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: '다음으로',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              size: AppButtonSize.medium,
            ),
            const SizedBox(height: 16),
            const Text(
              '📌 large 버튼',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: '다음으로',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              size: AppButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }
}
