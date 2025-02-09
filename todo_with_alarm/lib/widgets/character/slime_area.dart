// lib/widgets/character/slime_area.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/viewmodels/character/slime_character_viewmodel.dart';
import 'package:todo_with_alarm/widgets/character/chat_bubble.dart';
import 'package:todo_with_alarm/services/gpt_service.dart';
import 'package:todo_with_alarm/widgets/character/slime_character_widget.dart';

class SlimeArea extends StatelessWidget {
  final String userNickname;
  final GptService gptService;
  final SlimeCharacterViewModel characterViewModel;

  const SlimeArea({
    Key? key,
    required this.userNickname,
    required this.gptService,
    required this.characterViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              width: 500, // 기존 150에서 225으로 증가
              height: 500, // 기존 150에서 225으로 증가
              initialAnimationName : 'id',
              viewModel: characterViewModel,
            ),
          ),
        ),
        // (2) 말풍선
        Positioned(
          left: (screenWidth / 2) - 175,
          bottom: 180, // 기존 180에서 270으로 증가
          child: ChatBubble(
            nickname: userNickname,
            gptService: gptService,
          ),
        ),
      ],
    );
  }
}