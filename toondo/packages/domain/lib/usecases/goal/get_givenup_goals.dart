import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:domain/entities/status.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGivenUpGoalsUseCase {
  final GoalRepository repository;
  GetGivenUpGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = repository.getGoalsLocal();
    // 포기한 목표: status == givenUp
    return goals.where((goal) => goal.status == Status.givenUp).toList();
  }
}