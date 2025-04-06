import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_title.dart';
import 'package:presentation/widgets/my_page/account_setting/nickname_change/nickname_change_button.dart';
import 'package:presentation/widgets/my_page/account_setting/nickname_change/nickname_change_text_fields.dart';

class NicknameChangeScreen extends StatelessWidget {
  const NicknameChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: CustomAppBar(title: '닉네임 변경'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            AccountChangeTitle(value: '닉네임'),
            SizedBox(height: 28),
            NicknameChangeTextFields(exNickname: '드리머즈'), // TODO : 뷰모델에서 값 받아와야함
            Spacer(),
            NicknameChangeButton(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
