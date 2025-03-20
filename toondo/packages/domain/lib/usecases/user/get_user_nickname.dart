import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserNicknameUseCase {
  final UserRepository repository;
  GetUserNicknameUseCase(this.repository);

  Future<String?> call() async {
    return repository.getUserNickname();
  }
}
