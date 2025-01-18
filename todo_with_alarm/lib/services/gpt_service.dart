// gpt_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:todo_with_alarm/services/user_service.dart'; // UserService import
// 필요한 경우: import 'package:todo_with_alarm/services/todo_service.dart';
// 필요한 경우: import 'package:todo_with_alarm/services/goal_service.dart';

class GptService {
  final UserService userService;
  // 만약 TodoService, GoalService에서도 데이터를 가져와야 한다면 이렇게 추가
  // final TodoService todoService;
  // final GoalService goalService;

  // 생성자에서 의존성 주입
  GptService({
    required this.userService,
    // this.todoService,
    // this.goalService,
  });

  /// 슬라임 캐릭터와 대화하기 위해 GPT API를 호출하는 메서드
  Future<String?> getSlimeResponse() async {
    // 1) UserService에서 필요한 정보들을 불러오기
    final user = userService.getCurrentUser();
    final userName = user?.username ?? '사용자'; // 사용자의 닉네임 (없으면 '사용자')
    final conversationLog = userService.getConversationLog(); // 지금까지의 대화 내역

    // (선택) 현재 시각
    final currentTime = DateTime.now();

    // (선택) Todo / Goal 목록이 필요하다면, TodoService나 GoalService에서 가져오기
    // final todos = await todoService.getUnsyncedTodos(); 
    // final goals = await goalService.getUnsyncedGoals();

    // 2) systemPrompt: 슬라임 캐릭터의 역할(tonality, personality)
    final systemPrompt = Constants.SLIMEROLE;

    // 3) userPrompt: GPT에 전달할 실제 "user" 메시지 구성
    final userPromptBuffer = StringBuffer();
    userPromptBuffer.writeln('안녕! 내 이름은 $userName 이야.');
    userPromptBuffer.writeln('');
    userPromptBuffer.writeln('아래는 지금까지 나눴던 대화 내역이야:');
    for (var line in conversationLog) {
      userPromptBuffer.writeln('- $line');
    }
    userPromptBuffer.writeln('');
    userPromptBuffer.writeln('현재 시간: $currentTime');
    userPromptBuffer.writeln('지금 너는 슬라임 캐릭터 역할이야. 친근하고 유쾌하게 답변해줘!');

    // 4) OpenAI ChatCompletion API 요청 Body
    final body = jsonEncode({
      'model': 'gpt-4o',  
      'messages': [
        {
          'role': 'system',
          'content': systemPrompt,
        },
        {
          'role': 'user',
          'content': userPromptBuffer.toString(),
        },
      ],
      'temperature': Constants.TEMPERATURE,
      'max_tokens': Constants.MAX_TOKENS,
    });

    // 5) HTTP 요청
    final url = Uri.parse('${Constants.OPENAI_URL}/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer ${Constants.OPENAI_API_KEY}',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultText = data['choices'][0]['message']['content'] as String;

        //GPT의 응답을 대화 로그에 추가
        userService.addConversationLine('슬라임: $resultText');

        return resultText;
      } else {
        print('Request failed: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling GPT API: $e');
      return null;
    }
  }
}
