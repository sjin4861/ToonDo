import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  String nickname = '';
  String userId;

  OnboardingViewModel({required this.userId});

  Future<void> saveNickname() async {
    final authService = AuthService();

    try {
      await authService.updateUsername(userId, nickname);
    } catch (e) {
      // 에러 처리
      throw Exception('닉네임 업데이트에 실패했습니다: ${e.toString()}');
    }
  }
}