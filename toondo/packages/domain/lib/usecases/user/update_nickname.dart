import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNickNameUseCase {
  final UserRepository repository;
  UpdateNickNameUseCase(this.repository);

  Future<User> call(User user, String newNickName) {
    return repository.updateNickName(user, newNickName);
  }
}
