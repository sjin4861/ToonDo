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
    if (Constants.remoteApiEnabled) {
      final tokens = await remoteDataSource.registerUser(loginId, password);
      if (tokens.accessToken.isNotEmpty && tokens.refreshToken.isNotEmpty) {
        await secureLocalDataSource.saveAccessToken(tokens.accessToken);
        await secureLocalDataSource.saveRefreshToken(tokens.refreshToken);
      }

      final nextId = await localDataSource.getNextUserId();
      final remoteUser = User(id: nextId, loginId: loginId.trim(), nickname: null);
      await localDataSource.saveRegisteredUser(UserModel.fromEntity(remoteUser));
      await localDataSource.cacheUser(UserModel.fromEntity(remoteUser));
      await secureLocalDataSource.saveUserPassword(loginId.trim(), password);
      return remoteUser;
    }

    final trimmedLoginId = loginId.trim();
    final exists = await localDataSource.hasRegisteredUser(trimmedLoginId);
    if (exists) {
      throw Exception('이미 가입된 아이디입니다.');
    }

    final nextId = await localDataSource.getNextUserId();
    final user = User(id: nextId, loginId: trimmedLoginId, nickname: null);

    await localDataSource.saveRegisteredUser(UserModel.fromEntity(user));
    await localDataSource.cacheUser(UserModel.fromEntity(user));
    await secureLocalDataSource.saveUserPassword(trimmedLoginId, password);
    await secureLocalDataSource.saveAccessToken('LOCAL_ACCESS_$trimmedLoginId');
    await secureLocalDataSource.saveRefreshToken(
      'LOCAL_REFRESH_$trimmedLoginId',
    );

    return user;
  }

  @override
  Future<User> login(String loginId, String password) async {
    if (Constants.remoteApiEnabled) {
      final tokens = await remoteDataSource.login(loginId, password);
      await secureLocalDataSource.saveAccessToken(tokens.accessToken);
      await secureLocalDataSource.saveRefreshToken(tokens.refreshToken);

      final model = await localDataSource.getRegisteredUser(loginId.trim()) ??
          UserModel.fromEntity(
            User(
              id: await localDataSource.getNextUserId(),
              loginId: loginId.trim(),
              nickname: null,
            ),
          );
      await localDataSource.saveRegisteredUser(model);
      await localDataSource.cacheUser(model);
      return model.toEntity();
    }

    final trimmedLoginId = loginId.trim();
    final userModel = await localDataSource.getRegisteredUser(trimmedLoginId);
    if (userModel == null) {
      throw Exception('로그인 실패: 존재하지 않는 아이디입니다.');
    }

    final savedPassword = await secureLocalDataSource.getUserPassword(
      trimmedLoginId,
    );
    if (savedPassword == null || savedPassword != password) {
      throw Exception('로그인 실패: Invalid password');
    }

    await localDataSource.cacheUser(userModel);
    await secureLocalDataSource.saveAccessToken('LOCAL_ACCESS_$trimmedLoginId');
    await secureLocalDataSource.saveRefreshToken(
      'LOCAL_REFRESH_$trimmedLoginId',
    );

    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    if (Constants.remoteApiEnabled) {
      final refreshToken = await secureLocalDataSource.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          await remoteDataSource.logout(refreshToken);
        } catch (_) {}
      }
      try {
        await remoteDataSource.clearCookies();
      } catch (_) {}
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
    if (Constants.remoteApiEnabled) {
      return remoteDataSource.isLoginIdRegistered(loginId.trim());
    }

    return localDataSource.hasRegisteredUser(loginId.trim());
  }

  @override
  Future<void> deleteAccount() async {
    final currentUser = await localDataSource.getCurrentUser();
    if (currentUser != null) {
      await localDataSource.deleteRegisteredUser(currentUser.loginId);
      await secureLocalDataSource.deleteUserPassword(currentUser.loginId);
    }

    await secureLocalDataSource.clearAuthTokens();
    await secureLocalDataSource.deleteUserNumericId();
    await localDataSource.clearUser();
  }
}
