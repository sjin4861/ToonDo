import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_title.dart';
import 'package:presentation/widgets/my_page/account_setting/phone_number_change/phone_number_text_fields.dart';
import 'package:presentation/widgets/my_page/account_setting/phone_number_change/phone_number_verify_button.dart';

class PhoneNumberChangeScreen extends StatelessWidget {
  const PhoneNumberChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 아래 변수 뷰모델 연결 후 상태로 대체
    final isVerifiedStage = true;
    final carrierController = TextEditingController();
    final phoneController = TextEditingController();
    final codeController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: '전화번호 변경'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const AccountChangeTitle(value: '전화번호'),
            const SizedBox(height: 28),
            PhoneNumberTextFields(
              isVerifiedStage: isVerifiedStage,
              carrierController: carrierController,
              phoneNumberController: phoneController,
              codeController: codeController,
            ),
            const Spacer(),
            PhoneNumberVerifyButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
