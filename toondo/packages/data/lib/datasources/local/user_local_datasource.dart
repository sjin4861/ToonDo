import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';
@LazySingleton()
class UserLocalDatasource {
  Box<UserModel> userBox;
  static const String _currentUserKey = 'currentUser';
  static const String _userKeyPrefix = 'user_';

  UserLocalDatasource(this.userBox);

  String _userKey(String loginId) => '$_userKeyPrefix$loginId';

  UserModel _clone(UserModel model) {
    return UserModel.fromJson(model.toJson());
  }

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await userBox.put(_currentUserKey, _clone(model));
    await userBox.put(_userKey(user.loginId), _clone(model));
  }

  Future<String?> getUserNickname() async {
    final model = userBox.get(_currentUserKey);
    return model?.getNickname();
  }

  Future<User> getUser() async {
    final model = userBox.get(_currentUserKey);
    if (model == null) {
      final defaultUser = User(
        id: 1,
        nickname: '사용자',
        loginId: 'default_user',
        createdAt: DateTime.now(),
      );
      await saveUser(defaultUser);
      return defaultUser;
    }
    return model.toEntity();
  }

  Future<void> setNickName(String newNickName) async {
    final model = userBox.get(_currentUserKey);
    if (model != null) {
      final updated = _clone(model)..nickname = newNickName;
      await userBox.put(_currentUserKey, _clone(updated));
      await userBox.put(_userKey(updated.loginId), _clone(updated));
    } else {
      final newUser = User(
        id: 1,
        nickname: newNickName,
        loginId: 'default_user',
        createdAt: DateTime.now(),
      );
      await saveUser(newUser);
    }
  }

  Future<void> clearUser() async {
    await userBox.delete(_currentUserKey);
  }
}