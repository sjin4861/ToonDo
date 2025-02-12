// 로컬 저장소(Hive)에서 Goal 데이터를 관리하는 Repository
import 'package:hive/hive.dart';
import 'package:todo_with_alarm/data/models/goal.dart';

class GoalLocalDatasource {
  Box<Goal> goalBox = Hive.box<Goal>('goals');

  Future<void> clearGoals() async {
    await goalBox.clear();
  }

  Future<void> saveGoal(Goal goal) async {
    if (goal.id != null) {
      await goalBox.put(goal.id, goal);
    }
  }

  List<Goal> getAllGoals() {
    return goalBox.values.toList();
  }
  
  // 추가: Goal 업데이트 (saveGoal로 대체 가능합니다)
  Future<void> updateGoal(Goal goal) async {
    await saveGoal(goal);
  }
  
  // ...필요한 추가 메서드...
}
