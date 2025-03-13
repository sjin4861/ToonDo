import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/status.dart';

@injectable
class GetGivenUpGoalsUseCase {
  final GoalRepository repository;

  GetGivenUpGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = await repository.getLocalGoals();
    // 포기한 목표: goal.status가 giveup인 경우
    return goals.where((goal) => goal.status == Status.active).toList();
  }
}
