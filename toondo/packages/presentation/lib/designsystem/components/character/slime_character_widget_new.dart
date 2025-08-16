// lib/presentation/widgets/character/slime_character_widget.dart
import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/gesture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:flutter/services.dart' show rootBundle;

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

class _SlimeCharacterWidgetState extends State<SlimeCharacterWidget> {
  final double _scale = 1.6;
  Offset? _dragStart;

  @override
  void initState() {
    super.initState();
    _debugPrintAnimationNames();
  }

  Future<void> _debugPrintAnimationNames() async {
    await RiveFile.initialize();
    final data = await rootBundle.load(Assets.rives.gifYellowSlime.path);
    final file = RiveFile.import(data);
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
        // 단순화: 깜빡임 로직 제거, 제스처 애니메이션만 처리
        String key = animKey;
        
        // Build controller with fallback if animation not found
        late RiveAnimationController controller;
        try {
          if (key == 'id') {
            controller = SimpleAnimation('id', autoplay: true);
          } else {
            controller = OneShotAnimation(
              key,
              autoplay: true,
              mix: 0.2, // mix 값을 낮춰서 더 부드러운 전환
              onStop: () {
                // ViewModel에만 애니메이션 완료 알림 (즉시 idle로 복귀하지 않음)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    final vm = context.read<SlimeCharacterViewModel>();
                    vm.onAnimationCompleted(key);
                  }
                });
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
            // 드래그는 화나는 애니메이션만 실행
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
