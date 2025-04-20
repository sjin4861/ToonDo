import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:domain/usecases/character/handle_slime_interaction.dart';
import 'package:domain/usecases/character/get_slime_character.dart';
import 'package:domain/usecases/character/unlock_special_animation.dart';

@LazySingleton()
class SlimeCharacterViewModel extends ChangeNotifier {
  final HandleSlimeInteractionUseCase _handleSlimeInteractionUseCase;
  final GetSlimeCharacterUseCase _getSlimeCharacterUseCase;
  final UnlockSpecialAnimationUseCase _unlockSpecialAnimationUseCase;
  
  String _animation = 'id';
  bool _isAnimating = false;
  bool _isInteractionEnabled = true;
  SlimeCharacter? _slimeCharacter;
  List<String> _availableAnimations = ['id', 'eye'];
  Timer? _resetTimer;

  String get animation => _animation;
  bool get isAnimating => _isAnimating;
  bool get isInteractionEnabled => _isInteractionEnabled;
  SlimeCharacter? get slimeCharacter => _slimeCharacter;
  List<String> get availableAnimations => _availableAnimations;

  SlimeCharacterViewModel({
    required HandleSlimeInteractionUseCase handleSlimeInteractionUseCase,
    required GetSlimeCharacterUseCase getSlimeCharacterUseCase,
    required UnlockSpecialAnimationUseCase unlockSpecialAnimationUseCase,
  }) : _handleSlimeInteractionUseCase = handleSlimeInteractionUseCase,
       _getSlimeCharacterUseCase = getSlimeCharacterUseCase,
       _unlockSpecialAnimationUseCase = unlockSpecialAnimationUseCase {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _slimeCharacter = await _getSlimeCharacterUseCase();
      _animation = _slimeCharacter?.animationState ?? 'id';
      notifyListeners();
    } catch (e) {
      debugPrint('슬라임 캐릭터 초기화 오류: $e');
    }
  }

  void setAnimation(String animationName) {
    _animation = animationName;
    notifyListeners();
  }

  Future<void> _playAnimationAndReset(String animName, {int durationMs = 1000}) async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    _isAnimating = true;
    _resetTimer?.cancel();
    
    setAnimation(animName);
    
    _resetTimer = Timer(Duration(milliseconds: durationMs), () {
      setAnimation('id');
      _isAnimating = false;
    });
  }

  void setIdle() => setAnimation('id');
  void setBlink() => _playAnimationAndReset('eye', durationMs: 300);
  void setAngry() => _playAnimationAndReset('angry');
  void setHappy() => _playAnimationAndReset('happy');
  void setShine() => _playAnimationAndReset('shine');
  void setMelt() => _playAnimationAndReset('melt');

  // 제스처 처리 메소드
  Future<void> handleTap() async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    try {
      final animation = await _handleSlimeInteractionUseCase.handleTap();
      await _playAnimationAndReset(animation);
    } catch (e) {
      debugPrint('탭 처리 오류: $e');
    }
  }
  
  Future<void> handleLongPress() async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    try {
      final animation = await _handleSlimeInteractionUseCase.handleLongPress();
      await _playAnimationAndReset(animation, durationMs: 2000);
    } catch (e) {
      debugPrint('길게 누르기 처리 오류: $e');
    }
  }
  
  Future<void> handleDrag() async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    try {
      final animation = await _handleSlimeInteractionUseCase.handleDrag();
      await _playAnimationAndReset(animation, durationMs: 1500);
    } catch (e) {
      debugPrint('드래그 처리 오류: $e');
    }
  }
  
  Future<void> handlePinch() async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    try {
      final animation = await _handleSlimeInteractionUseCase.handlePinch();
      await _playAnimationAndReset(animation, durationMs: 1200);
    } catch (e) {
      debugPrint('꼬집기 처리 오류: $e');
    }
  }
  
  Future<void> handleDoubleTap() async {
    if (!_isInteractionEnabled || _isAnimating) return;
    
    try {
      final animation = await _handleSlimeInteractionUseCase.handleDoubleTap();
      await _playAnimationAndReset(animation, durationMs: 1800);
    } catch (e) {
      debugPrint('이중 탭 처리 오류: $e');
    }
  }

  /// 목표 달성에 따른 특별 애니메이션 잠금 해제
  Future<String?> checkAndUnlockSpecialAnimation(int goalCount, String goalType) async {
    try {
      return await _unlockSpecialAnimationUseCase(goalCount, goalType);
    } catch (e) {
      debugPrint('특별 애니메이션 잠금 해제 오류: $e');
      return null;
    }
  }
  
  /// 상호작용 활성화/비활성화
  void setInteractionEnabled(bool enabled) {
    _isInteractionEnabled = enabled;
    notifyListeners();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
