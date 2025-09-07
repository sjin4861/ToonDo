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
    final accessToken = await remoteDataSource.registerUser(
      loginId,
      password,
    );
    await secureLocalDataSource.saveToken(accessToken);
    if (Constants.useCustomUserIdHeader) {
      // 실제 등록 후 백엔드가 userId 내려주면 그 값으로 교체 필요 (현재는 test placeholder)
      await secureLocalDataSource.saveUserNumericId(Constants.testUserNumericId);
    }
    
    // 토큰만 저장하고 빈 사용자 객체 반환
    final emptyUser = User(
      id: 0,
      loginId: loginId,
      nickname: null,
    );
    await localDataSource.cacheUser(UserModel.fromEntity(emptyUser));
    return emptyUser;
  }

  @override
  Future<User> login(String loginId, String password) async {
    final accessToken = await remoteDataSource.login(loginId, password);
    await secureLocalDataSource.saveToken(accessToken);
    if (Constants.useCustomUserIdHeader) {
      // test bypass 시 토큰 대신 사용자 번호를 헤더에 넣을 수 있도록 저장
      await secureLocalDataSource.saveUserNumericId(Constants.testUserNumericId);
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
    await secureLocalDataSource.deleteToken();
  await secureLocalDataSource.deleteUserNumericId();
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
    await secureLocalDataSource.deleteToken();
  await secureLocalDataSource.deleteUserNumericId();
    await localDataSource.clearUser();
  }
}
