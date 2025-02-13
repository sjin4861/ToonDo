import 'package:hive/hive.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/services/goal_service.dart';
import 'package:toondo/services/todo_service.dart';

class DataSyncService {
  final Box<Goal> goalBox;
  final Box<Todo> todoBox;
  final GoalService goalService;
  final TodoService todoService;

  DataSyncService({
    required this.goalBox,
    required this.todoBox,
    required this.goalService,
    required this.todoService,
  });

  // local 데이터를 전부 삭제
  Future<void> clearLocalData() async {
    await todoBox.clear();
    await goalBox.clear();
  }

  // 서버로부터 목표와 todo 데이터를 다시 받아와 local DB 업데이트
  Future<void> syncAllData() async {
    // local 데이터를 먼저 clear
    await clearLocalData();
    // 서버에서 goal 데이터를 받아와 local에 저장
    List<Goal> goals = await goalService.loadGoals();
    for (var goal in goals) {
      await goalBox.put(goal.id.toString(), goal);
    }
    // 서버에서 todo 데이터를 받아와 local에 저장 (TodoService 구현에 맞게 수정)
    await todoService.fetchTodos();
  }
}
