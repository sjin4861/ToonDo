// 로컬 저장소(Hive)에서 Goal 데이터를 관리하는 Repository
import 'package:domain/entities/status.dart';
import 'package:hive/hive.dart';
import 'package:data/models/goal_model.dart';
import 'package:domain/entities/goal.dart';
import 'package:injectable/injectable.dart';
import 'package:data/models/goal_status_enum.dart';
import 'package:data/utils/goal_status_mapper.dart';

@LazySingleton()
class GoalLocalDatasource {
  Box<GoalModel> goalBox;
  Box<GoalStatusEnum> goalStatusBox;

  GoalLocalDatasource(this.goalBox, this.goalStatusBox);
  Future<void> clearGoals() async {
    await goalBox.clear();
  }

  Future<void> saveGoal(Goal goal) async {
    final model = GoalModel.fromEntity(goal);
    await goalBox.put(model.id, model);
  }

  List<Goal> getAllGoals() {
    // 각 GoalModel에서 GoalStatusBox에 저장된 상태를 우선 적용
    return goalBox.values.map((model) {
      final statusEntry = goalStatusBox.get(model.id);
      if (statusEntry != null) {
        model.status = statusEntry;
      }
      return model.toEntity();
    }).toList();
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
    // convert domain Status to storage enum and save
    final enumValue = GoalStatusMapper.fromDomain(newStatus);
    await goalStatusBox.put(goalId, enumValue);
  }

  Future<void> updateGoalProgress(Goal goal, double newProgress) async {
    String goalId = goal.id;
    goalBox.get(goalId)!.progress = newProgress;
  }
}
