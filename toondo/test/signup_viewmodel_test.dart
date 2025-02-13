import 'package:flutter_test/flutter_test.dart';
import 'package:toondo/viewmodels/auth/signup_viewmodel.dart';

// Fake 버전을 통해 AuthService의 등록 여부 체크를 오버라이드합니다.
class FakeSignupViewModel extends SignupViewModel {
  final bool isRegistered;
  FakeSignupViewModel({required this.isRegistered});
  
  @override
  Future<bool> checkIfRegistered() async {
    return isRegistered;
  }
}

void main() {
  group('SignupViewModel', () {
    test('등록된 전화번호인 경우 로그인 화면으로 이동', () async {
      bool navigatedToLogin = false;
      final viewModel = FakeSignupViewModel(isRegistered: true);
      viewModel.setNavigateToLogin(() {
        navigatedToLogin = true;
      });
      viewModel.setPhoneNumber('01012345678');
      await viewModel.validatePhoneNumber();
      
      expect(navigatedToLogin, true);
      // 전화번호가 등록된 경우 에러 또는 다음 단계가 실행되지 않아 currentStep은 변하지 않습니다.
    });

    test('등록되지 않은 전화번호인 경우 다음 단계로 진행', () async {
      bool navigatedToLogin = false;
      final viewModel = FakeSignupViewModel(isRegistered: false);
      viewModel.setNavigateToLogin(() {
        navigatedToLogin = true;
      });
      viewModel.setPhoneNumber('01098765432');
      await viewModel.validatePhoneNumber();
      
      expect(navigatedToLogin, false);
      expect(viewModel.currentStep, 2); // nextStep() 호출됨
      expect(viewModel.phoneError, isNull);
    });

    test('유효하지 않은 전화번호 형식 처리', () async {
      bool navigatedToLogin = false;
      final viewModel = FakeSignupViewModel(isRegistered: false);
      viewModel.setNavigateToLogin(() {
        navigatedToLogin = true;
      });
      viewModel.setPhoneNumber('abc');
      await viewModel.validatePhoneNumber();
      
      expect(navigatedToLogin, false);
      expect(viewModel.phoneError, isNotNull);
    });
  });
}
