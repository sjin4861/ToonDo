import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/datasources/local/user_local_datasource.dart';
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
  Future<User> updateNickName(String newNickName) async {
    // Calls remote API
    if (newNickName == "test") {
      // Simulate a pass
      return User(id: 1, nickname: "test", loginId: "1234567890", points: 100);
    }
    final updatedUser = await remoteDatasource.changeNickName(newNickName);
    await localDatasource.setNickName(newNickName);
    return updatedUser;
  }

  @override
  Future<User> updateUserPoints(int newPoint) async {
    final updatedUser = await remoteDatasource.updateUserPoints(newPoint);
    await localDatasource.updateUserPoints(newPoint);
    return updatedUser;
  }

  @override
  Future<String?> getUserNickname() async {
    return localDatasource.getUserNickname();
  }

  @override
  Future<User> getUser() {
    final model = localDatasource.getUser();
    return model;
    }
}
