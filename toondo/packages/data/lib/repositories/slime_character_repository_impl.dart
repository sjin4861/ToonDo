// lib/data/repositories/slime_repository_impl.dart
import 'package:data/models/slime_character_model.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:hive/hive.dart';
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
  final Box<SlimeCharacterModel> _charBox;
  SlimeCharacterModel? _cached;

  SlimeRepositoryImpl(this._gpt, this._anim, this._charBox);

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
    await _anim.playBySentiment(text, fromUser: true);
    await _anim.playTyping();

    final prompt = PromptBuilder.build(text, goals: goals, todos: todos);
    final reply  = await _gpt.chat(prompt);
    await updateConversationHistory('슬라임: $reply');
    final key = await _anim.playBySentiment(reply, fromUser: false);
    return SlimeResponse(message: reply, animationKey: key);
  }

  // ───────────────────────────────────────── cleanup
  void dispose() {
    _chatEnabled.close();
  }

   /* ───────────────────────── Character 기능 합류 */
  @override
  Future<SlimeCharacter?> getCharacter() async {
    _cached ??= _charBox.get('main');
    return _cached?.toEntity();
  }

  @override
  Future<void> updateConversationHistory(String newLine) async {
    _cached ??= _charBox.get('main') ??
        SlimeCharacterModel(
          name: '슬라임',
          conversationHistory: [],
          rolePrompt: '너는 귀여운 슬라임이야.',
          props: [],
          animationState: 'id',
        );
    _cached!.conversationHistory.add(newLine);
    await _charBox.put('main', _cached!);
  }
}
