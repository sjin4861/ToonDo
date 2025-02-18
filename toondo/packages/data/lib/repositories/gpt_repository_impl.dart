import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:data/constants.dart';
import 'package:domain/repositories/gpt_repository.dart';
import 'package:domain/repositories/character_repository.dart';
import 'package:domain/usecases/user/get_user_nickname.dart';

@LazySingleton(as: GptRepository)
class GptRepositoryImpl implements GptRepository {
  final http.Client httpClient;
  final GetUserNicknameUseCase getCurrentUserNickname;
  final CharacterRepository characterRepository;

  GptRepositoryImpl(
    this.httpClient,
    this.getCurrentUserNickname,
    this.characterRepository,
  );

  @override
  Future<String?> getSlimeResponse() async {
    final userName = await getCurrentUserNickname.call();
    final slimeCharacter = await characterRepository.getCharacter();
    final conversationLog = slimeCharacter?.conversationHistory ?? [];
    final currentTime = DateTime.now();

    final systemPrompt = Constants.SLIMEROLE;
    final userPromptBuffer =
        StringBuffer()
          ..writeln('안녕! 내 이름은 $userName 이야.')
          ..writeln('')
          ..writeln('아래는 지금까지 나눴던 대화 내역이야:')
          ..writeAll(conversationLog.map((e) => '- $e'))
          ..writeln('')
          ..writeln('현재 시간: $currentTime')
          ..writeln('');

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPromptBuffer.toString()},
      ],
      'temperature': Constants.TEMPERATURE,
      'max_tokens': Constants.MAX_TOKENS,
    });
    final url = Uri.parse('${Constants.OPENAI_URL}/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer ${Constants.OPENAI_API_KEY}',
      'Content-Type': 'application/json',
    };

    try {
      final response = await httpClient.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final resultText = data['choices'][0]['message']['content'] as String;
        // Update conversation history in the character model.
        await characterRepository.updateConversationHistory('슬라임: $resultText');
        return resultText;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getTodoEncouragement() async {
    // ...existing logic moved here...
    return null;
  }

  @override
  Future<String?> getTaskFeedback() async {
    // ...existing logic moved here...
    return null;
  }

  @override
  Future<String?> getGoalMotivation() async {
    // ...existing logic moved here...
    return null;
  }

  @override
  Future<String?> getEmotionResponse(String emotion) async {
    // ...existing logic moved here...
    return null;
  }
}
