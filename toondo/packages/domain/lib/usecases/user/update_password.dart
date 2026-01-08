import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePasswordUseCase {
  final UserRepository repository;
  UpdatePasswordUseCase(this.repository);

  Future<void> call(String newPassword) {
    return repository.updatePassword(newPassword);
  }
}
