import 'package:domain/repositories/user_repository.dart';
import 'package:domain/entities/user.dart';

class SaveCurrentUserUseCase {
  final UserRepository userRepository;

  SaveCurrentUserUseCase(this.userRepository);

  Future<void> call(User user) async {
    await userRepository.saveCurrentUser(user);
  }
}
