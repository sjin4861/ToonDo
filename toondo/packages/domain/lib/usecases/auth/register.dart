import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> call(String phoneNumber, String password) {
    return repository.registerUser(phoneNumber, password);
  }
}
