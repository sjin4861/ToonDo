import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/widgets/bottom_button/green_button.dart';
import 'package:provider/provider.dart';

class NicknameChangeButton extends StatelessWidget {
  final TextEditingController controller;

  const NicknameChangeButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AccountSettingViewModel>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        backgroundColor: const Color(0xFF76B852),
      ),
      onPressed: () async {
        final success = await viewModel.updateNickname(controller.text);
        if (success && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: const Text('변경하기'),
    );
  }
}

