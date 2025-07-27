import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/usecases/auth/login.dart';
import 'package:domain/entities/user.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'login_viewmodel_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(
      loginUseCase: mockLoginUseCase,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('LoginViewModel', () {
    group('초기 상태', () {
      test('초기 상태는 빈 값과 기본 설정을 가져야 한다', () {
        expect(viewModel.loginId, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.isPasswordVisible, false);
        expect(viewModel.passwordError, null);
        expect(viewModel.loginError, null);
      });
    });
    
    group('입력 필드 제어', () {
      test('비밀번호 가시성 토글은 상태를 변경해야 한다', () {
        expect(viewModel.isPasswordVisible, false);
        
        viewModel.togglePasswordVisibility();
        
        expect(viewModel.isPasswordVisible, true);
        
        viewModel.togglePasswordVisibility();
        
        expect(viewModel.isPasswordVisible, false);
      });
    });

    group('로그인', () {
      test('빈 필드가 있으면 로그인이 실패해야 한다', () async {
        viewModel.loginIdController.text = '';
        viewModel.passwordController.text = TestData.testPassword;
        
        final result = await viewModel.login();
        
        expect(result, false);
      });

      test('유효한 정보로 로그인이 성공해야 한다', () async {
        final testUser = User(
          id: 123,
          loginId: TestData.testLoginId,
          nickname: TestData.testNickname,
          points: 0,
        );
        
        viewModel.loginIdController.text = TestData.testLoginId;
        viewModel.passwordController.text = TestData.testPassword;
        
        when(mockLoginUseCase.call(TestData.testLoginId, TestData.testPassword))
            .thenAnswer((_) async => testUser);
        
        final result = await viewModel.login();
        
        expect(result, true);
        expect(viewModel.loginError, null);
        verify(mockLoginUseCase.call(TestData.testLoginId, TestData.testPassword)).called(1);
      });

      test('잘못된 정보로 로그인이 실패해야 한다', () async {
        const wrongLoginId = 'wronguser';
        const wrongPassword = 'wrongpassword';
        
        viewModel.loginIdController.text = wrongLoginId;
        viewModel.passwordController.text = wrongPassword;
        
        when(mockLoginUseCase.call(wrongLoginId, wrongPassword))
            .thenThrow(Exception('로그인 실패'));
        
        final result = await viewModel.login();
        
        expect(result, false);
        expect(viewModel.loginError, isNotNull);
        verify(mockLoginUseCase.call(wrongLoginId, wrongPassword)).called(1);
      });
    });

    group('입력 값 변경', () {
      test('로그인 ID 변경 시 LoginViewModel이 작동해야 한다', () {
        viewModel.loginIdController.text = 'newuser';
        
        expect(viewModel.loginId, 'newuser');
      });

      test('비밀번호 변경 시 LoginViewModel이 작동해야 한다', () {
        viewModel.setPassword('newpassword');
        
        expect(viewModel.passwordController.text, 'newpassword');
      });
    });

    group('오류 처리', () {
      test('유효성 검사가 작동해야 한다', () {
        viewModel.loginIdController.text = '';
        viewModel.passwordController.text = '';
        
        final result = viewModel.validateInput();
        
        expect(result, false);
        expect(viewModel.loginError, '아이디를 입력해주세요.');
      });

      test('비밀번호 유효성 검사가 작동해야 한다', () {
        viewModel.loginIdController.text = 'validuser';
        viewModel.passwordController.text = '';
        
        final result = viewModel.validateInput();
        
        expect(result, false);
        expect(viewModel.passwordError, '비밀번호를 입력해주세요.');
      });
    });
  });
}
