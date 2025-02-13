// gpt_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:toondo/services/user_service.dart'; // UserService import
// 필요한 경우: import 'package:toondo/services/todo_service.dart';
// 필요한 경우: import 'package:toondo/services/goal_service.dart';

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
    // 개발 단계라서 일단 초기화
    userService.clearConversationLog(); // 대화 내역 초기화 
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
    userPromptBuffer.writeln('');

    print("userPromptBuffer: ");
    print(userPromptBuffer.toString());
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
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        //print(response.headers['content-type']);
        final resultText = data['choices'][0]['message']['content'] as String;

        //GPT의 응답을 대화 로그에 추가
        userService.addConversationLine('슬라임: $resultText');
        print('슬라임 : $resultText');

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

  /// 오늘 해야할 일에 대한 응원 메시지 생성
  Future<String?> getTodoEncouragement() async {
    // 임시: TodoService에서 오늘의 할 일을 가져와야 함 (예: ["Todo 1", "Todo 2"])
    List<String> todos = ["Todo 1", "Todo 2"]; // TODO: 실제 데이터 연동
    final conversationLog = userService.getConversationLog();
    final currentTime = DateTime.now();
    final prompt = StringBuffer();
    prompt.writeln("오늘 해야할 일 목록:");
    for (var item in todos) {
      prompt.writeln("- $item");
    }
    prompt.writeln("\n이 일을 위해 따뜻하고 격려하는 메시지를 만들어줘.");
    prompt.writeln("\n[이전 대화]");
    for (var line in conversationLog) {
      prompt.writeln("- $line");
    }
    prompt.writeln("\n현재 시간: $currentTime");

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': "당신은 따뜻하고 격려하는 어조의 조력자입니다."},
        {'role': 'user', 'content': prompt.toString()},
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
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final resultText = data['choices'][0]['message']['content'] as String;
        userService.addConversationLine('응원: $resultText');
        return resultText;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 오늘 수행한 일에 대한 긍정적 피드백 생성
  Future<String?> getTaskFeedback() async {
    // 임시: TodoService에서 오늘 완료한 일을 가져와야 함 (예: ["Task A", "Task B"])
    List<String> completedTasks = ["Task A", "Task B"]; // TODO: 실제 데이터 연동
    final conversationLog = userService.getConversationLog();
    final currentTime = DateTime.now();
    final prompt = StringBuffer();
    prompt.writeln("오늘 완료한 일 목록:");
    for (var item in completedTasks) {
      prompt.writeln("- $item");
    }
    prompt.writeln("\n이 일들에 대해 긍정적이고 칭찬하는 피드백을 부탁해.");
    prompt.writeln("\n[이전 대화]");
    for (var line in conversationLog) {
      prompt.writeln("- $line");
    }
    prompt.writeln("\n현재 시간: $currentTime");

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': "당신은 긍정적이고 칭찬하는 어조의 코치입니다."},
        {'role': 'user', 'content': prompt.toString()},
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
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final resultText = data['choices'][0]['message']['content'] as String;
        userService.addConversationLine('피드백: $resultText');
        return resultText;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 현재 진행 중인 목표에 대한 동기부여 메시지 생성
  Future<String?> getGoalMotivation() async {
    // 임시: GoalService에서 진행 중인 목표 목록을 가져와야 함 (예: ["Goal X", "Goal Y"])
    List<String> activeGoals = ["Goal X", "Goal Y"]; // TODO: 실제 데이터 연동
    final conversationLog = userService.getConversationLog();
    final currentTime = DateTime.now();
    final prompt = StringBuffer();
    prompt.writeln("현재 진행 중인 목표 목록:");
    for (var item in activeGoals) {
      prompt.writeln("- $item");
    }
    prompt.writeln("\n이 목표들을 위해 동기부여가 되는 메시지를 생성해줘.");
    prompt.writeln("\n[이전 대화]");
    for (var line in conversationLog) {
      prompt.writeln("- $line");
    }
    prompt.writeln("\n현재 시간: $currentTime");

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': "당신은 동기부여를 주는 멘토입니다."},
        {'role': 'user', 'content': prompt.toString()},
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
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final resultText = data['choices'][0]['message']['content'] as String;
        userService.addConversationLine('동기부여: $resultText');
        return resultText;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 사용자가 입력한 감정에 대한 상담 반응 생성
  Future<String?> getEmotionResponse(String emotion) async {
    final conversationLog = userService.getConversationLog();
    final currentTime = DateTime.now();
    final prompt = StringBuffer();
    prompt.writeln("사용자가 입력한 감정: $emotion");
    prompt.writeln("\n이 감정에 대해 공감하고 상담하는 메시지를 생성해줘.");
    prompt.writeln("\n[이전 대화]");
    for (var line in conversationLog) {
      prompt.writeln("- $line");
    }
    prompt.writeln("\n현재 시간: $currentTime");

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'system', 'content': "당신은 공감 능력이 뛰어난 상담사입니다."},
        {'role': 'user', 'content': prompt.toString()},
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
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final resultText = data['choices'][0]['message']['content'] as String;
        userService.addConversationLine('감정 반응: $resultText');
        return resultText;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
