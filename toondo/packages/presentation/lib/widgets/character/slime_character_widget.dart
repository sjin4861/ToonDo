// lib/widgets/character/slime_character_widget.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../../../lib/viewmodels/character/slime_character_viewmodel.dart';

class SlimeCharacterWidget extends StatefulWidget {
  final double width;
  final double height;
  // 추가: MVVM에서 사용할 ViewModel을 외부에서 전달받음
  final SlimeCharacterViewModel viewModel;
  final String initialAnimationName;

  const SlimeCharacterWidget({
    Key? key,
    this.width = 150,
    this.height = 150,
    this.initialAnimationName = 'id',
    required this.viewModel,
  }) : super(key: key);

  @override
  State<SlimeCharacterWidget> createState() => _SlimeCharacterWidgetState();
}

class _SlimeCharacterWidgetState extends State<SlimeCharacterWidget> {
  RiveAnimationController? _controller;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    // 초기 애니메이션은 ViewModel 상태 또는 전달된 기본값 사용
    _controller = SimpleAnimation(widget.initialAnimationName);
    // ViewModel 상태 변화에 따른 업데이트 등록
    widget.viewModel.addListener(_onViewModelChanged);
    // Blink 타이머 시작 (필요 시 ViewModel과 분리하여 내부 타이머 유지)
    _startBlinkSchedule();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    // ViewModel의 animation 값이 변경되면 Rive 컨트롤러 업데이트
    setAnimation(widget.viewModel.animation);
  }

  void setAnimation(String animationName) {
    setState(() {
      _controller = SimpleAnimation(animationName);
    });
  }

  void _playBlinkThenIdle() {
    setAnimation('eye');
    Future.delayed(const Duration(milliseconds: 300), () {
      setAnimation('id');
    });
  }

  void _startBlinkSchedule() {
    _blinkTimer?.cancel();
    final nextBlink = 3 + Random().nextInt(4);
    _blinkTimer = Timer(Duration(seconds: nextBlink), () {
      _playBlinkThenIdle();
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