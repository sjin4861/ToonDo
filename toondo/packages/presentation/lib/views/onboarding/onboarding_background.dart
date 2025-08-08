import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class OnboardingBackground extends StatelessWidget {
  final int step;

  const OnboardingBackground({super.key, required this.step});

  String getAnimationName(int step) {
    switch (step) {
      case 1:
        return 'shine';
      case 2:
        return 'jump';
      case 3:
        return 'shine';
      case 4:
        return 'jump';
      default:
        return 'shine';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String animationName = getAnimationName(step);
    return Stack(
      children: [
        // 하얀 타원 배경
        Positioned(
          left: -79.64,
          top: 538.34,
          child: Container(
            width: 534.28,
            height: 483.32,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.38, -0.93),
                end: Alignment(-0.38, 0.93),
                colors: [
                  Color.fromRGBO(252, 241, 190, 1),
                  Color.fromRGBO(249, 228, 123, 1),
                ],
              ),
              shape: OvalBorder(),
            ),
          ),
        ),
        // 캐릭터 및 그림자
        Positioned(
          top: 475,
          left: 120,
          child:Transform.scale(
            scale: 3.6, // 2배~4배 등 실험
            child: SizedBox(
              width: 174,
              height: 140,
              child: rive.RiveAnimation.asset(
                Assets.rives.gifYellowSlime.path,
                fit: BoxFit.contain,
                useArtboardSize: true,
                speedMultiplier: 0.5,
                animations: [animationName]
              ),
            ),
          )
        ),
      ],
    );
  }
}
