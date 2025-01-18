// lib/services/goal_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/constants.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import 'package:todo_with_alarm/services/auth_service.dart';
import 'package:todo_with_alarm/services/user_service.dart'; // constants.dart 임포트

class GoalService {
  final String baseUrl = Constants.baseUrl; // constants.dart에서 baseUrl 가져오기
  final http.Client httpClient = http.Client(); // httpClient를 내부에서 인스턴스화
  final Box<Goal> goalBox; // Hive 박스 인스턴스
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  GoalService(this.goalBox); // 생성자에서 goalBox 받기

  /// 원격 서버에서 목표를 불러와 로컬 Hive 박스에 저장
  Future<List<Goal>> loadGoals() async {
    try {
      final url = Uri.parse('$baseUrl/goals'); // 엔드포인트 수정
      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Goal> goals = body.map((dynamic item) => Goal.fromJson(item)).toList();

        // 로컬 Hive 박스에 저장
        await goalBox.clear(); // 기존 데이터 삭제 (필요에 따라 제거)
        for (var goal in goals) {
          await goalBox.put(goal.id, goal);
        }

        return goals;
      } else {
        throw Exception('Failed to load goals from server');
      }
    } catch (e) {
      print('Error loading goals from server: $e');
      // 서버에서 불러오지 못하면 로컬 Hive 박스에서 불러오기
      return getLocalGoals();
    }
  }

  /// 로컬 Hive 박스에 저장된 모든 목표를 반환
  List<Goal> getLocalGoals() {
    return goalBox.values.toList();
  }

  /// 로컬 Hive 박스에 목표 저장
  Future<void> saveLocalGoals(List<Goal> goals) async {
    await goalBox.clear();
    for (var goal in goals) {
      await goalBox.put(goal.id, goal);
    }
  }

  /// 로컬 Hive 박스에 목표 저장 및 원격 서버에 동기화
  Future<void> saveGoals(List<Goal> goals) async {
    // 로컬 데이터베이스에 먼저 저장
    await saveLocalGoals(goals);

    // 원격 서버에 동기화
    try {
      final url = Uri.parse('$baseUrl/goals');
      final response = await httpClient.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goals.map((goal) => goal.toJson()).toList()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save goals to server');
      }
    } catch (e) {
      print('Error saving goals to server: $e');
      // 서버 동기화 실패 시 로컬 데이터는 이미 저장되어 있으므로 추가 조치는 필요 없음
    }
  }

  /// 로컬 Hive 박스에 새로운 목표 생성 및 원격 서버에 동기화
  Future<Goal> createGoal(Goal goal) async {
    // 로컬 데이터베이스에 먼저 저장
    await goalBox.put(goal.id, goal);

    // 원격 서버에 동기화
    try {
      final url = Uri.parse('$baseUrl/goals');
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 201) {
        return Goal.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create goal on server');
      }
    } catch (e) {
      print('Error creating goal on server: $e');
      // 서버 동기화 실패 시 로컬 데이터는 이미 저장되어 있으므로 추가 조치는 필요 없음
      return goal;
    }
  }

  /// 로컬 Hive 박스에 목표 업데이트 및 원격 서버에 동기화
  Future<void> updateGoal(Goal goal) async {
    // 로컬 데이터베이스에 먼저 업데이트
    await goalBox.put(goal.id, goal);

    // 원격 서버에 동기화
    try {
      final url = Uri.parse('$baseUrl/goals/${goal.id}');
      final response = await httpClient.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update goal on server');
      }
    } catch (e) {
      print('Error updating goal on server: $e');
      // 서버 동기화 실패 시 로컬 데이터는 이미 저장되어 있으므로 추가 조치는 필요 없음
    }
  }

  /// 로컬 Hive 박스에서 목표 삭제 및 원격 서버에 동기화
  Future<void> deleteGoal(String id) async {
    // 로컬 데이터베이스에서 먼저 삭제
    await goalBox.delete(id);

    // 원격 서버에 동기화
    try {
      final url = Uri.parse('$baseUrl/goals/$id');
      final response = await httpClient.delete(url);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete goal on server');
      }
    } catch (e) {
      print('Error deleting goal on server: $e');
      // 서버 동기화 실패 시 로컬 데이터는 이미 삭제되어 있으므로 추가 조치는 필요 없음
    }
  }
  /// 목표 완료 상태 토글
  Future<void> toggleGoalCompletion(String id) async {
    final goal = goalBox.get(id);
    if (goal != null) {
      goal.isCompleted = !goal.isCompleted;
      goal.progress = goal.isCompleted ? 100.0 : goal.getExpectedProgress();
      //goal.updatedAt = DateTime.now();
      await goal.save();

      // 원격 서버에 동기화
      try {
        final url = Uri.parse('$baseUrl/goals/$id');
        final response = await httpClient.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(goal.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update goal completion on server');
        }
      } catch (e) {
        print('Error updating goal completion on server: $e');
        // 서버 동기화 실패 시 로컬 데이터는 이미 업데이트되어 있으므로 추가 조치는 필요 없음
      }
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    final goal = goalBox.get(goalId);
    if (goal != null) {
      goal.status = GoalStatus.givenUp; // 상태를 givenUp으로 변경
      await goal.save();

      // 원격 서버에 동기화
      try {
        final url = Uri.parse('$baseUrl/goals/$goalId');
        final response = await httpClient.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(goal.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update goal status on server');
        }
      } catch (e) {
        print('Error updating goal status on server: $e');
        // 서버 동기화 실패 시 로컬 데이터는 이미 업데이트되어 있으므로 추가 조치는 필요 없음
      }
    }
  }
  Future<int> getUnsyncedGoalsCount() async {
    return goalBox.values.where((goal) => !goal.isSynced).length;
  }

  Future<List<Goal>> getUnsyncedGoals() async {
    return goalBox.values.where((goal) => !goal.isSynced).toList();
  }

  Future<void> fetchGoals() async {
    // JWT 토큰이 필요하다면
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    final url = Uri.parse('$baseUrl/goals/all/fetch');
    try {
      final response = await httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Goal> goals = data.map((g) => Goal.fromJson(g)).toList();

        // 기존 로컬 Goal 초기화 후 새 Goal 목록 저장
        await goalBox.clear();
        final Map<String, Goal> goalMap = {
          for (var goal in goals) if (goal.id != null) goal.id!: goal
        };
        await goalBox.putAll(goalMap);

        // 마지막 동기화 시각 기록
        await userService.updateGoalSyncTime(DateTime.now());
      } else {
        throw Exception('Failed to fetch goals: ${response.body}');
      }
    } catch (e) {
      print('Error fetching goals: $e');
      rethrow;
    }
  }

  Future<void> commitGoal() async {
    final List<Goal> unsyncedGoals = goalBox.values.where((g) => !g.isSynced).toList();
    if (unsyncedGoals.isEmpty) {
      return; // 동기화할 항목이 없으면 종료
    }

    // JWT 토큰 획득
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    // 서버에 PUT 또는 POST 등 원하는 방식으로 일괄 전송
    final url = Uri.parse('$baseUrl/goals/all/commit');
    try {
      final response = await httpClient.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(unsyncedGoals.map((goal) => goal.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        // 동기화 성공 시 각 Goal의 isSynced = true로 만들고 저장
        for (var goal in unsyncedGoals) {
          goal.isSynced = true;
          await goal.save();
        }
        // 동기화 성공 시점 기록
        await userService.updateGoalSyncTime(DateTime.now());
      } else {
        throw Exception('Failed to commit goals: ${response.body}');
      }
    } catch (e) {
      print('Error commit goals: $e');
      rethrow;
    }
  }
}