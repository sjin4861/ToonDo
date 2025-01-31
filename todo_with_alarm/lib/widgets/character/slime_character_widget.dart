// lib/widgets/character/slime_character_widget.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SlimeCharacterWidget extends StatefulWidget {
  final double width;
  final double height;
  final String initialAnimationName;

  const SlimeCharacterWidget({
    Key? key,
    this.width = 150,
    this.height = 150,
    this.initialAnimationName = 'id', // 기본 Idle
  }) : super(key: key);

  @override
  State<SlimeCharacterWidget> createState() => _SlimeCharacterWidgetState();
}

class _SlimeCharacterWidgetState extends State<SlimeCharacterWidget> {
  RiveAnimationController? _controller;
  Timer? _blinkTimer; // 깜빡임 타이머

  @override
  void initState() {
    super.initState();
    // 처음엔 Idle
    _controller = SimpleAnimation(widget.initialAnimationName);

    // 깜빡임 타이머 시작
    _startBlinkSchedule();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  /// 특정 애니메이션으로 전환
  void setAnimation(String animationName) {
    setState(() {
      _controller = SimpleAnimation(animationName);
    });
  }

  /// Blink 애니메이션이 끝나면 다시 Idle
  void _playBlinkThenIdle() {
    // Blink로 전환
    setAnimation('eye');

    // Blink 길이가 예: 0.3초라면, 그 후 Idle 복귀
    // 실제 길이에 맞춰 조정
    Future.delayed(const Duration(milliseconds: 300), () {
      // 깜빡임이 끝난 후 다시 Idle
      setAnimation('id');
    });
  }

  /// 일정 랜덤 간격으로 Blink
  void _startBlinkSchedule() {
    _blinkTimer?.cancel();

    // 3~6초 사이 랜덤
    final nextBlink = 3 + Random().nextInt(4); 

    _blinkTimer = Timer(Duration(seconds: nextBlink), () {
      // Blink 실행
      _playBlinkThenIdle();
      // 다음 깜빡임 예약
      _startBlinkSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveAnimation.asset(
        'assets/rives/slime.riv',
        controllers: _controller == null ? [] : [_controller!],
        fit: BoxFit.contain,
      ),
    );
  }
}