import 'package:domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> registerUser(String loginId, String password);
  Future<User> login(String loginId, String password);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> checkLoginIdExists(String loginId);
}