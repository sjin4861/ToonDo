import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SlimeOnGestureUseCase {
  final SlimeRepository _repo;
  SlimeOnGestureUseCase(this._repo);

  Future<SlimeResponse> call(Gesture gesture) =>
      _repo.processGesture(gesture);
}
