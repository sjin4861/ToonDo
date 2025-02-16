import 'package:domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> registerUser(String phoneNumber, String password);
  Future<User> login(String phoneNumber, String password);
  Future<void> logout();
}