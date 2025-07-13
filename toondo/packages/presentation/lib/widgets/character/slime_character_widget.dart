// lib/presentation/widgets/character/slime_character_widget.dart
import 'dart:async';
import 'dart:math';
import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/gesture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:flutter/services.dart' show rootBundle;   // ① 추가

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
  final double _scale = 1.6;
  Timer? _blinkTimer;
  bool _isBlinking = false;
  String? _localAnimKey;
  Offset? _dragStart;

  @override
  void initState() {
    super.initState();
    _scheduleBlink();
    _debugPrintAnimationNames();   // ← 여기서 한 번만
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final delay = Duration(seconds: 3 + Random().nextInt(4));
    _blinkTimer = Timer(delay, () async {
      if (!_isBlinking) {
        _isBlinking = true;
        setState(() => _localAnimKey = 's');
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
  Future<void> _debugPrintAnimationNames() async {
    await RiveFile.initialize();          // ★ 추가
    final data = await rootBundle.load(Assets.rives.gifSlime.path); // ② 문자열 path 그대로
    final file = RiveFile.import(data);                             // ③ 바로 파싱
    final artboard = file.mainArtboard;
    for (final a in artboard.animations) {
      debugPrint('🎞️  Rive animation = ${a.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SlimeCharacterViewModel>();
    return GestureDetector(
      onTap: () => vm.onGesture(Gesture.tap),
      onDoubleTap: () => vm.onGesture(Gesture.doubleTap),
      onLongPress: () => vm.onGesture(Gesture.longPress),
      // ───────── drag 인식 ─────────
      onPanStart:  (details) {
        _dragStart = details.localPosition;
      },
      onPanEnd:    (details) {
      if (_dragStart == null) return;
      final distance =
      (details.velocity.pixelsPerSecond.dx).abs() +
        (details.velocity.pixelsPerSecond.dy).abs();
      // 속도·거리 둘 중 큰 쪽으로 간단 필터 (원하면 거리만 사용해도 OK)
      const minVelocity = 500;      // px/sec 경험값
      if (distance > minVelocity) {
        debugPrint('[SlimeDebug] drag detected, velocity=$distance');
        vm.onGesture(Gesture.drag);
      }
        _dragStart = null;
      },
      behavior: HitTestBehavior.translucent,
      child: ValueListenableBuilder<String>(
        valueListenable: vm.animationKey,
        builder: (context, animKey, _) {
          // ignore 'shine' animation, fallback to idle
          final key = _localAnimKey ?? animKey;
          print('[SlimeDebug] renderer effectiveKey=$key');
          if (key == 'jump') {
            debugPrint('[SlimeDebug] 🚀 JUMP animation triggered!');
          }
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
            child: Opacity(
              opacity: 0.9,
              child:
                Assets.rives.gifYellowSlime.rive(
                  fit: BoxFit.contain,
                  controllers: controllers,
                  alignment: Alignment.center,
                  animations: [
                    if (widget.showDebugInfo) 'debug',
                    if (widget.initialAnimationName.isNotEmpty) widget.initialAnimationName,
                    if (key != 'id') key,
                  ]
                ),
            ),
          );
        },
      ),
    );
  }
}
