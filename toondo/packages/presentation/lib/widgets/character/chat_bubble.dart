import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart'; // 오디오 재생
import 'package:toondo/services/gpt_service.dart';

class ChatBubble extends StatefulWidget {
  final String? nickname; // 사용자 닉네임
  final GptService gptService; // GPT 호출 객체

  const ChatBubble({
    Key? key,
    required this.nickname,
    required this.gptService,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  // 전체 GPT 답변 메시지
  String _targetMessage = '';
  // 타이핑 중 현재까지 표시한 텍스트
  String _displayedMessage = '';

  // 오디오 플레이어
  late final AudioPlayer _audioPlayer;

  // 타이핑용 Timer
  Timer? _typingTimer;

  // 한 글자씩 나타날 간격 (ms)
  final Duration _typeInterval = const Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // 오디오 재생 모드를 stop으로 설정하면 재생 완료 후 자동으로 중단됨
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // 초기 간단한 인삿말
    _startTyping('안녕, ${widget.nickname}! 오늘 하루 어때?');
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 말풍선 탭 시 GPT 호출
  Future<void> _handleBubbleTap() async {
    final gptResponse = await widget.gptService.getSlimeResponse();
    if (gptResponse != null) {
      // "슬라임: " 제거
      String text = gptResponse.replaceFirst('슬라임: ', '');
      // 깨진 유니코드 제거
      text = _removeInvalidSurrogates(text);

      _startTyping(text);
    }
  }

  /// 깨진 서로게이트 코드를 삭제해 UTF-16 오류 방지
  String _removeInvalidSurrogates(String input) {
    // D800~DFFF 범위의 잘못된 코드 제거
    return input.replaceAll(RegExp(r'[\uD800-\uDFFF]'), '');
  }

  /// 타이핑 효과 시작
  void _startTyping(String newMessage) {
    // 기존 타이핑 중이면 정지
    _typingTimer?.cancel();

    setState(() {
      _targetMessage = newMessage;
      _displayedMessage = '';
    });

    int currentIndex = 0;
    _typingTimer = Timer.periodic(_typeInterval, (timer) async {
      // 모든 글자를 다 출력하면 중단
      if (currentIndex >= _targetMessage.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _displayedMessage += _targetMessage[currentIndex];
      });
      currentIndex++;

      // 짧은 beep.mp3 재생
      // beep가 너무 길면 겹칠 수 있으므로 매우 짧은 파일 사용 권장
      try {
        // 이전 재생을 끊고 다시 재생하는 경우
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audios/beep.mp3'), volume: 0.4);
      } catch (e) {
        // 에러나면 무시
        print('오디오 재생 중 오류 발생: $e');
      }
    });
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
            width: 220,
            height: 60,
          ),
          // 텍스트
          Container(
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              _displayedMessage,
              style: const TextStyle(
                color: Color(0xFF605956),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.12,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}