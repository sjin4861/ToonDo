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
  final double _scale = 1.8;
  Offset? _dragStart;
  RiveAnimationController? _currentController;
  String _currentAnimationKey = 'id';

  @override
  void initState() {
    super.initState();
    _debugPrintAnimationNames();
  }

  @override
  void dispose() {
    _currentController?.dispose();
    super.dispose();
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
        // 애니메이션 키가 변경되었을 때만 컨트롤러 재생성
        if (_currentAnimationKey != animKey) {
          _currentController?.dispose();
          _currentAnimationKey = animKey;
          
          // Build controller with fallback if animation not found
          try {
            if (animKey == 'id') {
              _currentController = SimpleAnimation('id', autoplay: true);
            } else {
              _currentController = OneShotAnimation(
                animKey,
                autoplay: true,
                mix: 0.5, // 적절한 mix 값으로 조정 (너무 높으면 부자연스러울 수 있음)
                onStop: () {
                  // onStop에서는 애니메이션 보호만 해제, idle 복귀는 하지 않음
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      final vm = context.read<SlimeCharacterViewModel>();
                      vm.onAnimationStopped(animKey);
                    }
                  });
                },
              );
            }
          } catch (e) {
            _currentController = SimpleAnimation('id', autoplay: true);
          }
        }
        
        final controllers = _currentController != null ? [_currentController!] : <RiveAnimationController>[];
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
                  if (animKey != 'id') animKey,
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
