import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:data/constants.dart';
import 'package:domain/repositories/user_repository.dart';

@lazySingleton
class GptRemoteDataSource {
  final http.Client httpClient;
  final UserRepository userRepo;
  GptRemoteDataSource(this.httpClient, this.userRepo);

  Future<String> chat(String prompt) async {
    // Wrap OpenAI call (similar to gpt_repository_impl)
    final uri = Uri.parse('${Constants.OPENAI_URL}/v1/chat/completions');
    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': Constants.SLIMEROLE},
        {'role': 'user', 'content': prompt},
      ],
      'temperature': Constants.TEMPERATURE,
      'max_tokens': Constants.MAX_TOKENS,
    });
    final res = await httpClient.post(uri,
        headers: {
          'Authorization': 'Bearer ${Constants.OPENAI_API_KEY}',
          'Content-Type': 'application/json',
        },
        body: body);
    if (res.statusCode == 200) {
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      final reply = data['choices'][0]['message']['content'] as String;
      return reply;
    }
    throw Exception('GPT error ${res.statusCode}');
  }
}