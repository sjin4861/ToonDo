import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_title.dart';
import 'package:presentation/widgets/my_page/account_setting/password_change/password_change_button.dart';
import 'package:presentation/widgets/my_page/account_setting/password_change/password_change_fields.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // TODO: 뷰모델 연결 후 에러 메시지, 상태 처리 예정
    final String? currentPasswordError = null;
    final String? newPasswordError = '기존 비밀번호는 사용할 수 없습니다.';
    final String? confirmPasswordError = '비밀번호가 일치하지 않습니다.';

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: const CustomAppBar(title: '비밀번호 변경'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const AccountChangeTitle(value: '비밀번호'),
            const SizedBox(height: 28),
            PasswordChangeTextFields(
              currentController: currentPasswordController,
              newController: newPasswordController,
              confirmController: confirmPasswordController,
              // currentPasswordError: currentPasswordError,
              // newPasswordError: newPasswordError,
              // confirmPasswordError: confirmPasswordError,
            ),
            const Spacer(),
            const PasswordChangeButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
