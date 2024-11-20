// lib/services/goal_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/constants.dart'; // constants.dart 임포트

class GoalService {
  final String baseUrl = Constants.baseUrl; // constants.dart에서 baseUrl 가져오기
  final http.Client httpClient = http.Client(); // httpClient를 내부에서 인스턴스화

  GoalService(); // 생성자에서 파라미터 제거

  Future<List<Goal>> loadGoals() async {
    final url = Uri.parse('$baseUrl/todos');
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Goal> goals = body.map((dynamic item) => Goal.fromJson(item)).toList();
      return goals;
    } else {
      throw Exception('Failed to load goals');
    }
  }

  Future<void> saveGoals(List<Goal> goals) async {
    // 전체 데이터를 한 번에 저장하려면 PUT 메서드를 사용할 수 있습니다.
    final url = Uri.parse('$baseUrl/todos');
    final response = await httpClient.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(goals.map((goal) => goal.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save goals');
    }
  }

  Future<Goal> createGoal(Goal goal) async {
    final url = Uri.parse('$baseUrl/todos');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(goal.toJson()),
    );

    if (response.statusCode == 201) {
      return Goal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create goal');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    final url = Uri.parse('$baseUrl/todos/${goal.id}');
    final response = await httpClient.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(goal.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update goal');
    }
  }

  Future<void> deleteGoal(String id) async {
    final url = Uri.parse('$baseUrl/todos/$id');
    final response = await httpClient.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete goal');
    }
  }
}