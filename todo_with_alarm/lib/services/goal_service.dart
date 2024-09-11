import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_alarm/models/goal.dart';

class GoalService {
  static const String goalKey = 'goal_set';
  static const String goalDataKey = 'goal_data';

  // 사용자가 목표를 설정했는지 확인하는 메서드
  static Future<bool> isGoalSet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(goalKey) ?? false; // 기본값은 false
  }

  // 목표 설정을 저장하는 메서드 (단순한 설정 여부)
  static Future<void> setGoal(bool isSet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(goalKey, isSet);
  }

  // 목표 데이터를 저장하는 메서드
  static Future<void> saveGoal(Goal goal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Goal 객체를 JSON 문자열로 변환
    String goalJson = jsonEncode({
      'name': goal.name,
      'progress': goal.progress,
      'startDate': goal.startDate.toIso8601String(),
      'endDate': goal.endDate.toIso8601String(),
      'isCompleted': goal.isCompleted,
    });

    // SharedPreferences에 저장
    await prefs.setString(goalDataKey, goalJson);
  }

  // 목표 데이터를 불러오는 메서드
  static Future<Goal?> loadGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 저장된 목표 데이터가 없을 경우 null 반환
    String? goalJson = prefs.getString(goalDataKey);
    if (goalJson == null) {
      return null;
    }

    // JSON 문자열을 Map으로 변환
    Map<String, dynamic> goalMap = jsonDecode(goalJson);

    // Goal 객체로 변환하여 반환
    return Goal(
      name: goalMap['name'],
      progress: goalMap['progress'],
      startDate: DateTime.parse(goalMap['startDate']),
      endDate: DateTime.parse(goalMap['endDate']),
      isCompleted: goalMap['isCompleted'],
    );
  }

  // 목표 데이터를 삭제하는 메서드
  static Future<void> clearGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(goalKey); // 목표 설정 여부 삭제
    await prefs.remove(goalDataKey); // 목표 데이터 삭제
  }
}