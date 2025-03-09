import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/user.dart';

class UserLocalDatasource {
  Box<UserModel> userBox = Hive.box<UserModel>('users');

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    // Assuming user.id is unique and non-null.
    await userBox.put('currentUser', model);
  }

  Future<String?> getUserNickname() async {
    final model = userBox.get('currentUser');
    return model?.getNickname();
  }

  Future<void> updateUserPoints(int newPoint) async {
    final model = userBox.get('currentUser');
    if (model != null) {
      model.points += newPoint;
      await userBox.put('currentUser', model);
    }
  }

  Future<void> setNickName(String newNickName) async {
    final model = userBox.get('currentUser');
    if (model != null) {
      model.nickname = newNickName;
      await userBox.put('currentUser', model);
    }
  }

  // ...other local methods if needed...
}
