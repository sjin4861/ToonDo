// services/goal_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

class GoalService {
  static const String goalsKey = 'goals_data';

  // 목표 업데이트 메서드 추가
  static Future<void> updateGoal(Goal updatedGoal) async {
    List<Goal> goals = await loadGoals();
    int index = goals.indexWhere((goal) => goal.id == updatedGoal.id);
    if (index != -1) {
      goals[index] = updatedGoal;
      await saveGoals(goals);
    }
  }

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

  // 목표를 추가하는 메서드
  static Future<void> addGoal(Goal goal) async {
    List<Goal> goals = await loadGoals();
    if (goals.length >= 3) {
      throw Exception('목표는 최대 3개까지 설정할 수 있습니다.');
    }
    goals.add(goal);
    await saveGoals(goals);
  }

  // 목표를 삭제하는 메서드
  static Future<void> deleteGoal(String id) async {
    List<Goal> goals = await loadGoals();
    goals.removeWhere((goal) => goal.id == id);
    await saveGoals(goals);
  }

  // 모든 목표를 삭제하는 메서드
  static Future<void> clearGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(goalsKey);
  }

  static Future<double> calculateGoalProgress(Goal goal) async {
    List<Todo> allTodos = await TodoService.loadAllTodos(); // 모든 투두 항목 로드
    List<Todo> goalTodos = allTodos.where((todo) => todo.goalId == goal.id).toList();

    if (goalTodos.isEmpty) {
      return 0.0;
    }

    double totalProgress = goalTodos.fold(0.0, (sum, todo) => sum + todo.status);
    double averageProgress = totalProgress / goalTodos.length;

    return averageProgress;
  }
}