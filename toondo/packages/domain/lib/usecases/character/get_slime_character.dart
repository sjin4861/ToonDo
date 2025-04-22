import 'package:domain/entities/slime_character.dart';
import 'package:domain/repositories/slime_character_repository.dart';
import 'package:injectable/injectable.dart';

/// 슬라임 캐릭터 정보를 조회하는 UseCase
@injectable
class GetSlimeCharacterUseCase {
  final SlimeCharacterRepository _repository;

  GetSlimeCharacterUseCase(this._repository);

  /// 현재 슬라임 캐릭터 정보를 조회합니다.
  Future<SlimeCharacter> call() async {
    return await _repository.getSlimeCharacter();
  }
}