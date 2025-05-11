// lib/data/repositories/slime_repository_impl.dart
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/datasources/remote/gpt_remote_datasource.dart';
import 'package:data/datasources/local/animation_local_datasource.dart';
import 'package:data/utils/prompt_builder.dart';

@LazySingleton(as: SlimeRepository)
class SlimeRepositoryImpl implements SlimeRepository {
  final GptRemoteDataSource _gpt;
  final AnimationLocalDataSource _anim;
  final _chatEnabled = BehaviorSubject<bool>.seeded(false);

  SlimeRepositoryImpl(this._gpt, this._anim);

  // ───────────────────────────────────────── chat toggle
  @override
  Stream<bool> get chatEnabled$ => _chatEnabled.stream;
  @override
  Future<void> setChatEnabled(bool enabled) async => _chatEnabled.add(enabled);

  // ───────────────────────────────────────── gesture → animation
  @override
  Future<SlimeResponse> processGesture(Gesture gesture) async {
    final key = await _anim.playByGesture(gesture); // 내부에서 랜덤 선택
    return SlimeResponse(animationKey: key);
  }

  // ───────────────────────────────────────── message → GPT → animation
  @override
  Future<SlimeResponse> processMessage({
    required String text,
    List<Goal> goals = const [],
    List<Todo> todos = const [],
  }) async {
    final prompt = PromptBuilder.build(text, goals: goals, todos: todos);
    final reply  = await _gpt.chat(prompt);

    final key = await _anim.playBySentiment(reply);
    return SlimeResponse(message: reply, animationKey: key);
  }

  // ───────────────────────────────────────── cleanup
  void dispose() {
    _chatEnabled.close();
  }
}
