// lib/widgets/character/slime_character_widget.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
import 'package:flutter/foundation.dart';

class SlimeCharacterWidget extends StatefulWidget {
  final double width;
  final double height;
  final SlimeCharacterViewModel viewModel;
  final String initialAnimationName;
  final bool enableGestures;
  final bool showDebugInfo;

  const SlimeCharacterWidget({
    Key? key,
    this.width = 150,
    this.height = 150,
    this.initialAnimationName = 'id',
    required this.viewModel,
    this.enableGestures = true,
    this.showDebugInfo = false,
  }) : super(key: key);

  @override
  State<SlimeCharacterWidget> createState() => _SlimeCharacterWidgetState();
}

class _SlimeCharacterWidgetState extends State<SlimeCharacterWidget> with SingleTickerProviderStateMixin {
  RiveAnimationController? _controller;
  Timer? _blinkTimer;
  bool _isBlinking = false;
  Offset? _dragStartPosition;
  double _scale = 1.0;
  String _lastGesture = '';
  
  // 핀치 제스처 감지용 변수
  final List<int> _pointerIds = [];
  
  late AnimationController _animationController;
  Offset _dragOffset = Offset.zero;
  
  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation(widget.initialAnimationName);
    widget.viewModel.addListener(_onViewModelChanged);
    _startBlinkSchedule();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animationController.addListener(() {
      setState(() {
        // 애니메이션 컨트롤러의 값에 따라 슬라임의 위치를 업데이트
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    widget.viewModel.removeListener(_onViewModelChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setAnimation(widget.viewModel.animation);
  }

  void setAnimation(String animationName) {
    if (mounted) {
      setState(() {
        _controller = SimpleAnimation(animationName);
      });
    }
  }

  void _playBlinkThenIdle() {
    if (widget.viewModel.isAnimating || _isBlinking) return;
    
    _isBlinking = true;
    setAnimation('eye');
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !widget.viewModel.isAnimating) {
        setAnimation('id');
        _isBlinking = false;
      }
    });
  }

  void _startBlinkSchedule() {
    _blinkTimer?.cancel();
    final nextBlink = 3 + Random().nextInt(4);
    _blinkTimer = Timer(Duration(seconds: nextBlink), () {
      if (mounted && !widget.viewModel.isAnimating) {
        _playBlinkThenIdle();
        _startBlinkSchedule();
      } else {
        // 다른 애니메이션 중이면 나중에 다시 시도
        _startBlinkSchedule();
      }
    });
  }
  
  // 핀치 제스처 감지 메소드
  void _handleScaleStart(ScaleStartDetails details) {
    _scale = 1.0;
  }
  
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    // 스케일이 0.8보다 작으면 꼬집기로 간주
    if (details.scale < 0.8 && _pointerIds.length >= 2) {
      _handlePinchGesture();
    }
    setState(() {
      _scale = details.scale;
    });
  }
  
  void _handleScaleEnd(ScaleEndDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }
  
  // 포인터 추가/제거 감지
  void _handlePointerDown(PointerDownEvent event) {
    if (!_pointerIds.contains(event.pointer)) {
      _pointerIds.add(event.pointer);
    }
    
    // 드래그 시작 위치 저장
    if (_pointerIds.length == 1) {
      _dragStartPosition = event.position;
    }
  }
  
  void _handlePointerUp(PointerUpEvent event) {
    _pointerIds.remove(event.pointer);
    
    // 드래그 완료 처리
    if (_dragStartPosition != null) {
      final dragDistance = (_dragStartPosition! - event.position).distance;
      if (dragDistance > 50) { // 충분한 거리를 드래그했을 경우
        _handleDragGesture();
      }
      _dragStartPosition = null;
    }
  }
  
  // 제스처 처리 메소드
  void _handleTapGesture() {
    setState(() {
      _lastGesture = '탭';
    });
    widget.viewModel.handleTap();
  }
  
  void _handleDoubleTapGesture() {
    setState(() {
      _lastGesture = '더블 탭';
    });
    widget.viewModel.handleDoubleTap();
  }
  
  void _handleLongPressGesture() {
    setState(() {
      _lastGesture = '길게 누르기';
    });
    widget.viewModel.handleLongPress();
  }
  
  void _handleDragGesture() {
    setState(() {
      _lastGesture = '드래그';
    });
    widget.viewModel.handleDrag();
  }
  
  void _handlePinchGesture() {
    setState(() {
      _lastGesture = '꼬집기';
    });
    widget.viewModel.handlePinch();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableGestures) {
      return _buildRiveAnimation();
    }
    
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      child: GestureDetector(
        onTap: _handleTapGesture,
        onDoubleTap: _handleDoubleTapGesture,
        onLongPress: _handleLongPressGesture,
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 슬라임 애니메이션
            _buildRiveAnimation(),
            
            // 디버그 정보 (필요 시)
            if (widget.showDebugInfo)
              Positioned(
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.black54,
                  child: Text(
                    '최근 제스처: $_lastGesture\n스케일: ${_scale.toStringAsFixed(2)}\n포인터 수: ${_pointerIds.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRiveAnimation() {
    return Transform.scale(
      scale: _scale,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: RiveAnimation.asset(
          'assets/rives/slime.riv',
          controllers: _controller == null ? [] : [_controller!],
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}