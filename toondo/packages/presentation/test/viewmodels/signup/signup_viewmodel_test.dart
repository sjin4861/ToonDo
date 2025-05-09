import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_phone_number_exists.dart';
import 'package:domain/usecases/sms/send_sms_code.dart';
import 'package:domain/usecases/sms/verify_sms_code.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'package:mockito/annotations.dart';
import 'signup_viewmodel_test.mocks.dart';

@GenerateMocks([
  RegisterUseCase,
  SendSmsCode,
  VerifySmsCode,
  CheckPhoneNumberExistsUseCase
])

void main() {
  late SignupViewModel viewModel;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockSendSmsCode mockSendSmsCode;
  late MockVerifySmsCode mockVerifySmsCode;
  late MockCheckPhoneNumberExistsUseCase mockCheckPhoneNumberExistsUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockSendSmsCode = MockSendSmsCode();
    mockVerifySmsCode = MockVerifySmsCode();
    mockCheckPhoneNumberExistsUseCase = MockCheckPhoneNumberExistsUseCase();
    
    viewModel = SignupViewModel(
      registerUserUseCase: mockRegisterUseCase,
      sendSmsCodeUseCase: mockSendSmsCode,
      verifySmsCodeUseCase: mockVerifySmsCode,
      checkPhoneNumberExistsUseCase: mockCheckPhoneNumberExistsUseCase,
    );
  });

  group('SignupViewModel', () {
    group('초기 상태', () {
      test('초기 상태는 빈 값과 기본 설정을 가져야 한다', () {
        expect(viewModel.phoneNumber, isEmpty);
        expect(viewModel.password, isEmpty);
        expect(viewModel.currentStep, 1);
        expect(viewModel.isSignupComplete, false);
        expect(viewModel.userId, null);
        expect(viewModel.phoneError, null);
        expect(viewModel.passwordError, null);
      });
    });
    
    group('입력 필드 및 상태 제어', () {
      test('전화번호 설정은 상태를 변경해야 한다', () {
        // Given
        const testPhoneNumber = '01012345678';
        
        // When
        viewModel.setPhoneNumber(testPhoneNumber);
        
        // Then
        expect(viewModel.phoneNumber, testPhoneNumber);
        expect(viewModel.phoneNumberController.text, testPhoneNumber);
      });

      test('비밀번호 설정은 상태를 변경해야 한다', () {
        // Given
        const testPassword = 'password123';
        
        // When
        viewModel.setPassword(testPassword);
        
        // Then
        expect(viewModel.password, testPassword);
      });

      test('단계 이동은 currentStep을 변경해야 한다', () {
        // Given
        expect(viewModel.currentStep, 1);
        
        // When - 다음 단계로
        viewModel.nextStep();
        
        // Then
        expect(viewModel.currentStep, 2);
        
        // When - 이전 단계로
        viewModel.goBack();
        
        // Then
        expect(viewModel.currentStep, 1);
      });

      test('1단계에서 이전으로 이동해도 단계는 1로 유지되어야 한다', () {
        // Given
        expect(viewModel.currentStep, 1);
        
        // When
        viewModel.goBack();
        
        // Then
        expect(viewModel.currentStep, 1);
      });
    });
    
    group('전화번호 유효성 검사', () {
      test('빈 번호는 유효성 검사에 실패해야 한다', () async {
        // Given
        viewModel.setPhoneNumber('');
        
        // When
        final result = await viewModel.validatePhoneNumber();
        
        // Then
        expect(result, false);
        expect(viewModel.phoneError, '유효한 휴대폰 번호를 입력해주세요.');
      });

      test('유효하지 않은 번호는 유효성 검사에 실패해야 한다', () async {
        // Given
        viewModel.setPhoneNumber('123');
        
        // When
        final result = await viewModel.validatePhoneNumber();
        
        // Then
        expect(result, false);
        expect(viewModel.phoneError, '유효한 휴대폰 번호를 입력해주세요.');
      });

      test('이미 등록된 번호는 로그인으로 안내해야 한다', () async {
        // Given
        const testPhoneNumber = '01012345678';
        viewModel.setPhoneNumber(testPhoneNumber);
        
        when(mockCheckPhoneNumberExistsUseCase.call(testPhoneNumber))
            .thenAnswer((_) async => true);
            
        // When
        final result = await viewModel.validatePhoneNumber();
        
        // Then
        expect(result, true);
        expect(viewModel.phoneError, null);
        expect(viewModel.currentStep, 1); // 다음 단계로 이동하지 않음
        verify(mockCheckPhoneNumberExistsUseCase.call(testPhoneNumber)).called(1);
      });

      test('신규 번호는 다음 단계로 진행해야 한다', () async {
        // Given
        const testPhoneNumber = '01012345678';
        viewModel.setPhoneNumber(testPhoneNumber);
        
        when(mockCheckPhoneNumberExistsUseCase.call(testPhoneNumber))
            .thenAnswer((_) async => false);
            
        // When
        final result = await viewModel.validatePhoneNumber();
        
        // Then
        expect(result, false); // 등록되지 않았으므로 false
        expect(viewModel.phoneError, null);
        expect(viewModel.currentStep, 2); // 다음 단계로 이동
        verify(mockCheckPhoneNumberExistsUseCase.call(testPhoneNumber)).called(1);
      });
    });
    
    group('SMS 관련 기능', () {
      test('SMS 코드 전송 성공', () async {
        // Given
        const testPhoneNumber = '01012345678';
        const successMessage = '인증번호가 전송되었습니다.';
        viewModel.setPhoneNumber(testPhoneNumber);
        
        when(mockSendSmsCode.call(testPhoneNumber))
            .thenAnswer((_) async => successMessage);
            
        // When
        await viewModel.sendSmsCodeAndSetState();
        
        // Then
        verify(mockSendSmsCode.call(testPhoneNumber)).called(1);
        expect(viewModel.isSmsLoading, false);
        expect(viewModel.smsMessage, successMessage);
      });

      test('SMS 코드 전송 실패', () async {
        // Given
        const testPhoneNumber = '01012345678';
        viewModel.setPhoneNumber(testPhoneNumber);
        
        when(mockSendSmsCode.call(testPhoneNumber))
            .thenThrow(Exception('SMS 전송 실패'));
            
        // When
        await viewModel.sendSmsCodeAndSetState();
        
        // Then
        verify(mockSendSmsCode.call(testPhoneNumber)).called(1);
        expect(viewModel.isSmsLoading, false);
        expect(viewModel.smsMessage.contains('SMS 전송 실패'), true);
      });

      test('SMS 코드 검증 - 0000 자동 통과', () async {
        // Given
        viewModel.smsCodeController.text = '0000';
        
        // When
        await viewModel.verifySmsCodeAndSetState();
        
        // Then
        verifyNever(mockVerifySmsCode.call('', '0000'));
        expect(viewModel.isSmsLoading, false);
        expect(viewModel.smsMessage, '인증 성공!');
      });
      
      test('SMS 코드 검증 성공', () async {
        // Given
        const testPhoneNumber = '01012345678';
        const testCode = '1234';
        viewModel.setPhoneNumber(testPhoneNumber);
        viewModel.smsCodeController.text = testCode;
        
        when(mockVerifySmsCode.call(testPhoneNumber, testCode))
            .thenAnswer((_) async => 'OK');
            
        // When
        await viewModel.verifySmsCodeAndSetState();
        
        // Then
        verify(mockVerifySmsCode.call(testPhoneNumber, testCode)).called(1);
        expect(viewModel.isSmsLoading, false);
        expect(viewModel.smsMessage, '인증 성공!');
      });
    });
    
    group('비밀번호 검증 및 회원가입', () {
      test('유효한 비밀번호로 회원가입 성공', () async {
        // Given
        const testPhoneNumber = '01012345678';
        const testPassword = 'password123';
        const testUserId = 1;
        
        viewModel.setPhoneNumber(testPhoneNumber);
        viewModel.setPassword(testPassword);
        
        final testUser = TestData.createTestUser(id: testUserId);
        when(mockRegisterUseCase.call(testPhoneNumber, testPassword))
            .thenAnswer((_) async => testUser);
            
        // When
        await viewModel.validatePassword();
        
        // Then
        expect(viewModel.passwordError, null);
        expect(viewModel.isSignupComplete, true);
        expect(viewModel.userId, testUserId);
        verify(mockRegisterUseCase.call(testPhoneNumber, testPassword)).called(1);
      });

      test('비밀번호가 너무 짧으면 검증 실패', () async {
        // Given
        viewModel.setPassword('1234');
        
        // When
        await viewModel.validatePassword();
        
        // Then
        expect(viewModel.passwordError, '비밀번호는 8자 이상 20자 이하여야 합니다.');
        expect(viewModel.isSignupComplete, false);
        verifyNever(mockRegisterUseCase.call('', '1234'));
      });

      test('비밀번호가 너무 길면 검증 실패', () async {
        // Given
        viewModel.setPassword('12345678901234567890123');
        
        // When
        await viewModel.validatePassword();
        
        // Then
        expect(viewModel.passwordError, '비밀번호는 8자 이상 20자 이하여야 합니다.');
        expect(viewModel.isSignupComplete, false);
        verifyNever(mockRegisterUseCase.call('', '12345678901234567890123'));
      });
      
      test('회원가입 실패 시 예외 발생', () async {
        // Given
        const testPhoneNumber = '01012345678';
        const testPassword = 'password123';
        
        viewModel.setPhoneNumber(testPhoneNumber);
        viewModel.setPassword(testPassword);
        
        when(mockRegisterUseCase.call(testPhoneNumber, testPassword))
            .thenThrow(Exception('회원가입 실패'));
            
        // When/Then
        expect(
          () => viewModel.validatePassword(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(), 
            'message', 
            contains('회원가입에 실패했습니다')
          )),
        );
      });
    });

    group('전체 회원가입 흐름', () {
      test('전화번호 확인부터 인증, 비밀번호 검증, 회원가입 완료까지', () async {
        // Given
        const phone = '01012345678';
        const password = 'password123';
        viewModel.setPhoneNumber(phone);
        // stub phone check: 신규 번호
        when(mockCheckPhoneNumberExistsUseCase.call(phone))
            .thenAnswer((_) async => false);
        // stub SMS send
        when(mockSendSmsCode.call(phone))
            .thenAnswer((_) async => '인증번호 전송');
        // stub SMS verify (return non-null string)
        when(mockVerifySmsCode.call(phone, '1234'))
            .thenAnswer((_) async => 'OK');
        // stub register
        final testUser = TestData.createTestUser();
        when(mockRegisterUseCase.call(phone, password))
            .thenAnswer((_) async => testUser);

        // When: 전화번호 검증
        final step1 = await viewModel.validatePhoneNumber();
        // Then: 다음 단계로 이동
        expect(step1, false);
        expect(viewModel.currentStep, 2);

        // When: SMS 코드 전송
        await viewModel.sendSmsCodeAndSetState();
        expect(viewModel.smsMessage, '인증번호 전송');

        // When: SMS 코드 검증
        viewModel.smsCodeController.text = '1234';
        await viewModel.verifySmsCodeAndSetState();
        expect(viewModel.smsMessage, '인증 성공!');

        // When: 비밀번호 설정 및 검증
        viewModel.setPassword(password);
        await viewModel.validatePassword();
        // Then: 회원가입 완료
        expect(viewModel.isSignupComplete, true);
        expect(viewModel.userId, testUser.id);
      });
    });
  });
}