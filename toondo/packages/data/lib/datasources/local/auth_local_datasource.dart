import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';

class AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSource(this.userBox);

  Future<void> cacheUser(UserModel user) async {
    await userBox.put('currentUser', user);
  }
}
