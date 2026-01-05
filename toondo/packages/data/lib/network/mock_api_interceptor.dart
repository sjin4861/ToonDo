import 'dart:async';
import 'package:dio/dio.dart';
import 'package:data/constants.dart';

/// 모든 API 호출을 가로채서 Mock 응답을 반환하는 인터셉터
/// Constants.useMockApi가 true일 때 활성화됩니다
class MockApiInterceptor extends Interceptor {
  static int _todoIdCounter = 1;
  static int _goalIdCounter = 1;
  static final Map<String, dynamic> _mockTodos = {};
  static final Map<String, dynamic> _mockGoals = {};
  static String? _mockAccessToken;
  static int _mockUserId = 1;
  static String _mockLoginId = 'testuser';
  static String? _mockNickname;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Mock 모드가 비활성화되어 있으면 실제 요청 진행
    if (!Constants.useMockApi) {
      handler.next(options);
      return;
    }

    // 네트워크 지연 시뮬레이션
    await Future.delayed(Constants.mockApiNetworkLatency);

    // 경로 추출: 전체 URL이면 경로만 추출, 상대 경로면 그대로 사용
    String path = options.path;
    
    // 전체 URL인 경우 경로만 추출
    if (path.startsWith('http://') || path.startsWith('https://')) {
      try {
        final uri = Uri.parse(path);
        path = uri.path;
      } catch (_) {
        // URL 파싱 실패 시 options.uri.path 사용
        path = options.uri.path;
      }
    } else {
      // 상대 경로인 경우 options.uri.path 사용 (더 정확)
      path = options.uri.path;
    }
    
    final method = options.method.toUpperCase();

    // 🔍 디버깅 로그 추가
    print('🔵 [Mock API] ${method} ${path} (original path: ${options.path})');

    try {
      final mockResponse = _getMockResponse(path, method, options);
      if (mockResponse != null) {
        print('✅ [Mock API] Mock 응답 반환: ${mockResponse.statusCode}');
        handler.resolve(mockResponse);
        return;
      } else {
        print('⚠️ [Mock API] Mock 응답 없음 - 실제 요청 진행 (path: $path)');
      }
    } catch (e) {
      print('❌ [Mock API] 오류: $e');
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
      return;
    }

