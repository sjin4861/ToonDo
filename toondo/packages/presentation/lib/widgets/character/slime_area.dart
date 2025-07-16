import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:presentation/widgets/character/slime_character_widget.dart';
import 'package:presentation/widgets/character/speech_bubble.dart';
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

  /// 메시지 내용에 따라 말풍선 색상 결정
  Color _getBubbleColor(String message) {
    // 화나는 메시지
    if (message.contains('아야') || message.contains('그만') || message.contains('간지러워') || message.contains('아프다') || message.contains('😠') || message.contains('😤') || message.contains('😡') || message.contains('💢')) {
      return const Color(0xFFD32F2F); // 빨간색 (화남)
    }
    // 클릭 반응 메시지
    else if (message.contains('클릭') || message.contains('터치') || message.contains('놀고') || message.contains('친구')) {
      return const Color(0xFFFF5722); // 빨간색 계열
    }
    // 축하 메시지
    else if (message.contains('축하') || message.contains('완벽') || message.contains('최고') || message.contains('🎉') || message.contains('🏆')) {
      return const Color(0xFFFF9800); // 주황색
    }
    // 격려 메시지
    else if (message.contains('괜찮아') || message.contains('실수') || message.contains('천천히') || message.contains('믿어')) {
      return const Color(0xFF9C27B0); // 보라색
    }
    // 동기부여 메시지
    else if (message.contains('할 수 있어') || message.contains('포기하지') || message.contains('꿈을') || message.contains('💪') || message.contains('🚀')) {
      return const Color(0xFFE91E63); // 핑크색
    }
    // 시간대 인사말
    else if (message.contains('아침') || message.contains('점심') || message.contains('저녁') || message.contains('☀️') || message.contains('🌙')) {
      return const Color(0xFF2196F3); // 파란색
    }
    // 상호작용 메시지
    else if (message.contains('도와줄게') || message.contains('집중력') || message.contains('쉬어') || message.contains('수고') || message.contains('스트레칭') || message.contains('물')) {
      return const Color(0xFF00BCD4); // 청록색
    }
    // 기본 친근한 인사말
    else {
      return const Color(0xFF4CAF50); // 초록색
    }
  }

  @override
  Widget build(BuildContext context) {
    const w = 300.0, shadowDx = -10.0, shadowDy = 24.0, shadowScale = 0.96;
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
              child: Assets.images.imgHomeShadowPng.image(width: w - 120),
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
          if (viewModel.showGreeting && viewModel.currentGreeting != null)
            Positioned(
              bottom: 260, // 말풍선을 더 위로 올림 (230 → 260)
              child: SpeechBubble(
                message: viewModel.currentGreeting!,
                backgroundColor: _getBubbleColor(viewModel.currentGreeting!),
                textColor: Colors.white,
                maxWidth: 240, // 말풍선 크기는 유지
                displayDuration: const Duration(seconds: 5), // 표시 시간 유지
                onTap: () {
                  viewModel.hideGreeting();
                },
              ),
            ),
        ],
      ),
    );
  }
}
