import 'package:domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class CheckPhoneNumberExistsUseCase {
  final AuthRepository repository;

  CheckPhoneNumberExistsUseCase(this.repository);

  Future<bool> call(String phoneNumber) async {
    return await repository.checkPhoneNumberExists(phoneNumber);
  }
}
