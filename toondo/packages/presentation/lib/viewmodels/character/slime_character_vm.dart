// lib/presentation/viewmodels/character/slime_character_vm.dart
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/usecases/character/slime_on_gesture.dart';

@injectable
class SlimeCharacterViewModel extends ChangeNotifier {
  final SlimeOnGestureUseCase _gestureUC;
  SlimeCharacterViewModel(this._gestureUC);

  /// 현재 재생중인 애니메이션 key
  final ValueNotifier<String> animationKey = ValueNotifier('id');

  /* 제스처 API – 위젯에서 호출 */
  Future<void> onGesture(Gesture g) async {
    final resp = await _gestureUC(g);
    animationKey.value = resp.animationKey;
  }

  @override
  void dispose() {
    animationKey.dispose();
    super.dispose();
  }
}
