import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/usecases/character/slime_on_gesture.dart';
import 'package:common/constants/slime_greetings.dart';
import 'package:common/utils/slime_greeting_preferences.dart';
import 'dart:async';
import 'dart:math';

@injectable
class SlimeCharacterViewModel extends ChangeNotifier {
  final SlimeOnGestureUseCase _gestureUC;
  SlimeCharacterViewModel(this._gestureUC);

  /// 현재 재생중인 애니메이션 key
  final ValueNotifier<String> animationKey = ValueNotifier('id');

  /// 현재 표시할 인사말
  String? _currentGreeting;
  String? get currentGreeting => _currentGreeting;

  /// 인사말 표시 여부
  bool _showGreeting = false;
  bool get showGreeting => _showGreeting;

  /// 자동 인사말 타이머
  Timer? _greetingTimer;
  
  /// 상호작용 메시지 타이머
  Timer? _interactionTimer;
  
  /// 현재 처리 중인 제스처가 있는지 여부
  bool _isProcessingGesture = false;
  
  /// 현재 애니메이션이 실행 중인지 여부
  bool _isAnimationPlaying = false;
  
  /// 애니메이션 보호 타이머
  Timer? _animationProtectionTimer;

  /// 인사말 표시 시간 (초)
  static const int _greetingDisplayDuration = 4;

  /// 자동 인사말 간격 (분)
  static const int _autoGreetingInterval = 3; // 5분에서 3분으로 단축

  @override
  void dispose() {
    _greetingTimer?.cancel();
    _interactionTimer?.cancel();
    _animationProtectionTimer?.cancel();
    animationKey.dispose();
    super.dispose();
  }

  /// 랜덤 인사말 표시
  void showRandomGreeting() {
    _currentGreeting = SlimeGreetings.getRandomGreeting();
    _showGreeting = true;
    notifyListeners();

    // 일정 시간 후 인사말 숨기기
    Timer(const Duration(seconds: _greetingDisplayDuration), () {
      hideGreeting();
    });
  }

  /// 시간대별 인사말 표시
  void showTimeBasedGreeting() {
    _currentGreeting = SlimeGreetings.getTimeBasedGreeting();
    _showGreeting = true;
    notifyListeners();

    Timer(const Duration(seconds: _greetingDisplayDuration), () {
      hideGreeting();
    });
  }

  /// 특정 메시지 표시
  void showCustomGreeting(String message) {
    _currentGreeting = message;
    _showGreeting = true;
    notifyListeners();

    Timer(const Duration(seconds: _greetingDisplayDuration), () {
      hideGreeting();
    });
  }

  /// 인사말 숨기기
  void hideGreeting() {
    _showGreeting = false;
    _currentGreeting = null;
    notifyListeners();
  }

  /// 자동 인사말 시작
  void startAutoGreeting() {
    _greetingTimer?.cancel();
    _greetingTimer = Timer.periodic(
      const Duration(minutes: _autoGreetingInterval),
      (_) {
        // 애니메이션 실행 중이 아닐 때만 자동 인사말 표시
        if (!_isAnimationPlaying && !_isProcessingGesture) {
          // 랜덤하게 시간대별 또는 일반 인사말 선택
          final random = Random();
          if (random.nextBool()) {
            showTimeBasedGreeting();
          } else {
            showRandomGreeting();
          }
        } else {
          print('[SlimeCharacterViewModel] 자동 인사말 건너뛰기');
        }
      },
    );
    
    // 상호작용 메시지도 별도로 시작 (더 자주 표시)
    _startInteractionMessages();
  }
  
  /// 상호작용 메시지 타이머 시작
  void _startInteractionMessages() {
    _interactionTimer?.cancel();
    _interactionTimer = Timer.periodic(
      const Duration(minutes: 7), // 7분마다 상호작용 메시지
      (_) {
        // 현재 인사말이 표시되지 않고 애니메이션도 실행되지 않을 때만 상호작용 메시지 표시
        if (!_showGreeting && !_isAnimationPlaying && !_isProcessingGesture) {
          showInteractionMessage();
        } else {
          print('[SlimeCharacterViewModel] 상호작용 메시지 건너뛰기');
        }
      },
    );
  }

