import 'package:data/datasources/local/auth_local_datasource.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/datasources/remote/auth_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:data/models/user_model.dart';
import 'package:injectable/injectable.dart';

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
    final responseData = await remoteDataSource.registerUser(
      loginId,
      password,
    );
    final token = responseData['token'] as String;
    await secureLocalDataSource.saveToken(token);
    final userModel = UserModel.fromJson(responseData);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<User> login(String loginId, String password) async {
    final responseData = await remoteDataSource.login(loginId, password);
    final token = responseData['token'] as String;
    await secureLocalDataSource.saveToken(token);
    final userModel = UserModel.fromJson(responseData);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await secureLocalDataSource.deleteToken();
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
    await localDataSource.clearUser();
  }
}
