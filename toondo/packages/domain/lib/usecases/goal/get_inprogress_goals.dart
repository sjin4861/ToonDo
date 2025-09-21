import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:domain/entities/status.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetInProgressGoalsUseCase {
  final GoalRepository repository;
  GetInProgressGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = repository.getGoalsLocal();
    final now = DateTime.now();
    // TODO: '마감일 없이 할래요' 기능 - endDate가 null인 목표도 진행 중으로 포함
    // 진행 중: 아직 종료일이 지나지 않고 포기하지 않은 목표 (마감일이 없는 목표도 포함)
    return goals.where((goal) => 
        (goal.endDate == null || goal.endDate!.isAfter(now)) && 
        goal.status == Status.active
    ).toList();
  }
}