import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/expand_recurring_todos_for_date.dart';
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
  final ExpandRecurringTodosForDateUseCase _expandRecurring;

  HomeViewModel(
    this._getGoals,
    this._getNick,
    this._getTodosUseCase,
    this._expandRecurring,
  ) {
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

  List<Todo> _routineSeries = [];
  List<Todo> get routineSeries => _routineSeries;


  Future<void> loadGoals() async {
    _goals = await _getGoals();
    notifyListeners();
  }

  Future<void> loadTodos() async {
    try {
      final raw = await _getTodosUseCase();
      // 시리즈 템플릿은 홈 단순 목록에서 제외 — expand 결과로 대체
      final nonSeries =
          raw.where((t) => !t.isRecurringSeries).toList();
      _routineSeries = raw.where((t) => t.isRecurringSeries).toList();
      final todayExpansion = await _expandRecurring(DateTime.now());
      // expand가 반환한 occurrence는 이미 비-시리즈 목록에 머터리얼라이즈된
      // 인스턴스가 있으면 그것을 포함하므로 id 기준 중복 제거
      final byId = <String, Todo>{for (final t in nonSeries) t.id: t};
      for (final occ in todayExpansion) {
        byId.putIfAbsent(occ.id, () => occ);
      }
      _todos = byId.values.toList();
      print('📊 홈에서 로드된 Todo 개수: ${_todos.length}');
      final showOnHomeTodos = _todos.where((todo) => todo.showOnHome).toList();
      print('📊 showOnHome=true인 Todo 개수: ${showOnHomeTodos.length}');
      for (final todo in showOnHomeTodos) {
        print('📊 showOnHome Todo: ${todo.title} (${todo.showOnHome})');
      }
      
      // TODO: 데이터 동기화 문제 - 홈 뷰모델과 투두 관리 뷰모델 간 일관성 부족
      // TODO: 투두 생성/삭제/수정 시 홈 화면이 자동으로 업데이트되지 않는 문제
      // TODO: 해결 방안 1: 모든 투두 CUD 작업 후 HomeViewModel.loadTodos() 호출
      // TODO: 해결 방안 2: 이벤트 버스나 Stream을 사용한 실시간 동기화 구현
      // TODO: 해결 방안 3: Provider 패턴으로 상태 관리 통합
      // TODO: 현재 상태: 투두를 삭제해도 홈 화면에 여전히 표시되는 버그 존재
      
      notifyListeners();
    } catch (e) {
      print('홈에서 투두 로드 실패: $e');
    }
  }

  List<Goal> get todayTop3Goals {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    print('🔍 todayTop3Goals 필터링 시작');
    print('🔍 전체 Goal 개수: ${_goals.length}');
    
    final filtered = _goals.where((goal) {
      // TODO: 메인화면 노출 문제 분석 - showOnHome 체크 로직 확인
      // TODO: 목표 showOnHome 기본값 확인 - 생성 시 기본값이 false로 설정되는지 점검
      // TODO: 목표 입력 화면에서 '메인화면 노출' 토글 상태와 실제 저장값 일치성 검증
      // TODO: 목표 필터링 로직 개선 - 시작일이 미래인 목표도 사용자가 원한다면 표시 가능하도록 옵션 제공
      // 
      // ⚠️ 주요 문제점: showOnHome 기본값이 false로 설정되어 있어
      // 사용자가 명시적으로 '메인화면 노출' 토글을 켜지 않으면 메인화면에 표시되지 않음
      // 
      // TODO: UX 개선 방안
      // 1. showOnHome 기본값을 true로 변경
      // 2. 첫 생성 시 메인화면 노출 기본 선택 안내
      // 3. 메인화면이 비어있을 때 사용자 가이드 제공
      // showOnHome이 true인 것만 필터링 (투두와 달리 목표는 여전히 showOnHome 체크)
      if (!goal.showOnHome) {
        print('🔍 showOnHome=false로 필터링됨: ${goal.name} (showOnHome: ${goal.showOnHome})');
        return false;
      }
      
      final start = DateTime(goal.startDate.year, goal.startDate.month, goal.startDate.day);
      // '마감일 없이 할래요' 기능 - endDate가 null인 목표 필터링 처리
      if (goal.endDate == null) {
        // 마감일이 없는 목표는 시작일만 체크
        final isActive = start.isBefore(today) || start.isAtSameMomentAs(today);
        if (!isActive) {
          print('🔍 마감일 없는 목표 시작일 조건 불만족: ${goal.name} (시작일: ${start}, 오늘: ${today})');
        }
        return isActive;
      }
      final end = DateTime(goal.endDate!.year, goal.endDate!.month, goal.endDate!.day);
      final isInDateRange = (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
      
      if (!isInDateRange) {
        print('🔍 목표 날짜 범위 조건 불만족: ${goal.name} (${start} ~ ${end}), 오늘: ${today}');
      }
      
      print('🔍 목표 필터링 통과: ${goal.name} (showOnHome: ${goal.showOnHome})');
      return isInDateRange;
    }).toList();

    print('🔍 필터링된 Goal 개수: ${filtered.length}');

    // '마감일 없이 할래요' 기능 - endDate null 안전 정렬
    filtered.sort((a, b) {
      // endDate가 null인 목표는 맨 뒤로 정렬
      if (a.endDate == null && b.endDate == null) return 0;
      if (a.endDate == null) return 1;
      if (b.endDate == null) return -1;
      return a.endDate!.compareTo(b.endDate!);
    });

    final result = filtered.take(3).toList();
    print('🔍 최종 선택된 Goal 개수: ${result.length}');
    for (final goal in result) {
      print('🔍 선택된 Goal: ${goal.name} (showOnHome: ${goal.showOnHome})');
    }

    return result;
  }


  List<Todo> get todayTop3Todos {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    print('🔍 todayTop3Todos 필터링 시작');
    print('🔍 전체 Todo 개수: ${_todos.length}');
    
    // TODO: 메인화면 노출 문제 분석 - showOnHome 체크 일관성 확인
    // 개선된 메인화면 투두 리스트 표시 규칙:
    // 1. showOnHome=true인 투두만 표시 (사용자가 명시적으로 선택한 항목)
    // 2. 완료되지 않은 투두만 선택
    // 3. 오늘 날짜에 해당하는 투두만 필터링
    // 4. eisenhower 매트릭스 기반 우선순위 정렬
    // 5. 상위 3개 선택
    // 
    // ⚠️ 주요 문제점: showOnHome 기본값이 false로 설정되어 있어
    // 사용자가 명시적으로 '메인화면 노출' 토글을 켜지 않으면 메인화면에 표시되지 않음
    // 
    // TODO: UX 개선 방안
    // 1. showOnHome 기본값을 true로 변경
    // 2. 첫 생성 시 메인화면 노출 기본 선택 안내
    // 3. 메인화면이 비어있을 때 사용자 가이드 제공
    
    final filtered = _todos.where((todo) {
      // TODO: 메인화면 노출 문제 해결 - showOnHome 체크 복원
      // 사용자가 '메인화면 노출' 체크박스를 클릭한 투두만 표시
      if (!todo.showOnHome) {
        print('🔍 showOnHome=false로 필터링됨: ${todo.title} (showOnHome: ${todo.showOnHome})');
        return false;
      }
      
      // 완료된 투두 제외 (status == 1.0이면 완료)
      if (todo.isFinished()) {
        print('🔍 완료된 투두로 필터링됨: ${todo.title}');
        return false;
      }
      
      // 오늘 날짜에 해당하는 투두만 표시 (date range 체크)
      final start = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      final end = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final isToday = (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
      
      if (!isToday) {
        print('🔍 오늘 할 투두가 아니므로 필터링됨: ${todo.title} (${start} ~ ${end}), 오늘: ${today}');
        return false;
      }
      
      print('🔍 필터링 통과: ${todo.title} (showOnHome: ${todo.showOnHome}, eisenhower: ${todo.eisenhower}, 진행률: ${todo.status}%)');
      return true;
    }).toList();

    print('🔍 필터링된 Todo 개수: ${filtered.length}');
    
    // 우선순위 기반 정렬 (eisenhower 매트릭스)
    // 0: 긴급하고 중요 (1순위)
    // 1: 중요하지만 긴급하지 않음 (2순위)  
    // 2: 긴급하지만 중요하지 않음 (3순위)
    // 3: 긴급하지도 중요하지도 않음 (4순위)
    filtered.sort((a, b) {
      // 1순위: eisenhower 매트릭스 (낮은 숫자가 높은 우선순위)
      final priorityComparison = a.eisenhower.compareTo(b.eisenhower);
      if (priorityComparison != 0) return priorityComparison;
      
      // 2순위: 진행률 (낮은 진행률이 우선 - 아직 할 일이 많은 것부터)
      final progressComparison = a.status.compareTo(b.status);
      if (progressComparison != 0) return progressComparison;
      
      // 3순위: 마감일이 가까운 순 (endDate 기준)
      final todayTime = today.millisecondsSinceEpoch;
      final aDaysLeft = a.endDate.millisecondsSinceEpoch - todayTime;
      final bDaysLeft = b.endDate.millisecondsSinceEpoch - todayTime;
      return aDaysLeft.compareTo(bDaysLeft);
    });

    final result = filtered.take(3).toList();
    print('🔍 최종 선택된 Todo 개수: ${result.length}');
    for (final todo in result) {
      print('🔍 선택된 Todo: ${todo.title} (우선순위: ${todo.eisenhower}, 진행률: ${todo.status}%)');
    }
    
    return result;
  }

  /// 오늘 홈에 노출된 투두가 있고 모두 완료된 경우 true
  bool get isTodayTodosAllCompleted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayShowOnHome = _todos.where((todo) {
      if (!todo.showOnHome) return false;
      final start = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      final end = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      return (start.isBefore(today) || start.isAtSameMomentAs(today)) &&
          (end.isAfter(today) || end.isAtSameMomentAs(today));
    }).toList();
    return todayShowOnHome.isNotEmpty && todayShowOnHome.every((t) => t.isFinished());
  }

  List<Goal> get dDayClosestThree {
    final list = List<Goal>.from(_goals)
      // TODO: '마감일 없이 할래요' 기능 - endDate가 null인 목표 정렬 처리
      ..sort((a, b) {
        // endDate가 null인 목표는 맨 뒤로 정렬
        if (a.endDate == null && b.endDate == null) return 0;
        if (a.endDate == null) return 1;
        if (b.endDate == null) return -1;
        return a.endDate!.compareTo(b.endDate!);
      });
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
