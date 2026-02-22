import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/datasources/local/user_local_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:data/datasources/local/secure_local_datasource.dart';
import 'package:data/constants.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> updateNickName(String newNickName) async {
    if (Constants.remoteApiEnabled) {
      final remoteNickname = await remoteDatasource.changeNickName(newNickName);
      final currentUser = await localDatasource.getUser();
      final updatedUser = User(
        id: currentUser.id,
        nickname: remoteNickname,
        loginId: currentUser.loginId,
        createdAt: currentUser.createdAt,
      );
      await localDatasource.saveUser(updatedUser);
      return updatedUser;
    }

    final currentUser = await localDatasource.getUser();
    final updatedUser = User(
      id: currentUser.id,
      nickname: newNickName,
      loginId: currentUser.loginId,
      createdAt: currentUser.createdAt,
    );
    await localDatasource.saveUser(updatedUser);
    return updatedUser;
  }

  @override
  Future<String?> getUserNickname() async {
    return localDatasource.getUserNickname();
  }

  @override
  Future<User> getUser() async {
    if (Constants.remoteApiEnabled) {
      try {
        final remoteUser = await remoteDatasource.getUserMe();
        await localDatasource.saveUser(remoteUser);
        return remoteUser;
      } catch (_) {
        return await localDatasource.getUser();
      }
    }

    return await localDatasource.getUser();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    if (Constants.remoteApiEnabled) {
      await remoteDatasource.updatePassword(newPassword);
      return;
    }

    final currentUser = await localDatasource.getUser();
    await GetIt.I<SecureLocalDataSource>().saveUserPassword(
      currentUser.loginId,
      newPassword,
    );
  }

  @override
  Future<void> deleteAccount() async {
    if (Constants.remoteApiEnabled) {
      await remoteDatasource.deleteAccount();
      await localDatasource.clearUser();
      return;
    }

    final currentUser = await localDatasource.getUser();
    await GetIt.I<SecureLocalDataSource>().deleteUserPassword(
      currentUser.loginId,
    );
    await localDatasource.clearUser();
  }
}
