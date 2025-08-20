import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
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
    const w = 300.0, shadowDx = -10.0, shadowDy = 32.0, shadowScale = 0.94;
    final viewModel = context.watch<SlimeCharacterViewModel>();

    return SizedBox(
      width: w,
      height: w + 50, // 말풍선을 위한 공간은 유지하되 높이 조정
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 그림자
          Transform.translate(
            offset: const Offset(shadowDx, shadowDy),
            child: Transform.scale(
              scale: shadowScale,
              child: Assets.images.imgHomeShadowPng.image(width: w - 122),
            ),
          ),
          
          // 슬라임 캐릭터
          Positioned(
            bottom: 30, // 원래 위치로 되돌림 (40에서 20으로)
            child: GestureDetector(
              onTap: () {
                // 탭할 때마다 클릭 반응 메시지
                viewModel.onSlimeTapped();
              },
              onLongPress: () {
                // 길게 누르면 동기부여 메시지와 애니메이션
                viewModel.onSlimeLongPressed();
              },
              onDoubleTap: () {
                // 더블 탭하면 점프 애니메이션과 시간대별 인사말
                viewModel.onSlimeDoubleTapped();
              },
              // 드래그 이벤트 추가
              onPanStart: (details) {
                // 드래그 시작
              },
              onPanUpdate: (details) {
                // 드래그 중
              },
              onPanEnd: (details) {
                final distance = (details.velocity.pixelsPerSecond.dx).abs() + (details.velocity.pixelsPerSecond.dy).abs();
                const minVelocity = 100; // 매우 낮은 임계값으로 설정 (조금만 드래그해도 감지)
                if (distance > minVelocity) {
                  viewModel.onSlimeDragged();
                } else {
                  // 속도가 느려도 드래그가 감지되면 화나는 애니메이션 실행
                  viewModel.onSlimeDragged();
                }
              },
              child: SizedBox(
                width: 260, // 크기는 유지 (280에서 260으로 조정)
                height: 260, // 크기는 유지 (280에서 260으로 조정)
                child: const SlimeCharacterWidget(
                  enableGestures: false, // 제스처를 비활성화하여 SlimeArea에서만 처리
                  showDebugInfo: false, // 디버그 정보 비활성화
                  initialAnimationName: 'id',
                ),
              ),
            ),
          ),
          
          // 말풍선
          if (viewModel.showGreeting &&
              viewModel.animationKey.value != 'jump')
            Positioned(
              bottom: 270,
              child: SpeechBubble(
                text: viewModel.currentGreeting!,
                maxWidth: 240,
              ),
            )
        ],
      ),
    );
  }
}
