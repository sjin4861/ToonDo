// lib/widgets/character/slime_area.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
import 'chat_bubble.dart';
import 'package:domain/usecases/gpt/get_slime_response.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final slimeCharacterViewModel = GetIt.instance<SlimeCharacterViewModel>();

    return Stack(
      children: [
        // (1) 슬라임 캐릭터
        Positioned(
          left: (screenWidth / 2) - 250, // 중앙에 위치하도록 조정
          bottom: -170, // 기존 -50에서 90으로 증가
          child: SizedBox(
            width: 500, // 기존 150에서 225으로 증가
            height: 500, // 기존 150에서 225으로 증가
            child: SlimeCharacterWidget(
              width: 500,
              height: 500,
              initialAnimationName: 'id',
              viewModel: slimeCharacterViewModel,
              enableGestures: enableGestures,
              showDebugInfo: showDebugInfo,
            ),
          ),
        ),
        // (2) 말풍선
        Positioned(
          left: (screenWidth / 2) - 175,
          bottom: 180, // 기존 180에서 270으로 증가
          child: ChatBubble(
            nickname: userNickname,
            getSlimeResponseUseCase: getSlimeResponseUseCase,
          ),
        ),
      ],
    );
  }
}