import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthLocalDataSource {
  final Box<UserModel> userBox;
  static const String _currentUserKey = 'currentUser';
  static const String _userKeyPrefix = 'user_';

  AuthLocalDataSource(this.userBox);

  UserModel _clone(UserModel user) {
    return UserModel.fromJson(user.toJson());
  }

  Future<void> cacheUser(UserModel user) async {
    await userBox.put(_currentUserKey, _clone(user));
  }

  Future<void> clearUser() async {
    await userBox.delete(_currentUserKey);
  }

  String _userKey(String loginId) => '$_userKeyPrefix$loginId';

  Future<void> saveRegisteredUser(UserModel user) async {
    await userBox.put(_userKey(user.loginId), _clone(user));
  }

  Future<bool> hasRegisteredUser(String loginId) async {
    return userBox.containsKey(_userKey(loginId));
  }

  Future<UserModel?> getRegisteredUser(String loginId) async {
    final found = userBox.get(_userKey(loginId));
    return found == null ? null : _clone(found);
  }

  Future<void> deleteRegisteredUser(String loginId) async {
    await userBox.delete(_userKey(loginId));
  }

  Future<UserModel?> getCurrentUser() async {
    final current = userBox.get(_currentUserKey);
    return current == null ? null : _clone(current);
  }

  Future<int> getNextUserId() async {
    final users = userBox.values.where((u) => u.loginId.isNotEmpty).toList();
    if (users.isEmpty) return 1;
    final maxId = users.map((u) => u.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }
}
