import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/usecases/user/update_nickname.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/onboarding/onboarding2_screen.dart';

@LazySingleton()
class OnboardingViewModel extends ChangeNotifier {
  final UpdateNickNameUseCase updateNickNameUseCase;
  bool initialized = false;

  String nickname = '';
  String? nicknameError; // 추가: 닉네임 에러 상태
  
  // 추가: 텍스트 컨트롤러를 ViewModel에 두어 재생성 문제 방지
  final TextEditingController nicknameController = TextEditingController();

  OnboardingViewModel({
    required this.updateNickNameUseCase,
  });

  Future<void> initialize(BuildContext context) async {
    if (initialized) return;
    initialized = true;
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Onboarding2Page(), // userId 전달
      ),
    );
  }

  Future<void> saveNickname() async {
    try {
      await updateNickNameUseCase(nickname);
    } catch (e) {
      throw Exception('닉네임 업데이트에 실패했습니다: ${e.toString()}');
    }
  }
  
  // 닉네임 검증 후 에러 설정 메서드
  void validateNickname(BuildContext context) async {
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      // 에러 발생 시 스낵바 처리 (위젯 단에서 처리해도 됨)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임 저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  void setCurrentPage(int page) {
    // 페이지 변경 시 처리 로직
    notifyListeners();
  }
}
