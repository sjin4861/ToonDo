import 'package:domain/entities/user.dart';

abstract class UserRepository {
  Future<User> updateNickName(String newNickName);
  Future<User> updateUserPoints(int delta);
  Future<String?> getUserNickname();
  // ...any other methods...
}
