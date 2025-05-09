import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/login.dart';
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
        // When - 초기화는 이미 setUp에서 수행됨
        
        // Then
        expect(viewModel.phoneNumber, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.isPasswordVisible, false);
        expect(viewModel.passwordError, null);
        expect(viewModel.loginError, null);
      });
    });
    
    group('입력 필드 제어', () {
      test('비밀번호 가시성 토글은 상태를 변경해야 한다', () {
        // Given
        expect(viewModel.isPasswordVisible, false);
        
        // When
        viewModel.togglePasswordVisibility();
        
        // Then
        expect(viewModel.isPasswordVisible, true);
        
        // When - 다시 토글
        viewModel.togglePasswordVisibility();
        
        // Then
        expect(viewModel.isPasswordVisible, false);
      });

      test('setPassword는 비밀번호를 변경해야 한다', () {
        // Given
        const testPassword = 'test1234';
        
        // When
        viewModel.setPassword(testPassword);
        
        // Then
        expect(viewModel.passwordController.text, testPassword);
      });
    });
    
    group('유효성 검사', () {
      test('빈 입력에 대한 유효성 검사는 실패해야 한다', () {
        // When
        bool result = viewModel.validateInput();
        
        // Then
        expect(result, false);
        expect(viewModel.loginError, '휴대폰 번호를 입력해주세요.');
        expect(viewModel.passwordError, '비밀번호를 입력해주세요.');
      });

      test('비밀번호만 입력된 경우 유효성 검사는 실패해야 한다', () {
        // Given
        viewModel.setPassword('password123');
        
        // When
        bool result = viewModel.validateInput();
        
        // Then
        expect(result, false);
        expect(viewModel.loginError, '휴대폰 번호를 입력해주세요.');
        expect(viewModel.passwordError, null);
      });

      test('전화번호만 입력된 경우 유효성 검사는 실패해야 한다', () {
        // Given
        viewModel.phoneNumberController.text = '01012345678';
        
        // When
        bool result = viewModel.validateInput();
        
        // Then
        expect(result, false);
        expect(viewModel.loginError, null);
        expect(viewModel.passwordError, '비밀번호를 입력해주세요.');
      });

      test('모든 필드가 입력된 경우 유효성 검사는 성공해야 한다', () {
        // Given
        viewModel.phoneNumberController.text = '01012345678';
        viewModel.passwordController.text = 'password123';
        
        // When
        bool result = viewModel.validateInput();
        
        // Then
        expect(result, true);
        expect(viewModel.loginError, null);
        expect(viewModel.passwordError, null);
      });
    });
    
    group('로그인 기능', () {
      test('로그인 성공 시 true를 반환해야 한다', () async {
        // Given
        const phoneNumber = '01012345678';
        const password = 'password123';
        viewModel.phoneNumberController.text = phoneNumber;
        viewModel.passwordController.text = password;
        
        final testUser = TestData.createTestUser();
        when(mockLoginUseCase.call(phoneNumber, password))
          .thenAnswer((_) async => testUser);

        // When
        final result = await viewModel.login();

        // Then
        expect(result, true);
        verify(mockLoginUseCase.call(phoneNumber, password)).called(1);
      });

      test('로그인 실패 시 에러 메시지를 설정하고 false를 반환해야 한다', () async {
        // Given
        const phoneNumber = '01012345678';
        const password = 'wrong_password';
        viewModel.phoneNumberController.text = phoneNumber;
        viewModel.passwordController.text = password;
        
        // 수정: null-safe Mockito stubbing 사용
        when(mockLoginUseCase.call(phoneNumber, password))
            .thenThrow(Exception('로그인 실패'));

        // When
        final result = await viewModel.login();

        // Then
        expect(result, false);
        expect(viewModel.loginError, 'Exception: 로그인 실패');
        // 수정: null-safe verify 사용
        verify(mockLoginUseCase.call(phoneNumber, password)).called(1);
      });

      test('유효성 검사 실패 시 로그인을 시도하지 않고 false를 반환해야 한다', () async {
        // Given - 빈 입력 상태
        
        // When
        final result = await viewModel.login();

        // Then
        expect(result, false);
        // 검증 실패 시 로그인 시도가 없음을 확인 (verifyZeroInteractions는 그대로 사용 가능)
        verifyZeroInteractions(mockLoginUseCase);
      });
    });
  });
}