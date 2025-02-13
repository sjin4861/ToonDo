import 'package:flutter/foundation.dart';

class SlimeCharacterViewModel extends ChangeNotifier {
  String _animation = 'id';

  String get animation => _animation;

  void setAnimation(String animationName) {
    _animation = animationName;
    notifyListeners();
  }

  void setIdle() => setAnimation('id');
  void setBlink() => setAnimation('eye');
  void setAngry() => setAnimation('angry');
  void setHappy() => setAnimation('happy');
  void setShine() => setAnimation('shine');
  void setMelt() => setAnimation('melt');

  Future<void> playSequentialAnimations() async {
    final animations = ['id', 'eye', 'angry', 'happy', 'shine', 'melt'];
    for (var anim in animations) {
      setAnimation(anim);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setIdle();
  }
}
