import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_title.dart';
import 'package:presentation/widgets/my_page/account_setting/nickname_change/nickname_change_button.dart';
import 'package:presentation/widgets/my_page/account_setting/nickname_change/nickname_change_text_fields.dart';
import 'package:provider/provider.dart';

class NicknameChangeScreen extends StatelessWidget {
  const NicknameChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AccountSettingViewModel>();
    final nickname = viewModel.userUiModel?.nickname ?? '';
    final nicknameController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: '닉네임 변경'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const AccountChangeTitle(value: '닉네임'),
            const SizedBox(height: 28),
            NicknameChangeTextFields(
              exNickname: nickname,
              controller: nicknameController,
            ),
            const Spacer(),
            NicknameChangeButton(controller: nicknameController),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

