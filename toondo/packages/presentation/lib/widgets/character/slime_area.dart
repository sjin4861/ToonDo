import 'dart:ui';

import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/gpt/get_slime_response.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
import 'chat_bubble.dart';
import 'slime_character_widget.dart';

class SlimeArea extends StatelessWidget {
  final String userNickname;
  final GetSlimeResponseUseCase getSlimeResponseUseCase;
  final bool enableGestures;
  final bool showDebugInfo;

  const SlimeArea({
    Key? key,
    required this.userNickname,
    required this.getSlimeResponseUseCase,
    this.enableGestures = true,
    this.showDebugInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slimeCharacterViewModel = GetIt.instance<SlimeCharacterViewModel>();

    return Stack(
      alignment: Alignment.bottomCenter, // 슬라임은 바닥 기준
      children: [
        // // (0) 그림자
        Positioned(
          bottom: 176,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 2),
              child: Assets.images.imgHomeShadowPng.image(
                width: 184,
                fit: BoxFit.fitWidth
              )
            ),
          ),
        ),
        // (1) 슬라임 캐릭터
        SizedBox(
          child: SlimeCharacterWidget(
            initialAnimationName: 'id',
            viewModel: slimeCharacterViewModel,
            enableGestures: enableGestures,
            showDebugInfo: showDebugInfo,
          ),
        ),
        // (2) 말풍선
        Positioned(
          bottom: 380,
          child: ChatBubble(
            nickname: userNickname,
            getSlimeResponseUseCase: getSlimeResponseUseCase,
          ),
        ),
      ],
    );
  }
}
