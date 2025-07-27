import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String loginId, String password) {
    return repository.login(loginId, password);
  }
}
