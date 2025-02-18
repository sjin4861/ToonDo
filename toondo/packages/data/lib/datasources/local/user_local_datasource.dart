import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/user.dart';

class UserLocalDatasource {
  Box<UserModel> userBox = Hive.box<UserModel>('users');

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    // Assuming user.id is unique and non-null.
    await userBox.put(user.id, model);
  }

  Future<String?> getUserNickname(User user) async {
    final model = userBox.get(user.id);
    return model?.getNickname();
  }

  // ...other local methods if needed...
}
