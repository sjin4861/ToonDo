import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_button/green_button.dart';

class NicknameChangeButton extends GreenButton {
  const NicknameChangeButton({
    super.key,
    super.title = '변경하기',
    super.onPressed = _defaultAction,
  });

  static void _defaultAction() {
    // TODO: ViewModel과 연결 후 교체
    debugPrint('[닉네임 변경] 버튼 눌림 - 구현 예정');
  }
}
