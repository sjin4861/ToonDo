import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:rive_common/rive_audio.dart';
import 'package:common/audio/audio_gate.dart';

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

  // 점프 효과음 소스
  StreamingAudioSource? _jumpSfx;

  @override
  void initState() {
    super.initState();
    _debugPrintAnimationNames();
    _loadJumpSfx();
  }

  Future<void> _loadJumpSfx() async {
    final data = await rootBundle.load('assets/audios/sound_beep.mp3');
    _jumpSfx = AudioGate.loadSource(data.buffer.asUint8List());
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

    // 반응형 임계값 (기기 폭 기준)
    final double minVelocity = 50.w;
    final double minDragDistance = 5.w;

    final childWidget = ValueListenableBuilder<String>(
      valueListenable: vm.animationKey,
      builder: (context, animKey, _) {
        // 애니메이션 키가 변경되었을 때만 컨트롤러 재생성
        if (_currentAnimationKey != animKey) {
          _currentController?.dispose();
          _currentAnimationKey = animKey;

          try {
            if (animKey == 'id') {
              _currentController = SimpleAnimation('id', autoplay: true);
            } else {
              // 점프 애니메이션이면 효과음 재생 (전역 토글 OFF면 게이트가 자동 무시)
              if (animKey == 'jump' && _jumpSfx != null) {
                GetIt.I<AudioGate>().play(_jumpSfx!, 0, 0, 0);
              }

              _currentController = OneShotAnimation(
                animKey,
                autoplay: true,
                mix: 0.5,
                onStop: () {
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

        final controllers =
        _currentController != null ? [_currentController!] : <RiveAnimationController>[];

        return Transform.scale(
          scale: _scale,
          child: Opacity(
            opacity: 0.9,
            child: SizedBox(
              width: 195.w,
              height: 195.w,
              child: Assets.rives.gifYellowSlime.rive(
                fit: BoxFit.contain,
                controllers: controllers,
                alignment: Alignment.center,
                animations: [
                  if (widget.showDebugInfo) 'debug',
                  if (widget.initialAnimationName.isNotEmpty) widget.initialAnimationName,
                  if (animKey != 'id') animKey,
                ],
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
        onPanStart: (details) {
          _dragStart = details.localPosition;
        },
        onPanUpdate: (_) {
          // 드래그 업데이트 필요 시 확장
        },
        onPanEnd: (details) {
          if (_dragStart == null) return;

          // 속도 기반 감지
          final velocity = details.velocity.pixelsPerSecond;
          final velocityDistance = velocity.dx.abs() + velocity.dy.abs();

          // 거리 기반 감지
          final currentPosition = details.globalPosition;
          final startPosition = _dragStart!;
          final dragDistance =
              (currentPosition.dx - startPosition.dx).abs() +
                  (currentPosition.dy - startPosition.dy).abs();

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
