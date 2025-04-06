import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_button/green_button.dart';

class PhoneNumberVerifyButton extends GreenButton {
  const PhoneNumberVerifyButton({
    super.key,
    super.title = '인증하기',
    super.onPressed = _defaultAction,
  });

  static void _defaultAction() {
    // TODO: ViewModel과 연결 후 교체
    debugPrint('[전화번호 인증] 버튼 눌림 - 구현 예정');
  }
}
