import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  String nickname = '';

  void saveNickname() {
    // 닉네임을 저장하는 로직 구현 (예: 서버에 저장하거나 로컬에 저장)
    // ...
    notifyListeners();
  }
}