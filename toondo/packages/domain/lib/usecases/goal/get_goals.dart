import 'package:injectable/injectable.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';

@injectable
class GetGoalsUseCaseUseCase {
  final GoalRepository repository;

  GetGoalsUseCaseUseCase(this.repository);

  List<Goal> call() {
    return repository.getLocalGoals();
  }
}
