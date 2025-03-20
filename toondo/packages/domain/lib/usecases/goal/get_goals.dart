import 'package:injectable/injectable.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class GetGoalsUseCase {
  final GoalRepository repository;

  GetGoalsUseCase(this.repository);

  List<Goal> call() {
    return repository.getLocalGoals();
  }
}
