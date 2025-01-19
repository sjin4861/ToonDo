// lib/widgets/character/chat_bubble.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_with_alarm/services/gpt_service.dart';

class ChatBubble extends StatefulWidget {
  final String? nickname; // 사용자의 닉네임
  final GptService gptService; // GPT 호출에 필요한 객체

  const ChatBubble({
    Key? key,
    required this.nickname,
    required this.gptService,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  // 현재 말풍선에 표시될 메시지
  String _currentMessage = '';

  @override
  void initState() {
    super.initState();
    // 초기 메시지 (간단한 인사말 등)
    _currentMessage = '안녕, ${widget.nickname}! 오늘 하루 어때?';
  }

  // 말풍선 탭 시 GPT 호출
  Future<void> _handleBubbleTap() async {
    final gptResponse = await widget.gptService.getSlimeResponse();
    if (gptResponse != null) {
      setState(() {
        _currentMessage = gptResponse.replaceFirst('슬라임: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleBubbleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 말풍선 배경
          SvgPicture.asset(
            'assets/icons/speech_bubble.svg',
            width: 200,
            height: 45,
          ),
          // 텍스트가 길어지면 여러 줄로 표시되도록 Text 위젯을 Wrap하거나 Flexible로 감싸기
          Container(
            width: 180, // 약간 여유있게 내부 패딩 고려 (200보다 약간 작게)
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _currentMessage,
              style: const TextStyle(
                color: Color(0xFF605956),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // 최대 2줄로 표시 (필요에 따라 조절)
              overflow: TextOverflow.ellipsis, // 내용이 넘으면 줄임표 표시
            ),
          ),
        ],
      ),
    );
  }
}