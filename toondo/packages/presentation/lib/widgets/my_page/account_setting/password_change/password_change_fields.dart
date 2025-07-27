import 'package:flutter/material.dart';
import 'package:presentation/widgets/my_page/account_setting/account_password_field.dart';

class PasswordChangeTextFields extends StatelessWidget {
  final TextEditingController newController;
  final TextEditingController confirmController;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const PasswordChangeTextFields({
    super.key,
    required this.newController,
    required this.confirmController,
    this.newPasswordError,
    this.confirmPasswordError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountPasswordField(
          label: '새로운 비밀번호',
          controller: newController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          errorText: newPasswordError,
        ),
        const SizedBox(height: 24),
        AccountPasswordField(
          label: '새로운 비밀번호 확인',
          controller: confirmController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          errorText: confirmPasswordError,
        ),
      ],
    );
  }
}
