import 'package:data/datasources/local/auth_local_datasource.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:data/constants.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final SecureLocalDataSource secureLocalDataSource;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.secureLocalDataSource,
  );

  @override
  Future<User> registerUser(String loginId, String password) async {
    print('AuthRepositoryImpl: registerUser called with loginId=$loginId');
    final tokens = await remoteDataSource.registerUser(loginId, password);
    // signup 응답이 201 + empty body인 경우(토큰 없음)도 "회원가입 성공"으로 처리한다.
    // 이때 토큰 저장은 하지 않고, 이후 login에서 토큰을 발급/저장하도록 둔다.
    if (tokens.accessToken.isNotEmpty && tokens.refreshToken.isNotEmpty) {
      await secureLocalDataSource.saveAccessToken(tokens.accessToken);
      await secureLocalDataSource.saveRefreshToken(tokens.refreshToken);
      if (Constants.useCustomUserIdHeader) {
        // 실제 등록 후 백엔드가 userId 내려주면 그 값으로 교체 필요 (현재는 test placeholder)
        await secureLocalDataSource.saveUserNumericId(
          Constants.testUserNumericId,
        );
      }
    }

    // 토큰만 저장하고 빈 사용자 객체 반환
    final emptyUser = User(id: 0, loginId: loginId, nickname: null);
    await localDataSource.cacheUser(UserModel.fromEntity(emptyUser));
    return emptyUser;
  }

  @override
  Future<User> login(String loginId, String password) async {
    final tokens = await remoteDataSource.login(loginId, password);
    await secureLocalDataSource.saveAccessToken(tokens.accessToken);
    await secureLocalDataSource.saveRefreshToken(tokens.refreshToken);
    if (Constants.useCustomUserIdHeader) {
      // test bypass 시 토큰 대신 사용자 번호를 헤더에 넣을 수 있도록 저장
      await secureLocalDataSource.saveUserNumericId(
        Constants.testUserNumericId,
      );
    }

    // 토큰만 저장하고 빈 사용자 객체 반환
    final emptyUser = User(
      id: 0,
      loginId: loginId,
      nickname: (loginId == Constants.testLoginId) ? '테스트계정' : null,
    );
    await localDataSource.cacheUser(UserModel.fromEntity(emptyUser));
    return emptyUser;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await secureLocalDataSource.getRefreshToken();

    // 서버 로그아웃은 best-effort: 실패하더라도 로컬 상태는 반드시 정리
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await remoteDataSource.logout(refreshToken);
      } catch (e) {
        print('AuthRepositoryImpl: remote logout failed: $e');
      }
    }

    // refreshToken이 없거나 서버 호출이 실패해도 쿠키 기반 세션은 남을 수 있으므로 제거
    try {
      await remoteDataSource.clearCookies();
    } catch (e) {
      print('AuthRepositoryImpl: clearCookies failed: $e');
    }

    await secureLocalDataSource.clearAuthTokens();
    await secureLocalDataSource.deleteUserNumericId();
    await localDataSource.clearUser();
  }

  @override
  Future<String?> getToken() async {
    return await secureLocalDataSource.getToken();
  }

  @override
  Future<bool> checkLoginIdExists(String loginId) {
    return remoteDataSource.isLoginIdRegistered(loginId);
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: 백엔드 API 호출 (현재는 구현되지 않음)
    // await remoteDataSource.deleteAccount();

    // 로컬 데이터 삭제
    await secureLocalDataSource.clearAuthTokens();
    await secureLocalDataSource.deleteUserNumericId();
    await localDataSource.clearUser();
  }
}
