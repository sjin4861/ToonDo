import 'package:domain/entities/user.dart';

abstract class UserRepository {
  Future<User> updateNickName(User user, String newNickName);
  Future<User> updateUserPoints(User user, int delta);
  Future<String?> getUserNickname();
  // ...any other methods...
}
