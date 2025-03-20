import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/status.dart';

@injectable
class GetInProgressGoalsUseCase {
  final GoalRepository repository;

  GetInProgressGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = await repository.getLocalGoals();
    final now = DateTime.now();
    // 진행 중: 아직 마감일이 안 지났으며, 포기한 적이 없는 경우
    return goals.where((goal) => goal.endDate.isAfter(now)
        && goal.status != Status.givenUp).toList();
  }
}
