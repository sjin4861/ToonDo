import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl(this.secureStorage, this.userBox);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
    await userBox.delete('currentUser');
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put('currentUser', user);
  }

  @override
  UserModel? getCachedUser() {
    return userBox.get('currentUser');
  }
}