import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_button/green_button.dart';

class PasswordChangeButton extends GreenButton {
  const PasswordChangeButton({
    super.key,
    super.title = '변경하기',
    super.onPressed = _defaultAction,
  });

  // TODO: ViewModel과 연결 후 교체
  static void _defaultAction() {
    debugPrint('[비밀번호 변경] 버튼 눌림 - TODO: ViewModel 연결 예정');
  }
}
