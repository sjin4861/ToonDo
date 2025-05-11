// lib/viewmodels/home/home_viewmodel.dart
import 'dart:async';

import 'package:domain/repositories/slime_repository.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/user/get_user_nickname.dart';
import 'package:domain/usecases/auth/logout.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

@LazySingleton()
class HomeViewModel extends ChangeNotifier {
  final GetInProgressGoalsUseCase _getGoals;
  final GetUserNicknameUseCase _getNick;

  HomeViewModel(
    this._getGoals,
    this._getNick,
    ) {
    _init();
  }

  // ─── Goal 리스트 ──────────────────────────
  List<Goal> _goals = [];
  List<Goal> get goals => _goals;
  Future<void> loadGoals() async {
    _goals = await _getGoals();
    notifyListeners();
  }

  List<Goal> get dDayClosestThree {
    final list = List<Goal>.from(_goals)
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    return list.take(3).toList();
  }

  // ─── 사용자 정보 ───────────────────────────
  String _nickname = '';
  String get nickname => _nickname;
  Future<void> _loadNickname() async {
    _nickname = await _getNick() ?? '';
    notifyListeners();
  }

  // ─── Chat 모드 상태 ────────────────────────
  bool _chatEnabled = false;
  bool get chatEnabled => _chatEnabled;
  late final StreamSubscription _chatSub;
  void _listenChatToggle() {
    _chatSub = GetIt.I<SlimeRepository>().chatEnabled$.listen((v) {
      _chatEnabled = v;
      notifyListeners();
    });
  }

  // ─── 초기화 / 정리 ─────────────────────────
  Future<void> _init() async {
    await Future.wait([loadGoals(), _loadNickname()]);
    _listenChatToggle();
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  // ─── 로그아웃 ──────────────────────────────
  Future<void> logout() async => GetIt.I<LogoutUseCase>()();
}
