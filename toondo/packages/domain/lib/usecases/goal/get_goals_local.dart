import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGoalsLocalUseCase {
  final GoalRepository repository;
  GetGoalsLocalUseCase(this.repository);

  Future<List<Goal>> call() async {
    return repository.getGoalsLocal();
  }
}