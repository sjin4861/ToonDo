import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/status.dart';

@injectable
class GetCompletedGoalsUseCase {
  final GoalRepository repository;

  GetCompletedGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = await repository.getLocalGoals();
    final now = DateTime.now();
    // 완료: 마감일이 지난 목표 중 포기하지 않은 경우
    return goals.where((goal) => goal.endDate.isBefore(now)
        && goal.status != Status.givenUp).toList();
  }
}