  /// 자동 인사말 중단
  void stopAutoGreeting() {
    _greetingTimer?.cancel();
    _interactionTimer?.cancel();
  }

  /// 슬라임 터치 시 인사말 표시
  void onSlimeTapped() {
    if (!_canPlayAnimation()) {
      return;
    }
    
    _isProcessingGesture = true;
    _startAnimationProtection(durationSeconds: 1); // 더 짧은 보호 시간
    
    // 기존 제스처 처리
    onGesture(Gesture.tap).then((_) {
      // 애니메이션이 시작된 후 약간의 지연을 두고 클릭 반응 메시지 표시
      return Future.delayed(const Duration(milliseconds: 150));
    }).then((_) {
      final clickMessage = SlimeGreetings.getClickReactionMessage();
      showCustomGreeting(clickMessage);
      _isProcessingGesture = false;
    }).catchError((error) {
      _isProcessingGesture = false;
    });
  }

  /// 슬라임 더블탭 시 점프 애니메이션과 인사말 표시
  void onSlimeDoubleTapped() {
    if (!_canPlayAnimation()) {
      return;
    }
    
    _isProcessingGesture = true;
    _startAnimationProtection(durationSeconds: 1); // 더 짧은 보호 시간
    
    // 점프 애니메이션 실행
    onGesture(Gesture.doubleTap).then((_) {
      // 애니메이션이 시작된 후 약간의 지연을 두고 인사말 표시
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((_) {
      showTimeBasedGreeting();
      _isProcessingGesture = false;
    }).catchError((error) {
      _isProcessingGesture = false;
    });
  }

  /// 슬라임 롱프레스 시 애니메이션과 인사말 표시
  void onSlimeLongPressed() {
    if (!_canPlayAnimation()) {
      return;
    }
    
    _isProcessingGesture = true;
    _startAnimationProtection(durationSeconds: 1); // 더 짧은 보호 시간
    
    // 롱프레스 애니메이션 실행
    onGesture(Gesture.longPress).then((_) {
      // 애니메이션이 시작된 후 약간의 지연을 두고 동기부여 메시지 표시
      return Future.delayed(const Duration(milliseconds: 150));
    }).then((_) {
      showMotivation();
      _isProcessingGesture = false;
    }).catchError((error) {
      _isProcessingGesture = false;
    });
  }

  /// 슬라임 드래그 시 화나는 애니메이션과 메시지 표시
  void onSlimeDragged() {
    if (!_canPlayAnimation()) {
      return;
    }
    
    _isProcessingGesture = true;
    _startAnimationProtection(durationSeconds: 1); // 더 짧은 보호 시간
    
    // 드래그 애니메이션 실행 (화나는 애니메이션)
    onGesture(Gesture.drag).then((_) {
      // 애니메이션이 시작된 후 약간의 지연을 두고 메시지 표시
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((_) {
      // 화나는 메시지 표시
      final angryMessages = ['아야! 그만 건드려! 😠', '간지러워! 멈춰! 😤', '으악! 왜 자꾸 만져! 😡', '아프다고! 그만해! 💢'];
      angryMessages.shuffle();
      showCustomGreeting(angryMessages.first);
      _isProcessingGesture = false;
    }).catchError((error) {
      _isProcessingGesture = false;
    });
  }

  /// 슬라임 상호작용 메시지 표시
  void showInteractionMessage() {
    final interactionMessage = SlimeGreetings.getInteractionMessage();
    showCustomGreeting(interactionMessage);
  }

  /* 제스처 API – 위젯에서 호출 */
  Future<void> onGesture(Gesture g) async {
    final resp = await _gestureUC(g);
    animationKey.value = resp.animationKey;
  }

  /// 목표 달성 축하 메시지 표시
  void celebrateGoalCompletion() {
    final celebrationMessages = SlimeGreetings.celebrationMessages;
    celebrationMessages.shuffle();
    showCustomGreeting(celebrationMessages.first);
  }

  /// 격려 메시지 표시
  void showEncouragement() {
    final encouragementMessages = SlimeGreetings.encouragementMessages;
    encouragementMessages.shuffle();
    showCustomGreeting(encouragementMessages.first);
  }

  /// 동기부여 메시지 표시
  void showMotivation() {
    final motivationalMessages = SlimeGreetings.motivationalMessages;
    motivationalMessages.shuffle();
    showCustomGreeting(motivationalMessages.first);
  }

  /// 스마트 인사말 - 상황에 맞는 인사말 자동 선택
  void showSmartGreeting() {
    SlimeGreetingManager.initialize();
    
    String greeting;
    
    // 첫 방문인지 확인
    if (SlimeGreetingManager.isFirstLoginToday()) {
      // 오늘 첫 방문
      if (SlimeGreetingManager.getLoginCount() == 0) {
        // 앱 첫 사용
        greeting = "안녕! 처음 만나는구나! 반가워! 함께 목표를 달성해보자! 🌟";
      } else if (SlimeGreetingManager.hasOneDayPassed()) {
        // 하루 이상 지난 후 방문
        greeting = "오랜만이야! 보고 싶었어! 오늘도 함께 힘내보자! 💪";
      } else {
        // 당일 첫 방문
        greeting = SlimeGreetings.getTimeBasedGreeting();
      }
      SlimeGreetingManager.markTodayGreetingShown();
    } else if (SlimeGreetingManager.hasLongTimePassed()) {
      // 오랜 시간 후 재방문
      greeting = "다시 돌아왔네! 기다리고 있었어! 😊";
    } else {
      // 일반적인 경우
      greeting = SlimeGreetings.getRandomGreeting();
    }
    
    SlimeGreetingManager.incrementLoginCount();
    SlimeGreetingManager.updateLastAccessTime();
    
    showCustomGreeting(greeting);
  }

  /// 초기 인사말 스케줄링 (StatelessWidget에서 사용)
  void scheduleInitialGreeting() {
    // 위젯 생성 후 초기 인사말 표시
    Future.delayed(const Duration(milliseconds: 1500), () {
      showSmartGreeting();
    });
  }

  /// 애니메이션 보호 시작 (지정된 시간 동안 새로운 애니메이션 차단)
  void _startAnimationProtection({int durationSeconds = 2}) {
    _isAnimationPlaying = true;
    _animationProtectionTimer?.cancel();
    
    // 애니메이션 실행 시간에 따른 적응형 보호 시간
    int protectionMs = durationSeconds * 1000; // 기본은 그대로 유지
    
    _animationProtectionTimer = Timer(Duration(milliseconds: protectionMs), () {
      if (_isAnimationPlaying) {
        _isAnimationPlaying = false;
        // 타이머로 인한 보호 해제 시에는 즉시 idle로 복귀하지 않음
        // (OneShotAnimation의 onStop에서 처리하도록 함)
      }
    });
  }

  /// 애니메이션이 중지되었을 때 호출 (OneShotAnimation 콜백용)
  void onAnimationStopped(String animationName) {
    // 애니메이션이 중지되면 보호 해제만 수행
    _isAnimationPlaying = false;
    _animationProtectionTimer?.cancel();
    
    // 제스처 처리도 완료로 표시
    if (_isProcessingGesture) {
      _isProcessingGesture = false;
    }
    
    // idle로의 복귀는 별도의 타이머로 처리 (자연스러운 전환)
    _scheduleIdleReturn();
  }

  /// idle 애니메이션으로의 복귀를 스케줄링
  void _scheduleIdleReturn() {
    // 현재 애니메이션이 idle이 아닌 경우에만 복귀
    if (animationKey.value != 'id') {
      // 약간의 지연을 둠 (애니메이션이 자연스럽게 종료될 시간 확보)
      Timer(const Duration(milliseconds: 500), () {
        if (animationKey.value != 'id') {
          animationKey.value = 'id';
        }
      });
    }
  }

  /// 애니메이션이 완료되었을 때 호출 (레거시, 호환성을 위해 유지)
  void onAnimationCompleted(String animationName) {
    onAnimationStopped(animationName);
  }

  /// 애니메이션이 실행 가능한지 확인
  bool _canPlayAnimation() {
    if (_isAnimationPlaying) {
      return false;
    }
    if (_isProcessingGesture) {
      return false;
    }
    return true;
  }
}