    // Mock 응답이 없으면 실제 요청 진행 (fallback)
    handler.next(options);
  }

  Response? _getMockResponse(String path, String method, RequestOptions options) {
    // Auth APIs
    if ((path.contains('/users/signup') || path == '/api/v1/users/signup') && method == 'POST') {
      return _mockSignup(options);
    }
    if ((path == '/login' || path == '/users/login') && method == 'POST') {
      return _mockLogin(options);
    }
    if (path.contains('/logout') && method == 'POST') {
      return _mockLogout(options);
    }
    if (path.contains('/check-loginid') && method == 'GET') {
      return _mockCheckLoginId(options);
    }
    if (path.contains('/auth/refreshToken') || path.contains('/auth/refresh')) {
      return _mockRefreshToken(options);
    }
    if ((path.contains('/delete-account') || path.contains('/users/delete')) && method == 'DELETE') {
      return _mockDeleteAccount(options);
    }

    // User APIs
    if ((path == '/users/me' || path.contains('/users/me')) && method == 'GET') {
      return _mockGetUserMe(options);
    }
    if ((path.contains('/users/me/password') || path.contains('/password')) && (method == 'PUT' || method == 'PATCH')) {
      return _mockUpdatePassword(options);
    }
    if (path.contains('/save-nickname') && (method == 'PUT' || method == 'PATCH')) {
      return _mockChangeNickname(options);
    }

    // Goal APIs
    if (path == '/api/v1/goals' && method == 'GET') {
      return _mockReadGoals(options);
    }
    if (path == '/api/v1/goals' && method == 'POST') {
      return _mockCreateGoal(options);
    }
    if (path.startsWith('/api/v1/goals/') && method == 'PUT' && !path.contains('/status') && !path.contains('/progress')) {
      return _mockUpdateGoal(options);
    }
    if (path.startsWith('/api/v1/goals/') && method == 'DELETE') {
      return _mockDeleteGoal(options);
    }
    if (path.contains('/goals/') && path.contains('/status') && method == 'PUT') {
      return _mockUpdateGoalStatus(options);
    }
    if (path.contains('/goals/') && path.contains('/progress') && method == 'PUT') {
      return _mockUpdateGoalProgress(options);
    }

    // Todo APIs
    if (path == '/api/v1/todos' && method == 'POST') {
      return _mockCreateTodo(options);
    }
    if (path == '/api/v1/by-date' && method == 'GET') {
      return _mockFetchTodosByDate(options);
    }
    if (path.startsWith('/api/v1/todos/by-goal/') && method == 'GET') {
      return _mockFetchTodosByGoal(options);
    }
    if (path.startsWith('/api/v1/todos/') && method == 'GET' && !path.contains('/status')) {
      return _mockFetchTodoById(options);
    }
    if (path.startsWith('/api/v1/todos/') && method == 'PUT') {
      return _mockUpdateTodo(options);
    }
    if (path.contains('/todos/') && path.contains('/status') && method == 'PATCH') {
      return _mockToggleTodoStatus(options);
    }
    if (path.startsWith('/api/v1/todos/') && method == 'DELETE') {
      return _mockDeleteTodo(options);
    }

    return null;
  }

  // ========== Auth Mock Responses ==========

  Response _mockSignup(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final loginId = data?['loginId'] as String? ?? '';

    _mockAccessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    _mockLoginId = loginId;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'accessToken': _mockAccessToken,
        'message': '회원가입 성공',
      },
    );
  }

  Response _mockLogin(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final loginId = data?['id'] as String? ?? data?['loginId'] as String? ?? '';

    _mockAccessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    _mockLoginId = loginId;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'accessToken': _mockAccessToken,
        'message': '로그인 성공',
      },
    );
  }

  Response _mockLogout(RequestOptions options) {
    _mockAccessToken = null;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '로그아웃 성공'},
    );
  }

  Response _mockCheckLoginId(RequestOptions options) {
    final queryParams = options.queryParameters;
    final loginId = queryParams['loginId'] as String? ?? queryParams['loginid'] as String? ?? '';

    // testuser는 항상 사용 가능 (false = 사용 가능)
    final exists = loginId.isNotEmpty && loginId != 'testuser' && loginId != Constants.testLoginId;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'exists': exists},
    );
  }

  Response _mockRefreshToken(RequestOptions options) {
    _mockAccessToken = 'mock_refreshed_token_${DateTime.now().millisecondsSinceEpoch}';

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'accessToken': _mockAccessToken,
        'message': '토큰 갱신 성공',
      },
    );
  }

  Response _mockDeleteAccount(RequestOptions options) {
    _mockAccessToken = null;
    _mockUserId = 1;
    _mockLoginId = 'testuser';
    _mockNickname = null;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '계정 삭제 성공'},
    );
  }

  // ========== User Mock Responses ==========

  Response _mockGetUserMe(RequestOptions options) {
    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'message': '내 정보 조회 성공',
        'userId': _mockUserId,
        'loginId': _mockLoginId,
        'nickname': _mockNickname ?? '테스트 사용자',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  Response _mockUpdatePassword(RequestOptions options) {
    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '비밀번호 수정 성공'},
    );
  }

  Response _mockChangeNickname(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final nickname = data?['nickname'] as String? ?? '';

    _mockNickname = nickname;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'message': '닉네임 최초 저장 및 수정 완료',
        'nickname': nickname,
      },
    );
  }

  // ========== Goal Mock Responses ==========

  Response _mockReadGoals(RequestOptions options) {
    final goals = _mockGoals.values.toList();

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: goals.isEmpty ? [] : goals,
    );
  }

  Response _mockCreateGoal(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final goalId = _goalIdCounter++;
    final now = DateTime.now();

    final goal = {
      'goalId': goalId.toString(),
      'goalName': data?['goalName'] as String? ?? '새 목표',
      'icon': data?['icon'] as String? ?? '',
      'progress': 0.0,
      'startDate': data?['startDate'] as String? ?? now.toIso8601String().split('T')[0],
      'endDate': data?['endDate'] as String? ?? now.add(const Duration(days: 30)).toIso8601String().split('T')[0],
      'status': 0, // active
      'showOnHome': data?['showOnHome'] as bool? ?? false, // 요청 데이터에서 받아옴
    };

    _mockGoals[goalId.toString()] = goal;

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: goal,
    );
  }

  Response _mockUpdateGoal(RequestOptions options) {
    // /api/v1/goals/{goalId} 형식에서 goalId 추출
    final parts = options.path.split('/');
    final goalId = parts.length >= 4 ? parts[3] : '';
    final data = options.data as Map<String, dynamic>?;

    if (_mockGoals.containsKey(goalId)) {
      final existingGoal = Map<String, dynamic>.from(_mockGoals[goalId] as Map);
      existingGoal['goalName'] = data?['goalName'] ?? existingGoal['goalName'];
      existingGoal['icon'] = data?['icon'] ?? existingGoal['icon'];
      existingGoal['startDate'] = data?['startDate'] ?? existingGoal['startDate'];
      existingGoal['endDate'] = data?['endDate'] ?? existingGoal['endDate'];
      existingGoal['showOnHome'] = data?['showOnHome'] ?? existingGoal['showOnHome']; // showOnHome 업데이트 추가
      _mockGoals[goalId] = existingGoal;
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '목표 수정 성공'},
    );
  }

  Response _mockDeleteGoal(RequestOptions options) {
    // /api/v1/goals/{goalId} 형식에서 goalId 추출
    final parts = options.path.split('/');
    final goalId = parts.length >= 4 ? parts[3] : '';
    _mockGoals.remove(goalId);

    // 해당 goalId를 가진 todos도 삭제
    _mockTodos.removeWhere((key, value) => value['goalId']?.toString() == goalId);

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '목표 삭제 성공'},
    );
  }

  Response _mockUpdateGoalStatus(RequestOptions options) {
    final goalId = options.path.split('/')[3]; // /api/v1/goals/{goalId}/status
    final data = options.data as Map<String, dynamic>?;
    final newStatus = data?['status'] as int? ?? 0;

    if (_mockGoals.containsKey(goalId)) {
      final goal = Map<String, dynamic>.from(_mockGoals[goalId] as Map);
      goal['status'] = newStatus;
      if (newStatus == 1) {
        // 완료 상태면 progress를 100으로
        goal['progress'] = 100.0;
      }
      _mockGoals[goalId] = goal;
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'message': '목표 상태 업데이트 성공',
        'progress': newStatus == 1 ? 100.0 : (_mockGoals[goalId]?['progress'] ?? 0.0),
      },
    );
  }

  Response _mockUpdateGoalProgress(RequestOptions options) {
    final goalId = options.path.split('/')[3]; // /api/v1/goals/{goalId}/progress
    final data = options.data as Map<String, dynamic>?;
    final newProgress = (data?['progress'] as num?)?.toDouble() ?? 0.0;

    if (_mockGoals.containsKey(goalId)) {
      final goal = Map<String, dynamic>.from(_mockGoals[goalId] as Map);
      goal['progress'] = newProgress;
      _mockGoals[goalId] = goal;
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'message': '목표 진행률 업데이트 성공',
        'progress': newProgress,
      },
    );
  }

  // ========== Todo Mock Responses ==========

  Response _mockCreateTodo(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final todoId = _todoIdCounter++;
    final now = DateTime.now();

    final todo = {
      'todoId': todoId,
      'title': data?['title'] as String? ?? '새 할 일',
      'goalId': data?['goalId'] as int?,
      'status': 0.0,
      'startDate': data?['startDate'] as String? ?? now.toIso8601String().split('T')[0],
      'endDate': data?['endDate'] as String? ?? now.add(const Duration(days: 1)).toIso8601String().split('T')[0],
      'eisenhower': data?['eisenhower'] as int? ?? 1,
      'showOnHome': data?['showOnHome'] as bool? ?? false,
    };

    _mockTodos[todoId.toString()] = todo;

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: {'todoId': todoId},
    );
  }

  Response _mockFetchTodosByDate(RequestOptions options) {
    final queryParams = options.queryParameters;
    final dateStr = queryParams['date'] as String? ?? DateTime.now().toIso8601String().split('T')[0];

    final todos = _mockTodos.values
        .where((todo) {
          final startDate = todo['startDate'] as String? ?? '';
          final endDate = todo['endDate'] as String? ?? '';
          return startDate == dateStr || endDate == dateStr ||
              (startDate.compareTo(dateStr) <= 0 && endDate.compareTo(dateStr) >= 0);
        })
        .toList();

    // dday와 daily 구분 (간단히 모든 todo를 daily로 분류)
    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'dday': todos.where((t) => t['endDate'] == dateStr).toList(),
        'daily': todos.where((t) => t['endDate'] != dateStr).toList(),
      },
    );
  }

  Response _mockFetchTodosByGoal(RequestOptions options) {
    // /api/v1/todos/by-goal/{goalId} 형식에서 goalId 추출
    final parts = options.path.split('/');
    final goalId = parts.isNotEmpty ? parts.last : '';

    final todos = _mockTodos.values
        .where((todo) => todo['goalId']?.toString() == goalId)
        .toList();

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'data': todos},
    );
  }

  Response _mockFetchTodoById(RequestOptions options) {
    // /api/v1/todos/{todoId} 형식에서 todoId 추출
    final parts = options.path.split('/');
    final todoId = parts.isNotEmpty ? parts.last : '';

    if (_mockTodos.containsKey(todoId)) {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'data': _mockTodos[todoId]},
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 404,
      data: {'message': '투두를 찾을 수 없습니다.'},
    );
  }

  Response _mockUpdateTodo(RequestOptions options) {
    // /api/v1/todos/{todoId} 형식에서 todoId 추출
    final parts = options.path.split('/');
    final todoId = parts.length >= 4 ? parts[3] : '';
    final data = options.data as Map<String, dynamic>?;

    if (_mockTodos.containsKey(todoId)) {
      final existingTodo = Map<String, dynamic>.from(_mockTodos[todoId] as Map);
      existingTodo['title'] = data?['title'] ?? existingTodo['title'];
      existingTodo['goalId'] = data?['goalId'] ?? existingTodo['goalId'];
      existingTodo['startDate'] = data?['startDate'] ?? existingTodo['startDate'];
      existingTodo['endDate'] = data?['endDate'] ?? existingTodo['endDate'];
      existingTodo['eisenhower'] = data?['eisenhower'] ?? existingTodo['eisenhower'];
      existingTodo['showOnHome'] = data?['showOnHome'] ?? existingTodo['showOnHome'];
      _mockTodos[todoId] = existingTodo;
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'todoId': int.tryParse(todoId) ?? 0},
    );
  }

  Response _mockToggleTodoStatus(RequestOptions options) {
    // /api/v1/todos/{todoId}/status 형식에서 todoId 추출
    final parts = options.path.split('/');
    final todoId = parts.length >= 4 ? parts[3] : '';

    if (_mockTodos.containsKey(todoId)) {
      final todo = Map<String, dynamic>.from(_mockTodos[todoId] as Map);
      final currentStatus = (todo['status'] as num?)?.toDouble() ?? 0.0;
      final newStatus = currentStatus == 0.0 ? 1.0 : 0.0;
      todo['status'] = newStatus;
      todo['completedAt'] = newStatus == 1.0 ? DateTime.now().toIso8601String() : null;
      _mockTodos[todoId] = todo;

      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'todoId': int.tryParse(todoId) ?? 0,
          'status': newStatus,
          'completedAt': todo['completedAt'],
        },
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 404,
      data: {'message': '투두를 찾을 수 없습니다.'},
    );
  }

  Response _mockDeleteTodo(RequestOptions options) {
    // /api/v1/todos/{todoId} 형식에서 todoId 추출
    final parts = options.path.split('/');
    final todoId = parts.length >= 4 ? parts[3] : '';
    _mockTodos.remove(todoId);

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'message': '투두 삭제 성공'},
    );
  }
}

