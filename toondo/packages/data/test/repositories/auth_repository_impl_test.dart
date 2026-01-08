import 'package:data/datasources/local/auth_local_datasource.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:data/models/auth_tokens.dart';
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
      test('registerUser는 원격 API를 호출하고 토큰을 저장해야 한다', () async {
        // Arrange
        const loginId = 'testuser123';
        const password = 'TestPass123!';
        
        // 토큰 설정
        const tokens = AuthTokens(accessToken: 'test_token', refreshToken: 'refresh_token');
        
        when(mockRemote.registerUser(loginId, password))
          .thenAnswer((_) async => tokens);
        when(mockSecureLocal.saveAccessToken(tokens.accessToken))
          .thenAnswer((_) async {});
        when(mockSecureLocal.saveRefreshToken(tokens.refreshToken))
            .thenAnswer((_) async {});
        
        // Act
        await repository.registerUser(loginId, password);
        
        // Assert
        verify(mockRemote.registerUser(loginId, password));
        verify(mockSecureLocal.saveAccessToken('test_token'));
        verify(mockSecureLocal.saveRefreshToken('refresh_token'));
      });
    });

    group('로그인 테스트', () {
      test('login은 원격 API를 호출하고 토큰을 저장해야 한다', () async {
        // Arrange
        const loginId = 'testuser123';
        const password = 'TestPass123!';
        
        // 토큰 설정
        const tokens = AuthTokens(accessToken: 'test_token', refreshToken: 'refresh_token');
        
        when(mockRemote.login(loginId, password))
          .thenAnswer((_) async => tokens);
        when(mockSecureLocal.saveAccessToken(tokens.accessToken))
          .thenAnswer((_) async {});
        when(mockSecureLocal.saveRefreshToken(tokens.refreshToken))
            .thenAnswer((_) async {});
        
        // Act
        await repository.login(loginId, password);
        
        // Assert
        verify(mockRemote.login(loginId, password));
        verify(mockSecureLocal.saveAccessToken('test_token'));
        verify(mockSecureLocal.saveRefreshToken('refresh_token'));
      });
    });

    group('로그아웃 테스트', () {
      test('logout은 보안 저장소에서 토큰을 삭제해야 한다', () async {
        // Arrange
        when(mockSecureLocal.clearAuthTokens())
            .thenAnswer((_) async {});
        
        // Act
        await repository.logout();
        
        // Assert
        verify(mockSecureLocal.clearAuthTokens());
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

    group('로그인 ID 확인 테스트', () {
      test('checkLoginIdExists는 원격 API를 호출하여 로그인 ID 존재 여부를 확인해야 한다', () async {
        // Arrange
        const loginId = 'testuser123';
        when(mockRemote.isLoginIdRegistered(loginId))
            .thenAnswer((_) async => true);
        
        // Act
        final result = await repository.checkLoginIdExists(loginId);
        
        // Assert
        expect(result, isTrue);
        verify(mockRemote.isLoginIdRegistered(loginId));
      });
    });

    group('예외 처리 테스트', () {
      test('원격 API에서 예외 발생 시 그대로 전파되어야 한다', () async {
        // Arrange
        const loginId = 'testuser123';
        const password = 'TestPass123!';
        when(mockRemote.login(loginId, password))
            .thenThrow(Exception('로그인 실패'));
        
        // Act & Assert
        expect(() => repository.login(loginId, password), throwsException);
        verify(mockRemote.login(loginId, password));
        verifyNever(mockSecureLocal.saveAccessToken(any));
        verifyNever(mockSecureLocal.saveRefreshToken(any));
        verifyNever(mockLocal.cacheUser(any));
      });
    });
  });
}