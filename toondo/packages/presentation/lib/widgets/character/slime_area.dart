import 'dart:ui';
import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/slime_character_vm.dart';
import 'package:presentation/widgets/character/slime_character_widget.dart';
import 'package:provider/provider.dart';

class SlimeArea extends StatelessWidget {
  const SlimeArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.I<SlimeCharacterViewModel>(),
      child: const _SlimeStack(),
    );
  }
}

class _SlimeStack extends StatelessWidget {
  const _SlimeStack();

  @override
  Widget build(BuildContext context) {
    const w = 300.0, shadowDy = 25.0, shadowScale = 1.0;

    return SizedBox(
      width: w,
      height: w + 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, shadowDy),
            child: Transform.scale(
              scale: shadowScale,
              child: Assets.images.imgHomeShadowPng.image(width: w),
            ),
          ),
          const SlimeCharacterWidget(
            enableGestures: true,
            showDebugInfo: true, 
            initialAnimationName: 'idle',
          ),
        ],
      ),
    );
  }
}
