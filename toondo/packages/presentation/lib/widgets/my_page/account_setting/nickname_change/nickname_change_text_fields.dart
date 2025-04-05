import 'package:flutter/material.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_text_field.dart';

class NicknameChangeTextFields extends StatelessWidget {
  final String exNickname;

  const NicknameChangeTextFields({super.key, required this.exNickname});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountChangeTextField(
          label: '기존 닉네임',
          enabled: false,
          initialValue: exNickname,
        ),
        const SizedBox(height: 24),
        AccountChangeTextField(
          label: '신규 닉네임',
          controller: TextEditingController(),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
