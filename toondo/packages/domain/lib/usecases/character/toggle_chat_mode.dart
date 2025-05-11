import 'package:domain/repositories/slime_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleChatModeUseCase {
  final SlimeRepository _repo;
  ToggleChatModeUseCase(this._repo);

  Future<void> call(bool enable) => _repo.setChatEnabled(enable);
}