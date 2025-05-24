import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_text_field.dart';
import 'package:provider/provider.dart';

class NicknameChangeTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String exNickname;

  const NicknameChangeTextFields({
    super.key,
    required this.exNickname,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final error = context.watch<AccountSettingViewModel>().nicknameErrorMessage;

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
          controller: controller,
          keyboardType: TextInputType.text,
          errorText: error,
        ),
      ],
    );
  }
}

