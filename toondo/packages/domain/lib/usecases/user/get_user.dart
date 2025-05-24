import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  final UserRepository repository;
  GetUserUseCase(this.repository);

  Future<User> call() async {
    return repository.getUser();
  }
}
