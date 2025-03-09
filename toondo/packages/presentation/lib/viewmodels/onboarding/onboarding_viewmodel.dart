import 'package:domain/usecases/user/update_nickname.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class OnboardingViewModel extends ChangeNotifier {
  String nickname = '';
  int userId;
  int currentPage = 0;
  final UpdateNickNameUseCase updateNickNameUseCase;

  OnboardingViewModel({
    required this.userId,
    required this.updateNickNameUseCase,
  });

  Future<void> saveNickname() async {
    try {
      await updateNickNameUseCase(nickname);
    } catch (e) {
      // 에러 처리
      throw Exception('닉네임 업데이트에 실패했습니다: ${e.toString()}');
    }
  }

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }
}
