import 'package:domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAccountUseCase {
  final AuthRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteAccount();
  }
}
