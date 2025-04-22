import 'package:data/datasources/local/auth_local_datasource.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:data/models/user_model.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDataSource,
  AuthLocalDataSource,
  SecureLocalDataSource,
])
void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late MockSecureLocalDataSource mockSecureLocal;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    mockSecureLocal = MockSecureLocalDataSource();
    
    repository = AuthRepositoryImpl(
      mockRemote,
      mockLocal,
      mockSecureLocal,
    );
  });

  group('AuthRepositoryImpl', () {
    group('회원가입 테스트', () {
      test('registerUser는 원격 API를 호출하고, 토큰을 저장하고, 로컬에 사용자를 캐시해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const password = 'password123';
        final user = TestData.createTestUser(loginId: phoneNumber);
        final userModel = UserModel(id: user.id, loginId: user.loginId, nickname: user.nickname, points: user.points);
        
        final responseData = {
          'userId': user.id, // id -> userId로 변경
          'loginId': user.loginId,
          'nickname': user.nickname,
          'points': user.points,
          'token': 'test_token'
        };
        
        when(mockRemote.registerUser(phoneNumber, password))
            .thenAnswer((_) async => responseData);
        when(mockSecureLocal.saveToken('test_token'))
            .thenAnswer((_) async {});
        when(mockLocal.cacheUser(any))
            .thenAnswer((_) async {});
        
        // Act
        final result = await repository.registerUser(phoneNumber, password);
        
        // Assert
        expect(result.loginId, equals(phoneNumber));
        expect(result.nickname, equals(user.nickname));
        verify(mockRemote.registerUser(phoneNumber, password));
        verify(mockSecureLocal.saveToken('test_token'));
        verify(mockLocal.cacheUser(any));
      });
    });

    group('로그인 테스트', () {
      test('login은 원격 API를 호출하고, 토큰을 저장하고, 로컬에 사용자를 캐시해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const password = 'password123';
        final user = TestData.createTestUser(loginId: phoneNumber);
        
        final responseData = {
          'userId': user.id, // id -> userId로 변경
          'loginId': user.loginId,
          'nickname': user.nickname,
          'points': user.points,
          'token': 'test_token'
        };
        
        when(mockRemote.login(phoneNumber, password))
            .thenAnswer((_) async => responseData);
        when(mockSecureLocal.saveToken('test_token'))
            .thenAnswer((_) async {});
        when(mockLocal.cacheUser(any))
            .thenAnswer((_) async {});
        
        // Act
        final result = await repository.login(phoneNumber, password);
        
        // Assert
        expect(result.loginId, equals(phoneNumber));
        verify(mockRemote.login(phoneNumber, password));
        verify(mockSecureLocal.saveToken('test_token'));
        verify(mockLocal.cacheUser(any));
      });
    });

    group('로그아웃 테스트', () {
      test('logout은 보안 저장소에서 토큰을 삭제해야 한다', () async {
        // Arrange
        when(mockSecureLocal.deleteToken())
            .thenAnswer((_) async {});
        
        // Act
        await repository.logout();
        
        // Assert
        verify(mockSecureLocal.deleteToken());
      });
    });

    group('토큰 관리 테스트', () {
      test('getToken은 보안 저장소에서 토큰을 가져와야 한다', () async {
        // Arrange
        const expectedToken = 'test_token';
        when(mockSecureLocal.getToken())
            .thenAnswer((_) async => expectedToken);
        
        // Act
        final result = await repository.getToken();
        
        // Assert
        expect(result, equals(expectedToken));
        verify(mockSecureLocal.getToken());
      });
    });

    group('전화번호 확인 테스트', () {
      test('checkPhoneNumberExists는 원격 API를 호출하여 전화번호 존재 여부를 확인해야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        when(mockRemote.isPhoneNumberRegistered(phoneNumber))
            .thenAnswer((_) async => true);
        
        // Act
        final result = await repository.checkPhoneNumberExists(phoneNumber);
        
        // Assert
        expect(result, isTrue);
        verify(mockRemote.isPhoneNumberRegistered(phoneNumber));
      });
    });

    group('예외 처리 테스트', () {
      test('원격 API에서 예외 발생 시 그대로 전파되어야 한다', () async {
        // Arrange
        const phoneNumber = '01012345678';
        const password = 'password123';
        when(mockRemote.login(phoneNumber, password))
            .thenThrow(Exception('로그인 실패'));
        
        // Act & Assert
        expect(() => repository.login(phoneNumber, password), throwsException);
        verify(mockRemote.login(phoneNumber, password));
        verifyNever(mockSecureLocal.saveToken(any));
        verifyNever(mockLocal.cacheUser(any));
      });
    });
  });
}