import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'package:mockito/annotations.dart';
import 'signup_viewmodel_test.mocks.dart';

@GenerateMocks([
  RegisterUseCase,
  CheckLoginIdExistsUseCase
])

void main() {
  late SignupViewModel viewModel;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockCheckLoginIdExistsUseCase mockCheckLoginIdExistsUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockCheckLoginIdExistsUseCase = MockCheckLoginIdExistsUseCase();
    
    viewModel = SignupViewModel(
      registerUserUseCase: mockRegisterUseCase,
      checkLoginIdExistsUseCase: mockCheckLoginIdExistsUseCase,
    );
  });

  group('SignupViewModel', () {
    group('초기 상태', () {
      test('초기 상태는 빈 값과 기본 설정을 가져야 한다', () {
        expect(viewModel.loginId, isEmpty);
        expect(viewModel.password, isEmpty);
        expect(viewModel.currentStep, 1);
        expect(viewModel.isSignupComplete, false);
        expect(viewModel.userId, null);
        expect(viewModel.loginIdError, null);
        expect(viewModel.passwordError, null);
      });
    });

    group('로그인 ID 설정', () {
      test('setLoginId는 로그인 ID와 컨트롤러 텍스트를 업데이트해야 한다', () {
        viewModel.setLoginId(TestData.testLoginId);
        
        expect(viewModel.loginId, TestData.testLoginId);
        expect(viewModel.loginIdController.text, TestData.testLoginId);
      });
    });

    group('비밀번호 설정', () {
      test('setPassword는 비밀번호와 컨트롤러 텍스트를 업데이트해야 한다', () {
        viewModel.setPassword(TestData.testPassword);
        
        expect(viewModel.password, TestData.testPassword);
        expect(viewModel.passwordController.text, TestData.testPassword);
      });
    });

    group('로그인 ID 유효성 검사', () {
      test('빈 로그인 ID는 유효하지 않아야 한다', () async {
        viewModel.setLoginId('');
        
        final result = await viewModel.validateLoginId();
        
        expect(result, false);
        expect(viewModel.loginIdError, '아이디를 입력해주세요.');
      });

      test('너무 짧은 로그인 ID는 유효하지 않아야 한다', () async {
        viewModel.setLoginId('ab');
        
        final result = await viewModel.validateLoginId();
        
        expect(result, false);
        expect(viewModel.loginIdError, '아이디는 4자 이상 20자 이하여야 합니다.');
      });

      test('유효한 로그인 ID는 통과해야 한다', () async {
        viewModel.setLoginId(TestData.testLoginId);
        
        when(mockCheckLoginIdExistsUseCase.call(TestData.testLoginId))
            .thenAnswer((_) async => false);
        
        final result = await viewModel.validateLoginId();
        
        expect(result, true);
        expect(viewModel.loginIdError, null);
        verify(mockCheckLoginIdExistsUseCase.call(TestData.testLoginId)).called(1);
      });

      test('이미 존재하는 로그인 ID는 유효하지 않아야 한다', () async {
        const existingLoginId = 'existinguser';
        viewModel.setLoginId(existingLoginId);
        
        when(mockCheckLoginIdExistsUseCase.call(existingLoginId))
            .thenAnswer((_) async => true);
        
        final result = await viewModel.validateLoginId();
        
        expect(result, false);
        expect(viewModel.loginIdError, '이미 사용 중인 로그인 ID입니다.');
        verify(mockCheckLoginIdExistsUseCase.call(existingLoginId)).called(1);
      });
    });

    group('비밀번호 유효성 검사', () {
      test('빈 비밀번호는 유효하지 않아야 한다', () async {
        viewModel.setPassword('');
        
        final result = await viewModel.validatePassword();
        
        expect(result, false);
        expect(viewModel.passwordError, '비밀번호를 입력해주세요.');
      });

      test('너무 짧은 비밀번호는 유효하지 않아야 한다', () async {
        viewModel.setPassword('123');
        
        final result = await viewModel.validatePassword();
        
        expect(result, false);
        expect(viewModel.passwordError, '비밀번호는 8자 이상 20자 이하여야 합니다.');
      });

      test('유효한 비밀번호는 통과해야 한다', () async {
        viewModel.setPassword(TestData.testPassword);
        
        final result = await viewModel.validatePassword();
        
        expect(result, true);
        expect(viewModel.passwordError, null);
      });
    });

    group('닉네임 유효성 검사', () {
      test('빈 닉네임은 유효하지 않아야 한다', () async {
        viewModel.setNickname('');
        
        final result = await viewModel.validateNickname();
        
        expect(result, false);
        expect(viewModel.nicknameError, '닉네임을 입력해주세요.');
      });

      test('유효한 닉네임은 통과해야 한다', () async {
        viewModel.setNickname(TestData.testNickname);
        
        final result = await viewModel.validateNickname();
        
        expect(result, true);
        expect(viewModel.nicknameError, null);
      });
    });

    group('회원가입', () {
      test('모든 정보가 유효할 때 회원가입이 성공해야 한다', () async {
        viewModel.setLoginId(TestData.testLoginId);
        viewModel.setPassword(TestData.testPassword);
        viewModel.setNickname(TestData.testNickname);
        
        when(mockCheckLoginIdExistsUseCase.call(TestData.testLoginId))
            .thenAnswer((_) async => false);
        when(mockRegisterUseCase.call(any))
            .thenAnswer((_) async => 'user123');
        
        await viewModel.validateLoginId();
        await viewModel.validatePassword();
        await viewModel.validateNickname();
        await viewModel.register();
        
        expect(viewModel.isSignupComplete, true);
        expect(viewModel.userId, 'user123');
        verify(mockRegisterUseCase.call(any)).called(1);
      });
    });
  });
}
