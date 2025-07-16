import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePhoneNumberUseCase {
  final UserRepository repository;
  UpdatePhoneNumberUseCase(this.repository);

  Future<User> call(String newPhoneNumber) {
    return repository.updatePhoneNumber(newPhoneNumber);
  }
}
