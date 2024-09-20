// services/goal_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_alarm/models/goal.dart';

class GoalService {
  static const String goalsKey = 'goals_data';

  // 목표 리스트를 저장하는 메서드
  static Future<void> saveGoals(List<Goal> goals) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Goal 객체 리스트를 JSON 문자열로 변환
    List<String> goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();

    // SharedPreferences에 저장
    await prefs.setStringList(goalsKey, goalsJson);
  }

  // 목표 리스트를 불러오는 메서드
  static Future<List<Goal>> loadGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 저장된 목표 데이터가 없을 경우 빈 리스트 반환
    List<String>? goalsJson = prefs.getStringList(goalsKey);
    if (goalsJson == null) {
      return [];
    }

    // JSON 문자열 리스트를 Goal 객체 리스트로 변환
    List<Goal> goals = goalsJson.map((goalStr) {
      Map<String, dynamic> goalMap = jsonDecode(goalStr);
      return Goal.fromJson(goalMap);
    }).toList();

    return goals;
  }

  // 모든 목표를 삭제하는 메서드 (필요 시)
  static Future<void> clearGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(goalsKey);
  }
}