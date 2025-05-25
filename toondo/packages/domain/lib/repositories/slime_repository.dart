import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/entities/todo.dart';

abstract class SlimeRepository {
  // Main high‑level interactions
  Future<SlimeResponse> processMessage({
    required String text,
    List<Goal> goals,
    List<Todo> todos,
  });

  Future<SlimeResponse> processGesture(Gesture gesture);

  // App‑wide chat toggle
  Future<void> setChatEnabled(bool enabled);

  // Optionally expose stream for reactive chat‑enabled state
  Stream<bool> get chatEnabled$;

  Future<SlimeCharacter?> getCharacter();                 // 프로필/프롬프트 등
  Future<void> updateConversationHistory(String newLine); // 대화 로그 저장
}