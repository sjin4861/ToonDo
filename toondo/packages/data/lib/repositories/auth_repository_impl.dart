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
  Future<User> registerUser(String phoneNumber, String password) async {
    final responseData = await remoteDataSource.registerUser(
      phoneNumber,
      password,
    );
    final token = responseData['token'] as String;
    await secureLocalDataSource.saveToken(token);
    final userModel = UserModel.fromJson(responseData);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<User> login(String phoneNumber, String password) async {
    final responseData = await remoteDataSource.login(phoneNumber, password);
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
}
