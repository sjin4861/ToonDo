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
    final today = DateTime(now.year, now.month, now.day);

    // 진행 중: status가 active이고,
    // 시작일은 오늘 이전/당일, 마감일은 오늘 이후/당일(또는 마감일 없음)
    return goals.where((goal) {
      if (goal.status != Status.active) return false;

      final start = DateTime(
        goal.startDate.year,
        goal.startDate.month,
        goal.startDate.day,
      );
      final hasStarted = !start.isAfter(today);

      if (goal.endDate == null) {
        return hasStarted;
      }

      final end = DateTime(
        goal.endDate!.year,
        goal.endDate!.month,
        goal.endDate!.day,
      );
      final notExpired = !end.isBefore(today);

      return hasStarted && notExpired;
    }).toList();
  }
}