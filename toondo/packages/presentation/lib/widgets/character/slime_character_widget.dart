// lib/presentation/widgets/character/slime_character_widget.dart
import 'dart:async';
import 'dart:math';
import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/gesture.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:get_it/get_it.dart';
import 'package:data/utils/gesture_mapper.dart';

class SlimeCharacterWidget extends StatefulWidget {
  final bool enableGestures;
  final bool showDebugInfo;
  final String initialAnimationName;

  const SlimeCharacterWidget({
    super.key,
    this.enableGestures = true,
    this.showDebugInfo = false,
    required this.initialAnimationName,
  });

  @override
  _SlimeCharacterWidgetState createState() => _SlimeCharacterWidgetState();
}

class _SlimeCharacterWidgetState extends State<SlimeCharacterWidget> with SingleTickerProviderStateMixin {
  final double _scale = 1.0;
  Timer? _blinkTimer;
  bool _isBlinking = false;
  String? _localAnimKey;

  @override
  void initState() {
    super.initState();
    _scheduleBlink();
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final delay = Duration(seconds: 3 + Random().nextInt(4));
    _blinkTimer = Timer(delay, () async {
      if (!_isBlinking) {
        _isBlinking = true;
        setState(() => _localAnimKey = 'eye');
        await Future.delayed(Duration(milliseconds: 300));
        setState(() => _localAnimKey = null);
        _isBlinking = false;
      }
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SlimeCharacterViewModel>();
    return GestureDetector(
      onTap: () => vm.onGesture(Gesture.tap),
      onDoubleTap: () => vm.onGesture(Gesture.doubleTap),
      onLongPress: () => vm.onGesture(Gesture.longPress),
      behavior: HitTestBehavior.translucent,
      child: ValueListenableBuilder<String>(
        valueListenable: vm.animationKey,
        builder: (context, animKey, _) {
          // ignore 'shine' animation, fallback to idle
          final rawKey = _localAnimKey ?? animKey;
          final key = rawKey == 'shine' ? 'id' : rawKey;
          print('[SlimeDebug] renderer effectiveKey=$key');
          // Build controller with fallback if animation not found
          late RiveAnimationController controller;
          try {
            if (key == 'id') {
              controller = SimpleAnimation('id', autoplay: true);
            } else {
              controller = OneShotAnimation(
                key,
                autoplay: true,
                onStop: () {
                  print('[SlimeDebug] OneShot $key stopped, reverting to id');
                  if (_localAnimKey == null) vm.animationKey.value = 'id';
                },
              );
            }
          } catch (e) {
            print('[SlimeDebug] Animation "$key" not found: $e. Falling back to id.');
            controller = SimpleAnimation('id', autoplay: true);
          }
          final controllers = [controller];
          return Transform.scale(
            scale: _scale,
            child: Assets.rives.gifSlime.rive(
              fit: BoxFit.contain,
              controllers: controllers,
            ),
          );
        },
      ),
    );
  }
}
