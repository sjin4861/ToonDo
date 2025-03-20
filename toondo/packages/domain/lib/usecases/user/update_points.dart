import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserPointsUseCase {
  final UserRepository repository;
  UpdateUserPointsUseCase(this.repository);

  Future<User> call(int newPoint) {
    return repository.updateUserPoints(newPoint);
  }
}
