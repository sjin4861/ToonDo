import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadGoalsUseCase {
  final GoalRepository repository;

  ReadGoalsUseCase(this.repository);

  Future<List<Goal>> call() async {
    return await repository.readGoals();
  }
}
