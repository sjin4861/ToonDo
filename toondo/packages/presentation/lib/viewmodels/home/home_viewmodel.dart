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
      _todos = await _getTodosUseCase();
      print('📊 홈에서 로드된 Todo 개수: ${_todos.length}');
      final showOnHomeTodos = _todos.where((todo) => todo.showOnHome).toList();
      print('📊 showOnHome=true인 Todo 개수: ${showOnHomeTodos.length}');
      for (final todo in showOnHomeTodos) {
        print('📊 showOnHome Todo: ${todo.title} (${todo.showOnHome})');
      }
      notifyListeners();
    } catch (e) {
      print('홈에서 투두 로드 실패: $e');
    }
  }

  List<Goal> get todayTop3Goals {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filtered = _goals.where((goal) {
      // showOnHome이 true인 것만 필터링
      if (!goal.showOnHome) return false;
      
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

    print('🔍 todayTop3Todos 필터링 시작');
    print('🔍 전체 Todo 개수: ${_todos.length}');
    
    final filtered = _todos.where((todo) {
      // showOnHome이 true인 것만 필터링
      if (!todo.showOnHome) {
        print('🔍 showOnHome=false로 필터링됨: ${todo.title}');
        return false;
      }
      
      final start = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      final end = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final isInDateRange = (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
      
      if (!isInDateRange) {
        print('🔍 날짜 범위로 필터링됨: ${todo.title} (${start} ~ ${end}), 오늘: ${today}');
        return false;
      }
      
      print('🔍 필터링 통과: ${todo.title} (showOnHome: ${todo.showOnHome})');
      return true;
    }).toList();

    print('🔍 필터링된 Todo 개수: ${filtered.length}');
    
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
    await Future.wait([loadGoals(), loadTodos(), _loadNickname()]);
  }

  Future<void> refresh() async {
    print('🔄 홈화면 새로고침 시작');
    await Future.wait([loadGoals(), loadTodos()]);
    print('🔄 홈화면 새로고침 완료');
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ─── 로그아웃 ──────────────────────────────
  Future<void> logout() async => GetIt.I<LogoutUseCase>()();
}
