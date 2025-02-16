import 'package:domain/repositories/user_repository.dart';
import 'package:domain/entities/user.dart';

class GetCurrentUserUseCase {
  final UserRepository userRepository;

  GetCurrentUserUseCase(this.userRepository);

  User? call() {
    return userRepository.getCurrentUser();
  }
}
