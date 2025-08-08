import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/usecases/user/update_nickname.dart';

@injectable
class OnboardingViewModel extends ChangeNotifier {
  final UpdateNickNameUseCase updateNickNameUseCase;
  bool initialized = false;
  bool _isDisposed = false;
  int _step = 1;
  int get step => _step;

  String nickname = '';
  String? nicknameError;
  final TextEditingController nicknameController = TextEditingController();

  OnboardingViewModel({required this.updateNickNameUseCase});

  Future<void> initialize({required VoidCallback onNext}) async {
    if (initialized) return;
    initialized = true;
    await Future.delayed(const Duration(seconds: 3));
    onNext();
  }

  set step(int value) {
    _step = value;
    notifyListeners();
    _handleAutoStepProgress();
  }

  void startAutoProgress() {
    _handleAutoStepProgress();
  }

  void _handleAutoStepProgress() {
    if (_step == 1 || _step == 2) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_step == 1) {
          step = 2;
        } else if (_step == 2) {
          step = 3;
        }
      });
    }
  }

  void setNickname(String nickname) {
    this.nickname = nickname;
    nicknameController.text = nickname;
    notifyListeners();
  }

  Future<void> saveNickname() async {
    try {
      await updateNickNameUseCase(nickname);
    } catch (e) {
      throw Exception('닉네임 업데이트에 실패했습니다: ${e.toString()}');
    }
  }

  // 닉네임 검증 후 에러 설정 메서드
  Future<void> validateNickname({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final text = nicknameController.text.trim();
    if (text.isEmpty) {
      nicknameError = '닉네임을 입력해주세요.';
      notifyListeners();
      return;
    } else if (text.length > 8) {
      nicknameError = '닉네임은 8자 이내로 입력해주세요.';
      notifyListeners();
      return;
    }
    nicknameError = null;
    nickname = text;
    notifyListeners();

    try {
      await saveNickname();
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  void setCurrentPage(int page) {
    // 페이지 변경 시 처리 로직
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
