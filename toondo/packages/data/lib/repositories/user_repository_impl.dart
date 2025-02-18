import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/datasources/local/user_local_datasource.dart';
import 'package:domain/usecases/auth/get_token.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;
  final GetTokenUseCase getTokenUseCase;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.getTokenUseCase,
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
    // 토큰을 토대로 user를 찾는다
    final token = await getTokenUseCase();
    return localDatasource.getUserNickname(token);
  }
}
