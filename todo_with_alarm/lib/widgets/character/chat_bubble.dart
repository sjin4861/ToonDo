// lib/widgets/character/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBubble extends StatefulWidget {
  final String? nickname; // 사용자의 닉네임
  const ChatBubble({Key? key, required this.nickname}) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  // 말풍선에 나타날 메시지 리스트
  late List<String> _messages;
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    // 첫 메시지에는 닉네임을 포함한 인사말로 시작
    _messages = [
      '안녕, ${widget.nickname}! 오늘 하루 어때?',
      '무슨 일이 있었어? 이야기해줘!',
      '내가 도와줄 수 있는 일이 있을까?',
      '오늘의 할 일은 모두 끝냈어?',
      '기분 좋은 하루 보내고 있어?',
    ];
  }

  void _nextMessage() {
    setState(() {
      _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextMessage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 말풍선 배경 (SVG 이미지 사용 예)
          SvgPicture.asset(
            'assets/icons/speech_bubble.svg',
            width: 200,
            height: 45,
          ),
          // 메시지 텍스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _messages[_currentMessageIndex],
              style: const TextStyle(
                color: Color(0xFF605956),
                fontSize: 12,
                fontFamily: 'Nanum Pen Script',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}