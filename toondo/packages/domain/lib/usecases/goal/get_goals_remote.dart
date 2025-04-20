import 'package:domain/entities/goal.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGoalsRemoteUseCase {
  final GoalRepository repository;
  GetGoalsRemoteUseCase(this.repository);

  Future<List<Goal>> call() async {
    return repository.fetchGoalsRemote();
  }
}