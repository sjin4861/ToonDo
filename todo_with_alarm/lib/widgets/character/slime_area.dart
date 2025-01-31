// lib/widgets/character/slime_area.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/widgets/character/chat_bubble.dart';
import 'package:todo_with_alarm/services/gpt_service.dart';
import 'package:todo_with_alarm/widgets/character/slime_character_widget.dart';

class SlimeArea extends StatelessWidget {
  final String userNickname;
  final GptService gptService;

  const SlimeArea({
    Key? key,
    required this.userNickname,
    required this.gptService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // (1) 슬라임 캐릭터
        Positioned(
          left: (screenWidth / 2) - 150, 
          bottom: -50,
          child: const SizedBox(
            width: 300,
            height: 300,
            child: SlimeCharacterWidget(
              width: 300,
              height: 300,
            ),
          ),
        ),
        // (2) 말풍선
        Positioned(
          left: (screenWidth / 2) - 125,
          bottom: 180, 
          child: ChatBubble(
            nickname: userNickname,
            gptService: gptService,
          ),
        ),
      ],
    );
  }
}