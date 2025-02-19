import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/datasources/local/user_local_datasource.dart';
import 'package:domain/usecases/auth/get_token.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> updateNickName(User user, String newNickName) async {
    // Calls remote API
    final updatedUser = await remoteDatasource.changeNickName(
      user,
      newNickName,
    );
    await localDatasource.saveUser(updatedUser);
    return updatedUser;
  }

  @override
  Future<User> updateUserPoints(User user, int delta) async {
    final updatedUser = await remoteDatasource.updateUserPoints(user, delta);
    await localDatasource.saveUser(updatedUser);
    return updatedUser;
  }

  @override
  Future<String?> getUserNickname() async {
    return localDatasource.getUserNickname();
  }
}
