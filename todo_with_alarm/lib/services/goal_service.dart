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
  final String baseUrl = Constants.baseUrl;
  final http.Client httpClient = http.Client();
  final Box<Goal> goalBox;
  final AuthService authService = AuthService();
  final UserService userService;

  GoalService(this.goalBox, this.userService);

  /// [GET] /goals/list
  /// 서버에서 목표 목록을 가져와 로컬(Hive)에 저장한 뒤 반환.
  Future<List<Goal>> loadGoals() async {
    print('loadGoals() called');
    try {
      final token = await authService.getToken();
      if (token == null) {
        throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
      }

      final url = Uri.parse('$baseUrl/goals/list');
      final response = await httpClient.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        List<dynamic> body = jsonDecode(utf8Body);
        // 각 요소를 Goal.fromJson으로 파싱 (아래에서 fromJson 수정해야 함)
        List<Goal> goals = body.map((item) => Goal.fromJsonApi(item)).toList();

        // 로컬 Hive를 업데이트
        await goalBox.clear(); 
        for (var g in goals) {
          // goalId가 String이 아닐 수 있으므로 toString() 처리
          if (g.id != null) {
            await goalBox.put(g.id, g);
          }
        }
        print('Goals loaded successfully: ${goals.length} goals');
        return goals;
      } else {
        throw Exception('Failed to load goals: ${response.body}');
      }
    } catch (e) {
      print('Error loading goals from server: $e');
      // 실패 시 로컬 Hive 데이터 반환
      return getLocalGoals();
    }
  }

  /// 로컬 Hive 박스에 저장된 목표 목록 반환
  List<Goal> getLocalGoals() {
    print('getLocalGoals() called');
    return goalBox.values.toList();
  }

  /// [POST] /goals/create
  /// 새로운 목표를 서버에 생성 후, 로컬 DB(Hive)에 저장
  Future<Goal> createGoal(Goal goal) async {
    print('createGoal() called with goal: ${goal.name}');
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    try {
      final url = Uri.parse('$baseUrl/goals/create');
      // 서버 요구사항에 맞게 body를 구성
      final requestBody = {
        "goalName": goal.name,
        "startDate": goal.startDate.toIso8601String().split('T')[0], // "YYYY-MM-DD" 형식
        "endDate": goal.endDate.toIso8601String().split('T')[0],
        "icon": goal.icon ?? "",
      };

      final response = await httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // API 문서상 "200 Created" 혹은 "201"일 수 있으므로, 일단 200 또는 201 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        // 서버에서 반환된 필드들을 사용해 Goal 인스턴스를 만든다
        final createdGoal = Goal.fromJsonApi(data);
        // 로컬 Hive에 저장
        if (createdGoal.id != null) {
          await goalBox.put(createdGoal.id, createdGoal);
        }
        print('Goal created successfully: ${createdGoal.name}');
        return createdGoal;
      } else {
        throw Exception('Failed to create goal: ${response.body}');
      }
    } catch (e) {
      print('Error creating goal: $e');
      rethrow;
    }
  }

  /// [GET] /goals/detail/{goalId}
  /// 특정 goalId의 상세정보를 불러오기
  Future<Goal?> fetchGoalDetail(String goalId) async {
    print('fetchGoalDetail() called with goalId: $goalId');
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    try {
      final url = Uri.parse('$baseUrl/goals/detail/$goalId');
      final response = await httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final detailGoal = Goal.fromJsonApi(data);
        // 로컬에도 업데이트해줄 수 있음
        if (detailGoal.id != null) {
          await goalBox.put(detailGoal.id, detailGoal);
        }
        print('Goal detail fetched successfully: ${detailGoal.name}');
        return detailGoal;
      } else if (response.statusCode == 404) {
        print('목표를 찾을 수 없습니다. (goalId: $goalId)');
        return null;
      } else {
        throw Exception('Failed to fetch goal detail: ${response.body}');
      }
    } catch (e) {
      print('Error fetching goal detail: $e');
      rethrow;
    }
  }

  /// [PUT] /goals/update/{goalId}
  /// 서버에 목표 정보를 수정하고 로컬 DB도 업데이트
  Future<void> updateGoal(Goal goal) async {
    print('updateGoal() called with goal: ${goal.name}');
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    if (goal.id == null) {
      throw Exception('Goal ID가 없습니다.');
    }

    try {
      final url = Uri.parse('$baseUrl/goals/update/${goal.id}');
      final requestBody = {
        "goalName": goal.name,
        "startDate": goal.startDate.toIso8601String().split('T')[0],
        "endDate": goal.endDate.toIso8601String().split('T')[0],
        "icon": goal.icon ?? "",
      };

      final response = await httpClient.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // 성공적으로 수정됐다면 로컬 Hive에 업데이트
        await goalBox.put(goal.id, goal);
        print('Goal updated successfully: ${goal.name}');
      } else if (response.statusCode == 404) {
        print('해당 목표를 찾을 수 없습니다. (goalId: ${goal.id})');
      } else {
        throw Exception('Failed to update goal: ${response.body}');
      }
    } catch (e) {
      print('Error updating goal: $e');
      rethrow;
    }
  }

  /// [DELETE] /goals/delete/{goalId}
  /// 서버에서 목표 삭제 후, 로컬 DB에서도 삭제
  Future<void> deleteGoal(String id) async {
    print('deleteGoal() called with goalId: $id');
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    try {
      final url = Uri.parse('$baseUrl/goals/delete/$id');
      final response = await httpClient.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 서버에서 정상 삭제 -> 로컬에서도 삭제
        await goalBox.delete(id);
        print('Goal deleted successfully: $id');
      } else if (response.statusCode == 404) {
        print('해당 목표를 찾을 수 없습니다. (goalId: $id)');
      } else {
        throw Exception('Failed to delete goal: ${response.body}');
      }
    } catch (e) {
      print('Error deleting goal: $e');
      rethrow;
    }
  }
  
  /// 목표 완료 상태 토글
  Future<void> toggleGoalCompletion(String id) async {
    print('toggleGoalCompletion() called with goalId: $id');
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
          headers: {'Content-Type': 'application/json; charset=UTF-8',},
          body: jsonEncode(goal.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update goal completion on server');
        }
        print('Goal completion toggled successfully: ${goal.name}');
      } catch (e) {
        print('Error updating goal completion on server: $e');
        // 서버 동기화 실패 시 로컬 데이터는 이미 업데이트되어 있으므로 추가 조치는 필요 없음
      }
    }
  }

  Future<void> giveUpGoal(String goalId) async {
    print('giveUpGoal() called with goalId: $goalId');
    final goal = goalBox.get(goalId);
    if (goal != null) {
      goal.status = GoalStatus.givenUp; // 상태를 givenUp으로 변경
      await goal.save();

      // 원격 서버에 동기화
      try {
        final url = Uri.parse('$baseUrl/goals/$goalId');
        final response = await httpClient.put(
          url,
          headers: {'Content-Type': 'application/json; charset=UTF-8',},
          body: jsonEncode(goal.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update goal status on server');
        }
        print('Goal given up successfully: ${goal.name}');
      } catch (e) {
        print('Error updating goal status on server: $e');
        // 서버 동기화 실패 시 로컬 데이터는 이미 업데이트되어 있으므로 추가 조치는 필요 없음
      }
    }
  }
  Future<int> getUnsyncedGoalsCount() async {
    print('getUnsyncedGoalsCount() called');
    return goalBox.values.where((goal) => !goal.isSynced).length;
  }

  Future<List<Goal>> getUnsyncedGoals() async {
    print('getUnsyncedGoals() called');
    return goalBox.values.where((goal) => !goal.isSynced).toList();
  }

  Future<void> fetchGoals() async {
    print('fetchGoals() called');
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
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(utf8Body);
        final List<Goal> goals = data.map((g) => Goal.fromJson(g)).toList();

        // 기존 로컬 Goal 초기화 후 새 Goal 목록 저장
        await goalBox.clear();
        final Map<String, Goal> goalMap = {
          for (var goal in goals) if (goal.id != null) goal.id!: goal
        };
        await goalBox.putAll(goalMap);

        // 마지막 동기화 시각 기록
        await userService.updateGoalSyncTime(DateTime.now());
        print('Goals fetched successfully: ${goals.length} goals');
      } else {
        throw Exception('Failed to fetch goals: ${response.body}');
      }
    } catch (e) {
      print('Error fetching goals: $e');
      rethrow;
    }
  }

  Future<void> commitGoal() async {
    print('commitGoal() called');
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
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(unsyncedGoals.map((goal) => goal.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(utf8Body);
        // 동기화 성공 시 각 Goal의 isSynced = true로 만들고 저장
        for (var goal in unsyncedGoals) {
          goal.isSynced = true;
          await goal.save();
        }
        // 동기화 성공 시점 기록
        await userService.updateGoalSyncTime(DateTime.now());
        print('Goals committed successfully');
      } else {
        throw Exception('Failed to commit goals: ${response.body}');
      }
    } catch (e) {
      print('Error commit goals: $e');
      rethrow;
    }
  }
}