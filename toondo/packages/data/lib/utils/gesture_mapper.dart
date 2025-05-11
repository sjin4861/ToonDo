import 'package:domain/entities/gesture.dart';

class GestureMapper {
  const GestureMapper();
  String toAnimationKey(Gesture g) {
    switch (g) {
      case Gesture.tap:
        return 'tap';
      case Gesture.doubleTap:
        return 'double_tap';
      case Gesture.longPress:
        return 'press';
      case Gesture.drag:
        return 'drag';
      default:
        return 'id';
    }
  }
}