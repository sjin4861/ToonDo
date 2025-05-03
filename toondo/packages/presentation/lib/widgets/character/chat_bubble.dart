import 'dart:async';
import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 오디오 재생
import 'package:domain/usecases/gpt/get_slime_response.dart';

class ChatBubble extends StatefulWidget {
  final String? nickname; // 사용자 닉네임
  final GetSlimeResponseUseCase getSlimeResponseUseCase; // GPT 호출 객체

  const ChatBubble({
    super.key,
    required this.nickname,
    required this.getSlimeResponseUseCase,
  });

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

  // 타이핑 Timer
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleBubbleTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 80,
          maxWidth: 260,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // (1) 말풍선 배경
            Positioned.fill(
              child: Assets.images.imgSpeechBubble.svg(
                fit: BoxFit.fill,
              ),
            ),
            // (2) 텍스트
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: Text(
                _displayedMessage,
                style: const TextStyle(
                  color: Color(0xFF605956),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  fontFamily: 'Nanum OgBiCe',
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 말풍선 탭 시 GPT 호출
  Future<void> _handleBubbleTap() async {
    final gptResponse = await widget.getSlimeResponseUseCase.call();
    if (gptResponse != null) {
      // "슬라임: " 제거
      String text = gptResponse.replaceFirst('슬라임: ', '');
      // 깨진 유니코드 제거
      text = _removeInvalidSurrogates(text);

      _startTyping(text);
    }
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

      // 짧은 sound_beep.mp3 재생
      // beep가 너무 길면 겹칠 수 있으므로 매우 짧은 파일 사용 권장
      try {
        // 이전 재생을 끊고 다시 재생하는 경우
        await _audioPlayer.stop();
        await _audioPlayer.play(
          AssetSource('audios/sound_beep.mp3'),
          volume: 0.4,
        );
      } catch (e) {
        // 에러나면 무시
        print('오디오 재생 중 오류 발생: $e');
      }
    });
  }

  /// 깨진 서로게이트 코드를 삭제해 UTF-16 오류 방지
  String _removeInvalidSurrogates(String input) {
    return input.replaceAll(RegExp(r'[\uD800-\uDFFF]'), '');
  }
}
