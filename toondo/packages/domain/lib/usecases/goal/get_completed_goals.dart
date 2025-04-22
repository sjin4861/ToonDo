import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:domain/entities/status.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompletedGoalsUseCase {
  final GoalRepository repository;
  GetCompletedGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    final goals = repository.getGoalsLocal();
    return goals.where((goal) => goal.status == Status.completed).toList();
  }
}