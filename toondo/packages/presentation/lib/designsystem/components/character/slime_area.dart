import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/designsystem/components/character/slime_character_widget.dart';
import 'package:presentation/designsystem/components/character/speech_bubble.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:provider/provider.dart';

class SlimeArea extends StatelessWidget {
  const SlimeArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.I<SlimeCharacterViewModel>()
        ..startAutoGreeting()
        ..scheduleInitialGreeting(),
      child: const _SlimeStack(),
    );
  }
}

class _SlimeStack extends StatelessWidget {
  const _SlimeStack();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SlimeCharacterViewModel>();

    // 반응형 치수
    final double w = 300.w;
    final double shadowDx = (-10).w;
    final double shadowDy = 32.h;
    const double shadowScale = 0.94;

    final double slimeSize = 260.w;
    final double slimeBottom = 30.h;

    final double bubbleMaxWidth = 240.w;
    final double bubbleBottom = 270.h;

    final double shadowImgWidth = w - 122.w;

    return SizedBox(
      width: w,
      height: w + 50.h, // 말풍선 영역 확보 유지
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 그림자
          Transform.translate(
            offset: Offset(shadowDx, shadowDy),
            child: Transform.scale(
              scale: shadowScale,
              child: Assets.images.imgHomeShadowPng.image(width: shadowImgWidth),
            ),
          ),

          // 슬라임 캐릭터
          Positioned(
            bottom: slimeBottom,
            child: GestureDetector(
              onTap: viewModel.onSlimeTapped,
              onLongPress: viewModel.onSlimeLongPressed,
              onDoubleTap: viewModel.onSlimeDoubleTapped,
              onPanStart: (_) {
                // 드래그 시작
              },
              onPanUpdate: (_) {
                // 드래그 중
              },
              onPanEnd: (details) {
                final distance = details.velocity.pixelsPerSecond.dx.abs()
                    + details.velocity.pixelsPerSecond.dy.abs();
                const minVelocity = 100; // 낮은 임계값
                if (distance > minVelocity) {
                  viewModel.onSlimeDragged();
                } else {
                  viewModel.onSlimeDragged();
                }
              },
              child: SizedBox(
                width: slimeSize,
                height: slimeSize,
                child: const SlimeCharacterWidget(
                  enableGestures: false, // 제스처는 SlimeArea에서만 처리
                  showDebugInfo: false,
                  initialAnimationName: 'id',
                ),
              ),
            ),
          ),

          // 말풍선 (SpeechBubble 내부가 AppTypography/색상 처리)
          if (viewModel.showGreeting && viewModel.animationKey.value != 'jump')
            Positioned(
              bottom: bubbleBottom,
              child: SpeechBubble(
                text: viewModel.currentGreeting ?? '',
                maxWidth: bubbleMaxWidth,
              ),
            ),
        ],
      ),
    );
  }
}
