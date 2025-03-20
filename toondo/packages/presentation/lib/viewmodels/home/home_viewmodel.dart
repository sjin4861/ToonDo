// lib/viewmodels/home/home_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/delete_goal.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/usecases/user/get_user_nickname.dart';
import 'package:domain/usecases/gpt/get_slime_response.dart';
import 'package:domain/usecases/auth/logout.dart';
import 'package:get_it/get_it.dart';

@LazySingleton()
class HomeViewModel extends ChangeNotifier {
  final GetInProgressGoalsUseCase getInProgressGoalsUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;
  final GetUserNicknameUseCase getUserNicknameUseCase;
  final GetSlimeResponseUseCase getSlimeResponseUseCase;

  List<Goal> _inProgressGoals = [];
  List<Goal> get goals => _inProgressGoals;

  // 슬라임 애니메이션 (이전 SlimeCharacterViewModel 기능 통합)
  String _animation = 'id';
  String get animation => _animation;
  void setAnimation(String anim) {
    _animation = anim;
    notifyListeners();
  }
  Future<void> playSequentialAnimations() async {
    final animations = ['id', 'eye', 'angry', 'happy', 'shine', 'melt'];
    for (var anim in animations) {
      setAnimation(anim);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setAnimation('id');
  }

  // 사용자 닉네임을 캐싱할 변수 추가
  String _userNickname = '';
  String get userNickname => _userNickname;
  Future<void> loadUserNickname() async {
    final nick = await getUserNicknameUseCase.call();
    _userNickname = nick ?? '';
    notifyListeners();
  }

  HomeViewModel({
    required this.getInProgressGoalsUseCase,
    required this.deleteGoalUseCase,
    required this.getUserNicknameUseCase,
    required this.getSlimeResponseUseCase,
  }) {
    loadGoals();
    loadUserNickname();
  }

  Future<void> loadGoals() async {
    _inProgressGoals = await getInProgressGoalsUseCase();
    notifyListeners();
  }

  List<Goal> get dDayClosestThree {
    final sortedGoals = List<Goal>.from(_inProgressGoals)
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    return sortedGoals.take(3).toList();
  }

  Future<void> deleteGoal(String goalId) async {
    await deleteGoalUseCase(goalId);
    await loadGoals();
  }
  
  // logout 유스케이스를 처리하는 메서드 추가
  Future<void> logout() async {
    await GetIt.instance<LogoutUseCase>()();
  }
}
