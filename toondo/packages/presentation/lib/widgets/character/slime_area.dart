import 'dart:ui';
import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/widgets/character/slime_character_widget.dart';

class SlimeArea extends StatelessWidget {
  const SlimeArea({super.key});

  @override
  Widget build(BuildContext context) {
    const double slimeWidth  = 160;   // 실제 Rive 기준
    const double shadowScale = 1.05;  // Rive보다 살짝 넓게
    const double shadowDY    = 28;    // 슬라임 아랫부분 여백

    return SizedBox(
      width: slimeWidth,
      height: slimeWidth + 40, // 그림자 포함 높이
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ① 그림자
          Transform.translate(
            offset: const Offset(0, shadowDY),
            child: Transform.scale(
              scale: shadowScale,
              child: Assets.images.imgHomeShadowPng.image(
                width: slimeWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ② 슬라임 본체
          SlimeCharacterWidget(
            initialAnimationName: 'idle',
            enableGestures: true,
            showDebugInfo: true, // 제스처 디버그 정보 표시
          ),
        ],
      ),
    );
  }
}