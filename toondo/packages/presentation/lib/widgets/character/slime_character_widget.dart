// lib/widgets/character/slime_character_widget.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
// 변경: SlimeCharacterViewModel import 경로 수정
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';

class SlimeCharacterWidget extends StatefulWidget {
  final double width;
  final double height;
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
    _controller = SimpleAnimation(widget.initialAnimationName);
    widget.viewModel.addListener(_onViewModelChanged);
    _startBlinkSchedule();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
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