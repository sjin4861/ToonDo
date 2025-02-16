import 'package:domain/repositories/auth_repository.dart';
import 'package:data/datasources/auth_remote_datasource.dart';
import 'package:data/datasources/auth_local_datasource.dart';
import 'package:domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<User> registerUser(String phoneNumber, String password) async {
    final userModel = await remoteDataSource.registerUser(phoneNumber, password);
    await localDataSource.saveToken(userModel.token);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<User> login(String phoneNumber, String password) async {
    final userModel = await remoteDataSource.login(phoneNumber, password);
    await localDataSource.saveToken(userModel.token);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}