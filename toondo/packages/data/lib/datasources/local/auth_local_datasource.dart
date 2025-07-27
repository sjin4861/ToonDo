import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSource(this.userBox);

  Future<void> cacheUser(UserModel user) async {
    await userBox.put('currentUser', user);
  }

  Future<void> clearUser() async {
    await userBox.delete('currentUser');
  }
}
