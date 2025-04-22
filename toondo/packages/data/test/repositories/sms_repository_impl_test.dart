import 'package:data/datasources/remote/sms_remote_datasource.dart';
import 'package:data/repositories/sms_repository_impl.dart';
import 'package:domain/repositories/sms_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'sms_repository_impl_test.mocks.dart';

@GenerateMocks([
  SmsRemoteDataSource,
])
void main() {
  late SmsRepository repository;
  late MockSmsRemoteDataSource mockRemote;

  setUp(() {
    mockRemote = MockSmsRemoteDataSource();
    repository = SmsRepositoryImpl(mockRemote);
  });

  group('SmsRepositoryImpl', () {
    group('SMS 코드 전송 테스트', () {
      test('sendSmsCode는 원격 데이터소스의 SMS 코드 전송 메서드를 호출해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const expectedResponse = '인증번호가 전송되었습니다';
        when(mockRemote.sendSmsCode(phoneNumber))
            .thenAnswer((_) async => expectedResponse);
        
        // Act
        final result = await repository.sendSmsCode(phoneNumber);
        
        // Assert
        expect(result, equals(expectedResponse));
        verify(mockRemote.sendSmsCode(phoneNumber));
      });

      test('전화번호가 유효하지 않을 때 예외를 발생시켜야 한다', () async {
        // Arrange
        const invalidPhoneNumber = '010';
        when(mockRemote.sendSmsCode(invalidPhoneNumber))
            .thenThrow(Exception('유효하지 않은 전화번호입니다'));
        
        // Act & Assert
        expect(() => repository.sendSmsCode(invalidPhoneNumber), throwsException);
        verify(mockRemote.sendSmsCode(invalidPhoneNumber));
      });
    });

    group('SMS 코드 검증 테스트', () {
      test('verifySmsCode는 원격 데이터소스의 SMS 코드 검증 메서드를 호출해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const code = '123456';
        const expectedResponse = '인증이 완료되었습니다';
        when(mockRemote.verifySmsCode(phoneNumber, code))
            .thenAnswer((_) async => expectedResponse);
        
        // Act
        final result = await repository.verifySmsCode(phoneNumber, code);
        
        // Assert
        expect(result, equals(expectedResponse));
        verify(mockRemote.verifySmsCode(phoneNumber, code));
      });

      test('코드가 일치하지 않을 때 예외를 발생시켜야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const invalidCode = '000000';
        when(mockRemote.verifySmsCode(phoneNumber, invalidCode))
            .thenThrow(Exception('인증번호가 일치하지 않습니다'));
        
        // Act & Assert
        expect(() => repository.verifySmsCode(phoneNumber, invalidCode), throwsException);
        verify(mockRemote.verifySmsCode(phoneNumber, invalidCode));
      });
    });

    group('예외 처리 테스트', () {
      test('원격 데이터소스에서 네트워크 오류 발생 시 예외를 전파해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        when(mockRemote.sendSmsCode(phoneNumber))
            .thenThrow(Exception('네트워크 오류가 발생했습니다'));
        
        // Act & Assert
        expect(() => repository.sendSmsCode(phoneNumber), throwsException);
        verify(mockRemote.sendSmsCode(phoneNumber));
      });
    });
  });
}