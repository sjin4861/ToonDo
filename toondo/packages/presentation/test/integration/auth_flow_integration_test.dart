import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/login.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import '../helpers/test_data.dart';
import 'package:mockito/annotations.dart';
import 'auth_flow_integration_test.mocks.dart';

@GenerateMocks([RegisterUseCase, LoginUseCase, CheckLoginIdExistsUseCase])
void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockCheckLoginIdExistsUseCase mockCheckLoginIdExistsUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockCheckLoginIdExistsUseCase = MockCheckLoginIdExistsUseCase();
  });

  group('인증 플로우 통합 테스트', () {
    test('완전한 회원가입 플로우가 성공해야 한다', () async {
      // Given: 회원가입 ViewModel 준비
      final signupViewModel = SignupViewModel(
        registerUserUseCase: mockRegisterUseCase,
        checkLoginIdExistsUseCase: mockCheckLoginIdExistsUseCase,
        loginUseCase: mockLoginUseCase,
      );

      // TODO: User 엔티티에서 points 필드가 제거되고 createdAt 필드가 추가됨 - 테스트 데이터 업데이트 필요
      final testUser = User(
        id: 123,
        loginId: TestData.testLoginId,
        nickname: TestData.testNickname,
        points: 0,
      );

      // Mock 설정
      when(
        mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
      ).thenAnswer((_) async => false);
      when(
        mockRegisterUseCase.call(TestData.testLoginId, TestData.testPassword),
      ).thenAnswer((_) async => testUser);

      // When: 회원가입 프로세스 실행
      // 1단계: 로그인 ID 입력 및 검증
      signupViewModel.setLoginId(TestData.testLoginId);
      final loginIdValid = await signupViewModel.validateLoginId();

      // 2단계: 비밀번호 입력 및 회원가입 완료
      signupViewModel.setPassword(TestData.testPassword);
      await signupViewModel.validatePassword();

      // Then: 회원가입 성공 검증
      expect(loginIdValid, true);
      expect(signupViewModel.loginIdError, null);
      expect(signupViewModel.passwordError, null);
      expect(signupViewModel.isSignupComplete, true);
      expect(signupViewModel.userId, 123);
      expect(signupViewModel.currentStep, 2);

      // UseCase 호출 검증
      verify(
        mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
      ).called(1);
      verify(
        mockRegisterUseCase.call(TestData.testLoginId, TestData.testPassword),
      ).called(1);
    });

    test('회원가입 후 로그인 플로우가 성공해야 한다', () async {
      // Given: 회원가입이 완료된 상태라고 가정
      final loginViewModel = LoginViewModel(loginUseCase: mockLoginUseCase);

      // TODO: User 엔티티에서 points 필드가 제거되고 createdAt 필드가 추가됨 - 테스트 데이터 업데이트 필요
      final testUser = User(
        id: 123,
        loginId: TestData.testLoginId,
        nickname: TestData.testNickname,
        points: 0,
      );

      // Mock 설정
      when(
        mockLoginUseCase.call(TestData.testLoginId, TestData.testPassword),
      ).thenAnswer((_) async => testUser);

      // When: 로그인 실행
      loginViewModel.loginIdController.text = TestData.testLoginId;
      loginViewModel.passwordController.text = TestData.testPassword;
      final loginResult = await loginViewModel.login();

      // Then: 로그인 성공 검증
      expect(loginResult, true);
      expect(loginViewModel.loginError, null);
      expect(loginViewModel.passwordError, null);

      // UseCase 호출 검증
      verify(
        mockLoginUseCase.call(TestData.testLoginId, TestData.testPassword),
      ).called(1);
    });

    test('중복된 로그인 ID로 회원가입 시도 시 실패해야 한다', () async {
      // Given: 회원가입 ViewModel 준비
      final signupViewModel = SignupViewModel(
        registerUserUseCase: mockRegisterUseCase,
        checkLoginIdExistsUseCase: mockCheckLoginIdExistsUseCase,
        loginUseCase: mockLoginUseCase,
      );

      // Mock 설정: 이미 존재하는 로그인 ID
      when(
        mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
      ).thenAnswer((_) async => true);

      // When: 중복된 로그인 ID로 검증 시도
      signupViewModel.setLoginId(TestData.testLoginId);
      final loginIdValid = await signupViewModel.validateLoginId();

      // Then: 회원가입 실패 검증
      expect(loginIdValid, false);
      expect(signupViewModel.loginIdError, '이미 사용 중인 아이디입니다.');
      expect(signupViewModel.isSignupComplete, false);
      expect(signupViewModel.currentStep, 1); // 1단계에 머물러 있어야 함

      // UseCase 호출 검증
      verify(
        mockCheckLoginIdExistsUseCase.call(TestData.testLoginId),
      ).called(1);
      verifyNever(mockRegisterUseCase.call(any, any));
    });

    test('잘못된 로그인 정보로 로그인 시도 시 실패해야 한다', () async {
      // Given: 로그인 ViewModel 준비
      final loginViewModel = LoginViewModel(loginUseCase: mockLoginUseCase);

      const wrongLoginId = 'wronguser';
      const wrongPassword = 'wrongpassword';

      // Mock 설정: 잘못된 정보로 로그인 실패
      when(
        mockLoginUseCase.call(wrongLoginId, wrongPassword),
      ).thenThrow(Exception('Invalid credentials'));

      // When: 잘못된 정보로 로그인 시도
      loginViewModel.loginIdController.text = wrongLoginId;
      loginViewModel.passwordController.text = wrongPassword;
      final loginResult = await loginViewModel.login();

      // Then: 로그인 실패 검증
      expect(loginResult, false);
      expect(loginViewModel.loginError, isNotNull);

      // UseCase 호출 검증
      verify(mockLoginUseCase.call(wrongLoginId, wrongPassword)).called(1);
    });

    test('유효성 검증 실패 시나리오들이 올바르게 처리되어야 한다', () async {
      // Given: 회원가입 ViewModel 준비
      final signupViewModel = SignupViewModel(
        registerUserUseCase: mockRegisterUseCase,
        checkLoginIdExistsUseCase: mockCheckLoginIdExistsUseCase,
        loginUseCase: mockLoginUseCase,
      );

      // When & Then: 빈 로그인 ID 검증
      signupViewModel.setLoginId('');
      final emptyIdResult = await signupViewModel.validateLoginId();
      expect(emptyIdResult, false);
      expect(signupViewModel.loginIdError, '아이디를 입력해주세요.');

      // When & Then: 너무 짧은 로그인 ID 검증
      signupViewModel.setLoginId('ab');
      final shortIdResult = await signupViewModel.validateLoginId();
      expect(shortIdResult, false);
      expect(signupViewModel.loginIdError, '아이디는 4자 이상 20자 이하여야 합니다.');

      // When & Then: 유효하지 않은 문자가 포함된 로그인 ID 검증
      signupViewModel.setLoginId('test@user');
      final invalidIdResult = await signupViewModel.validateLoginId();
      expect(invalidIdResult, false);
      expect(signupViewModel.loginIdError, '아이디는 영문, 숫자, 언더바(_)만 사용 가능합니다.');

      // When & Then: 빈 비밀번호 검증
      signupViewModel.setPassword('');
      await signupViewModel.validatePassword();
      expect(signupViewModel.passwordError, '비밀번호를 입력해주세요.');

      // When & Then: 너무 짧은 비밀번호 검증
      signupViewModel.setPassword('123');
      await signupViewModel.validatePassword();
      expect(signupViewModel.passwordError, '비밀번호는 8자 이상 20자 이하여야 합니다.');

      // When & Then: 영문/숫자 조합이 없는 비밀번호 검증
      signupViewModel.setPassword('abcdefgh');
      await signupViewModel.validatePassword();
      expect(signupViewModel.passwordError, '비밀번호에 영문과 숫자를 모두 포함해주세요.');
    });
  });
}
