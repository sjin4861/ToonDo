import 'dart:convert';
import 'package:domain/entities/status.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:data/models/goal_model.dart';
import 'package:domain/entities/goal_status.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/auth/get_token.dart';

class GoalRemoteDataSource {
  http.Client client = http.Client();
  final GetTokenUseCase getTokenUseCase = GetIt.instance<GetTokenUseCase>();

  Future<List<Goal>> readGoals() async {
    final token = await getTokenUseCase();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/list');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(utf8Body);
      final models = data.map((item) => GoalModel.fromJson(item)).toList();
      return models.map((model) => model.toEntity()).toList();
    }
    throw Exception('Failed to read goals: ${response.body}');
  }

  Future<Goal> createGoal(Goal goal) async {
    final token = await getTokenUseCase();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/create');
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(utf8Body);
      final model = GoalModel.fromJson(data);
      return model.toEntity();
    }
    throw Exception('Failed to create goal: ${response.body}');
  }

  Future<void> updateGoal(Goal goal) async {
    if (goal.id == null) {
      throw Exception('Goal ID가 없습니다.');
    }
    final token = await getTokenUseCase();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/update/${goal.id}');
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    final response = await client.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update goal: ${response.body}');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final token = await getTokenUseCase();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    final url = Uri.parse('${Constants.baseUrl}/goals/delete/$goalId');
    final response = await client.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete goal: ${response.body}');
    }
  }

  // 업데이트 메서드
  Future<bool> updateGoalStatus(Goal goal, Status newStatus) async {
    final token = await getTokenUseCase();

    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    final url = Uri.parse('${Constants.baseUrl}/goals/update/status/${goal.id}');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'status': newStatus.index, // enum의 index로 상태 전달 (0, 1, 2)
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('✅ 목표 상태 업데이트 성공');
      print('message: ${data['message']}');
      print('progress: ${data['progress']}');
      return true;
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      throw Exception('잘못된 요청: ${error['error']}');
    } else if (response.statusCode == 401) {
      throw Exception('인증 실패: JWT 토큰이 유효하지 않습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류가 발생했습니다.');
    } else {
      throw Exception('알 수 없는 오류 발생: ${response.statusCode} / ${response.body}');
    }
  }

  Future<bool> updateGoalProgress(Goal goal, double newProgress) async {
    // 1. 토큰 가져오기
    final token = await getTokenUseCase();

    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    // 2. progress 값 검증 (선택 사항, 서버에서 검증하지만 클라이언트에서도 한번 더)
    if (newProgress < 0 || newProgress > 100) {
      throw Exception('progress 값은 0~100 사이여야 합니다.');
    }

    // 3. URL 생성
    final url = Uri.parse('${Constants.baseUrl}/goals/update/progress/${goal.id}');

    // 4. PUT 요청 보내기
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'progress': newProgress.toInt(), // 서버는 정수 기대할 수도 있으니 int 변환 추천
      }),
    );

    // 5. 응답 처리
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ 목표 progress 업데이트 성공');
      print('message: ${data['message']}');
      print('progress: ${data['progress']}');
      return true;
      // 만약 로컬에서 goal 객체를 업데이트하거나 UI 반영하려면 여기에 작성하면 돼!
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      throw Exception('잘못된 요청: ${error['error']}');
    } else if (response.statusCode == 401) {
      throw Exception('인증 실패: JWT 토큰이 유효하지 않습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류가 발생했습니다.');
    } else {
      throw Exception('알 수 없는 오류 발생: ${response.statusCode} / ${response.body}');
    }
  }
}
