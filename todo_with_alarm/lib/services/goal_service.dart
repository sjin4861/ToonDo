// lib/services/goal_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/constants.dart'; // constants.dart 임포트

class GoalService {
  final String baseUrl = Constants.baseUrl; // constants.dart에서 baseUrl 가져오기
  final http.Client httpClient = http.Client(); // httpClient를 내부에서 인스턴스화
  final Box<Goal> goalBox; // Hive 박스 인스턴스

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
      List<Goal> goals = goalBox.values.toList();
      return goals;
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

  /// 원격 서버에 목표 저장
  Future<void> saveGoals(List<Goal> goals) async {
    try {
      final url = Uri.parse('$baseUrl/goals'); // 엔드포인트 수정
      final response = await httpClient.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goals.map((goal) => goal.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        // 성공 시 로컬에도 동기화
        await saveLocalGoals(goals);
      } else {
        throw Exception('Failed to save goals to server');
      }
    } catch (e) {
      print('Error saving goals to server: $e');
      throw Exception('Failed to save goals');
    }
  }

  /// 원격 서버에 새로운 목표 생성 및 로컬 Hive 박스에 저장
  Future<Goal> createGoal(Goal goal) async {
    try {
      final url = Uri.parse('$baseUrl/goals'); // 엔드포인트 수정
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 201) {
        Goal createdGoal = Goal.fromJson(jsonDecode(response.body));

        // 로컬 Hive 박스에 저장
        await goalBox.put(createdGoal.id, createdGoal);

        return createdGoal;
      } else {
        throw Exception('Failed to create goal on server');
      }
    } catch (e) {
      print('Error creating goal on server: $e');
      // 서버에서 생성하지 못한 경우 로컬 Hive 박스에만 저장 (오프라인 지원)
      await goalBox.put(goal.id, goal);
      return goal;
    }
  }

  /// 원격 서버에 목표 업데이트 및 로컬 Hive 박스에 저장
  Future<void> updateGoal(Goal goal) async {
    try {
      final url = Uri.parse('$baseUrl/goals/${goal.id}'); // 엔드포인트 수정
      final response = await httpClient.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 200) {
        // 성공 시 로컬에도 업데이트
        await goalBox.put(goal.id, goal);
      } else {
        throw Exception('Failed to update goal on server');
      }
    } catch (e) {
      print('Error updating goal on server: $e');
      // 서버에서 업데이트하지 못한 경우 로컬 Hive 박스에만 업데이트 (오프라인 지원)
      await goalBox.put(goal.id, goal);
      throw Exception('Failed to update goal');
    }
  }

  /// 원격 서버에 목표 삭제 및 로컬 Hive 박스에서 삭제
  Future<void> deleteGoal(String id) async {
    try {
      final url = Uri.parse('$baseUrl/goals/$id'); // 엔드포인트 수정
      final response = await httpClient.delete(url);

      if (response.statusCode == 204) {
        // 성공 시 로컬에서도 삭제
        await goalBox.delete(id);
      } else {
        throw Exception('Failed to delete goal on server');
      }
    } catch (e) {
      print('Error deleting goal on server: $e');
      // 서버에서 삭제하지 못한 경우 로컬 Hive 박스에서만 삭제 (오프라인 지원)
      await goalBox.delete(id);
      throw Exception('Failed to delete goal');
    }
  }
}