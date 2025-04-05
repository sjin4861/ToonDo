import 'package:flutter/material.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_text_field.dart';
import 'package:presentation/widgets/my_page/account_setting/phone_number_change/carrier_select_bottom_sheet.dart';

class PhoneNumberTextFields extends StatelessWidget {
  final bool isVerifiedStage;
  final TextEditingController carrierController;
  final TextEditingController phoneNumberController;
  final TextEditingController? codeController;

  const PhoneNumberTextFields({
    super.key,
    required this.isVerifiedStage,
    required this.carrierController,
    required this.phoneNumberController,
    this.codeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return CarrierSelectBottomSheet(
                  onSelected: (carrier) {
                    carrierController.text = carrier;
                  },
                );
              },
            );
          },
          child: AccountChangeTextField(
            label: '통신사',
            hintText: 'KT',
            controller: carrierController,
            enabled: false,
          ),
        ),
        const SizedBox(height: 24),
        AccountChangeTextField(
          label: '전화번호',
          hintText: '',
          keyboardType: TextInputType.phone,
          controller: phoneNumberController,
        ),
        const SizedBox(height: 24),
        if (!isVerifiedStage && codeController != null)
          AccountChangeTextField(
            label: '인증번호',
            hintText: '숫자 6자리 입력',
            keyboardType: TextInputType.number,
            controller: codeController,
          ),
      ],
    );
  }
}
