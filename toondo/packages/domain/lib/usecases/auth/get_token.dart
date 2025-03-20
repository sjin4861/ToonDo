import 'package:domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTokenUseCase {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.getToken();
  }
}
