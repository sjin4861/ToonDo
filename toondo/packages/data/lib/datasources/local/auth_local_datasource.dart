import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl(this.userBox);

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put('currentUser', user);
  }

  @override
  UserModel? getCachedUser() {
    return userBox.get('currentUser');
  }
}
