// 원격 PostgreSQL(HTTP API)으로 Goal 데이터를 관리하는 Repository
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toondo/constants.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/services/auth_service.dart';

class GoalRemoteDataSource {
  http.Client client = http.Client();
  AuthService authService = AuthService();

  Future<List<Goal>> readGoals() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/list');
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(utf8Body);
      return data.map((item) => Goal.fromJsonApi(item)).toList();
    }
    throw Exception('Failed to read goals: ${response.body}');
  }
  
  Future<Goal> createGoal(Goal goal) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/create');
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    final response = await client.post(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(utf8Body);
      return Goal.fromJsonApi(data);
    }
    throw Exception('Failed to create goal: ${response.body}');
  }

  Future<void> updateGoal(Goal goal) async {
    if (goal.id == null) throw Exception('Goal ID가 없습니다.');
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/update/${goal.id}');
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    final response = await client.put(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update goal: ${response.body}');
    }
  }
  
  Future<void> deleteGoal(String goalId) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/delete/$goalId');
    final response = await client.delete(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete goal: ${response.body}');
    }
  }
}
