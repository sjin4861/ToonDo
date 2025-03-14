// 로컬 저장소(Hive)에서 Goal 데이터를 관리하는 Repository
import 'package:domain/entities/goal_status.dart';
import 'package:domain/entities/status.dart';
import 'package:hive/hive.dart';
import 'package:data/models/goal_model.dart';
import 'package:domain/entities/goal.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GoalLocalDatasource {
  Box<GoalModel> goalBox;
  Box<GoalStatus> goalStatusBox;

  GoalLocalDatasource(this.goalBox, this.goalStatusBox);
  Future<void> clearGoals() async {
    await goalBox.clear();
  }

  Future<void> saveGoal(Goal goal) async {
    final model = GoalModel.fromEntity(goal);
    if (model.id != null) {
      await goalBox.put(model.id, model);
    }
  }

  List<Goal> getAllGoals() {
    return goalBox.values.map((model) => model.toEntity()).toList();
  }

  Future<void> updateGoal(Goal goal) async {
    await saveGoal(goal);
  }

  // New: Delete a goal locally using its ID.
  Future<void> deleteGoal(String goalId) async {
    await goalBox.delete(goalId);
  }

  Future<void> updateGoalStatus(Goal goal, Status newStatus) async {
    String goalId = goal.id;
    GoalStatus goalStatus = GoalStatus(goalId: goalId, status: newStatus);
    goalStatusBox.put(goalId, goalStatus);
  }

  Future<void> updateGoalProgress(Goal goal, double newProgress) async {
    String goalId = goal.id;
    goalBox.get(goalId)!.progress = newProgress;
  }
}
