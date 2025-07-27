import 'package:domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class CheckLoginIdExistsUseCase {
  final AuthRepository repository;

  CheckLoginIdExistsUseCase(this.repository);

  Future<bool> call(String loginId) async {
    return await repository.checkLoginIdExists(loginId);
  }
}