import 'package:domain/entities/slime_response.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SlimeOnMessageUseCase {
  final SlimeRepository _repo;
  SlimeOnMessageUseCase(this._repo);

  Future<SlimeResponse> call({
    required String text,
    List<Goal> goals = const [],
    List<Todo> todos = const [],
  }) =>
      _repo.processMessage(text: text, goals: goals, todos: todos);
}
