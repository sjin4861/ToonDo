import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:domain/entities/user.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'package:mockito/annotations.dart';
import '../login/login_viewmodel_test.mocks.dart';
import 'signup_viewmodel_test.mocks.dart';

@GenerateMocks([RegisterUseCase, CheckLoginIdExistsUseCase])
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
      loginUseCase: MockLoginUseCase(),
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
        expect(viewModel.loginIdTextController.text, TestData.testLoginId);
      });
    });

    group('비밀번호 설정', () {
      test('setPassword는 비밀번호와 컨트롤러 텍스트를 업데이트해야 한다', () {
        viewModel.setPassword(TestData.testPassword);

        expect(viewModel.password, TestData.testPassword);
        expect(viewModel.passwordTextController.text, TestData.testPassword);
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

        when(
          mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
        ).thenAnswer((_) async => false);

        final result = await viewModel.validateLoginId();

        expect(result, true);
        expect(viewModel.loginIdError, null);
        expect(viewModel.currentStep, 2); // 다음 단계로 이동
        verify(
          mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
        ).called(1);
      });

      test('이미 존재하는 로그인 ID는 유효하지 않아야 한다', () async {
        const existingLoginId = 'existinguser';
        viewModel.setLoginId(existingLoginId);

        when(
          mockCheckLoginIdExistsUseCase.call(existingLoginId),
        ).thenAnswer((_) async => true);

        final result = await viewModel.validateLoginId();

        expect(result, false);
        expect(viewModel.loginIdError, '이미 사용 중인 아이디입니다.');
        verify(mockCheckLoginIdExistsUseCase.call(existingLoginId)).called(1);
      });
    });

    group('비밀번호 유효성 검사 및 회원가입', () {
      test('빈 비밀번호는 오류를 표시해야 한다', () async {
        viewModel.setPassword('');

        await viewModel.validatePassword();

        expect(viewModel.passwordError, '비밀번호를 입력해주세요.');
        expect(viewModel.isSignupComplete, false);
      });

      test('너무 짧은 비밀번호는 오류를 표시해야 한다', () async {
        viewModel.setPassword('123');

        await viewModel.validatePassword();

        expect(viewModel.passwordError, '비밀번호는 8자 이상 20자 이하여야 합니다.');
        expect(viewModel.isSignupComplete, false);
      });

      test('영문/숫자 조합이 없는 비밀번호는 오류를 표시해야 한다', () async {
        viewModel.setPassword('abcdefgh');

        await viewModel.validatePassword();

        expect(viewModel.passwordError, '비밀번호에 영문과 숫자를 모두 포함해주세요.');
        expect(viewModel.isSignupComplete, false);
      });

      test('유효한 비밀번호로 회원가입이 성공해야 한다', () async {
        // TODO: User 엔티티에서 points 필드가 제거되고 createdAt 필드가 추가됨 - 테스트 데이터 업데이트 필요
        final testUser = User(
          id: 123,
          loginId: TestData.testLoginId,
          nickname: TestData.testNickname,
          points: 0,
        );

        viewModel.setLoginId(TestData.testLoginId);
        viewModel.setPassword(TestData.testPassword);

        when(
          mockRegisterUseCase.call(TestData.testLoginId, TestData.testPassword),
        ).thenAnswer((_) async => testUser);

        await viewModel.validatePassword();

        expect(viewModel.passwordError, null);
        expect(viewModel.isSignupComplete, true);
        expect(viewModel.userId, 123);
        verify(
          mockRegisterUseCase.call(TestData.testLoginId, TestData.testPassword),
        ).called(1);
      });
    });

    group('단계 관리', () {
      test('nextStep은 현재 단계를 증가시켜야 한다', () {
        expect(viewModel.currentStep, 1);

        viewModel.goToNextStep();

        expect(viewModel.currentStep, 2);
      });

      test('goBack은 현재 단계를 감소시켜야 한다', () {
        viewModel.goToNextStep(); // step = 2
        expect(viewModel.currentStep, 2);

        viewModel.goToPreviousStep();

        expect(viewModel.currentStep, 1);
      });

      test('1단계에서 goBack을 호출해도 단계가 감소하지 않아야 한다', () {
        expect(viewModel.currentStep, 1);

        viewModel.goToPreviousStep();

        expect(viewModel.currentStep, 1);
      });
    });
  });
}
