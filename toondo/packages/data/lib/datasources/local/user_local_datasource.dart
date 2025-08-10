import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';
@LazySingleton()
class UserLocalDatasource {
  Box<UserModel> userBox;

  UserLocalDatasource(this.userBox);

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await userBox.put('currentUser', model);
  }

  Future<String?> getUserNickname() async {
    final model = userBox.get('currentUser');
    return model?.getNickname();
  }

  Future<User> getUser() async {
    final model = userBox.get('currentUser');
    if (model == null) {
      final defaultUser = User(
        id: 1,
        nickname: '사용자',
        loginId: 'default_user',
      );
      await saveUser(defaultUser);
      return defaultUser;
    }
    return model.toEntity();
  }

  Future<void> setNickName(String newNickName) async {
    final model = userBox.get('currentUser');
    if (model != null) {
      model.nickname = newNickName;
      await userBox.put('currentUser', model);
    } else {
      final newUser = User(
        id: 1,
        nickname: newNickName,
        loginId: 'default_user',
      );
      await saveUser(newUser);
    }
  }

  Future<void> clearUser() async {
    await userBox.delete('currentUser');
  }
}