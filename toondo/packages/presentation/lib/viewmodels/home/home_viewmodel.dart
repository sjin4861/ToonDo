import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
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
  final GetAllTodosUseCase _getTodosUseCase;

  HomeViewModel(this._getGoals, this._getNick, this._getTodosUseCase) {
    _init();
  }

  int selectedTabIndex = 0;

  void changeTab(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  // ─── Goal 리스트 ──────────────────────────
  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;


  Future<void> loadGoals() async {
    _goals = await _getGoals();
    notifyListeners();
  }

  Future<void> loadTodos() async {
    try {
      _todos = _getTodosUseCase();

      notifyListeners();
    } catch (e) {
      print('홈에서 투두 로드 실패: $e');
    }
  }

  List<Goal> get todayTop3Goals {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filtered = _goals.where((goal) {
      final start = DateTime(goal.startDate.year, goal.startDate.month, goal.startDate.day);
      final end = DateTime(goal.endDate.year, goal.endDate.month, goal.endDate.day);
      return (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
    }).toList();

    filtered.sort((a, b) => a.endDate.compareTo(b.endDate));

    return filtered.take(3).toList();
  }


  List<Todo> get todayTop3Todos {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filtered = _todos.where((todo) {
      final start = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      final end = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      return (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
    }).toList();

    filtered.sort((a, b) => a.status.compareTo(b.status));

    return filtered.take(3).toList();
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

  // ─── 초기화 / 정리 ─────────────────────────
  Future<void> _init() async {
    await Future.wait([loadGoals(), _loadNickname()]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ─── 로그아웃 ──────────────────────────────
  Future<void> logout() async => GetIt.I<LogoutUseCase>()();
}
