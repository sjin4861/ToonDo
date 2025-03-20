import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String phoneNumber, String password) {
    return repository.login(phoneNumber, password);
  }
}
