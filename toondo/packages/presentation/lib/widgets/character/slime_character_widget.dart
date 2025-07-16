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
        // ViewModel에서 애니메이션이 실행 중인지 확인
        final vm = context.read<SlimeCharacterViewModel>();
        if (vm.animationKey.value != 'id') {
          // 다른 애니메이션이 실행 중이면 깜빡임 건너뛰기
          print('[SlimeCharacterWidget] 애니메이션 실행 중이므로 깜빡임 건너뛰기');
          _scheduleBlink();
          return;
        }
        
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
    final childWidget = ValueListenableBuilder<String>(
      valueListenable: vm.animationKey,
      builder: (context, animKey, _) {
        // 애니메이션 우선순위: 제스처 애니메이션 > 깜빡임 애니메이션
        String key;
        if (animKey != 'id') {
          // 제스처 애니메이션이 실행 중이면 우선
          key = animKey;
          // 제스처 애니메이션 중에는 깜빡임 중단
          if (_localAnimKey != null) {
            setState(() => _localAnimKey = null);
            _isBlinking = false;
          }
        } else {
          // idle 상태에서만 깜빡임 허용
          key = _localAnimKey ?? animKey;
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
                // ViewModel에 애니메이션 완료 알림
                final vm = context.read<SlimeCharacterViewModel>();
                vm.onAnimationCompleted(key);
                
                // 애니메이션이 끝나면 즉시 idle로 복귀
                if (_localAnimKey == null) {
                  vm.animationKey.value = 'id';
                }
              },
            );
          }
        } catch (e) {
          controller = SimpleAnimation('id', autoplay: true);
        }
        
        final controllers = [controller];
        return Transform.scale(
          scale: _scale,
          child: Opacity(
            opacity: 0.9,
            child: SizedBox(
              width: 195, // 30% 증가 (150 → 195)
              height: 195, // 30% 증가 (150 → 195)
              child: Assets.rives.gifYellowSlime.rive(
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
          ),
        );
      },
    );

    // enableGestures가 true일 때만 GestureDetector로 감싸기
    if (widget.enableGestures) {
      return GestureDetector(
        onTap: () => vm.onGesture(Gesture.tap),
        onDoubleTap: () => vm.onGesture(Gesture.doubleTap),
        onLongPress: () => vm.onGesture(Gesture.longPress),
        // ───────── drag 인식 ─────────
        onPanStart:  (details) {
          _dragStart = details.localPosition;
        },
        onPanUpdate: (details) {
          // 드래그 업데이트
        },
        onPanEnd:    (details) {
          if (_dragStart == null) {
            return;
          }
          
          // 속도 기반 감지
          final velocityDistance = (details.velocity.pixelsPerSecond.dx).abs() + (details.velocity.pixelsPerSecond.dy).abs();
          
          // 거리 기반 감지 (현재 위치와 시작 위치의 차이)
          final currentPosition = details.globalPosition;
          final startPosition = _dragStart!;
          final dragDistance = (currentPosition.dx - startPosition.dx).abs() + (currentPosition.dy - startPosition.dy).abs();
          
          // 매우 낮은 기준으로 설정 (조금만 움직여도 감지)
          const minVelocity = 50;      // 매우 낮은 기준 (기존 500 → 50)
          const minDragDistance = 5;   // 5픽셀만 움직여도 드래그로 감지
          
          if (velocityDistance > minVelocity || dragDistance > minDragDistance) {
            vm.onGesture(Gesture.drag);
          }
          _dragStart = null;
        },
        behavior: HitTestBehavior.translucent,
        child: childWidget,
      );
    } else {
      return childWidget;
    }
  }
}
