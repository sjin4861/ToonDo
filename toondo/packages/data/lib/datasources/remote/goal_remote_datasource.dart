import 'dart:convert';
import 'package:domain/entities/status.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:data/models/goal_model.dart';
import 'package:domain/entities/goal.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GoalRemoteDataSource {
  final http.Client client;
  final AuthRepository authRepository;

  GoalRemoteDataSource(this.client, this.authRepository);

  Future<List<Goal>> readGoals() async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    final url = Uri.parse('${Constants.baseUrl}/goals/list');
    print('📡 요청 URL: $url');
    
    // 토큰 형식 확인 및 수정 (Bearer 프리픽스가 중복되지 않도록)
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');

    final response = await client.get(
      url,
      headers: headers,
    );

    print('📥 응답 코드: ${response.statusCode}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(responseBody);
      final models = data.map((item) => GoalModel.fromJson(item)).toList();
      return models.map((model) => model.toEntity()).toList();
    } else if (response.statusCode == 403) {
      throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 401) {
      throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
    }
    
    throw Exception('목표 목록 조회 실패 (${response.statusCode}): $responseBody');
  }

  Future<Goal> createGoal(Goal goal) async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    print('🪪 JWT 토큰: $token');
    
    final url = Uri.parse('${Constants.baseUrl}/goals/create');
    
    // 토큰 형식 확인 및 수정 (Bearer 프리픽스가 중복되지 않도록)
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');
    
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    
    print('🚀 요청 URL: $url');
    print('🚀 요청 바디: $requestBody');
    
    final response = await client.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    
    print('📥 응답 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseBody);
      final model = GoalModel.fromJson(data);
      return model.toEntity();
    } else if (response.statusCode == 403) {
      throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 401) {
      throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
    }
    
    throw Exception('목표 생성 실패 (${response.statusCode}): $responseBody');
  }

  Future<void> updateGoal(Goal goal) async {
    if (goal.id == null) {
      throw Exception('Goal ID가 없습니다.');
    }
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    
    final url = Uri.parse('${Constants.baseUrl}/goals/update/${goal.id}');
    print('🔄 목표 업데이트 요청 URL: $url');
    
    // 토큰 형식 확인 및 수정 (Bearer 프리픽스가 중복되지 않도록)
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');
    
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": goal.endDate.toIso8601String().split('T')[0],
      "icon": goal.icon ?? "",
    };
    
    print('🚀 요청 바디: $requestBody');
    
    final response = await client.put(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    
    print('📥 응답 코드: ${response.statusCode}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }
    
    if (response.statusCode != 200) {
      if (response.statusCode == 403) {
        throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
      } else if (response.statusCode == 400) {
        throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
      } else if (response.statusCode == 401) {
        throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
      } else {
        throw Exception('목표 업데이트 실패 (${response.statusCode}): $responseBody');
      }
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    
    final url = Uri.parse('${Constants.baseUrl}/goals/delete/$goalId');
    print('🗑️ 목표 삭제 요청 URL: $url');
    
    // 토큰 형식 확인 및 수정
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');
    
    final response = await client.delete(
      url,
      headers: headers,
    );
    
    print('📥 응답 코드: ${response.statusCode}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }
    
    if (response.statusCode != 200) {
      if (response.statusCode == 403) {
        throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
      } else if (response.statusCode == 400) {
        throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
      } else if (response.statusCode == 401) {
        throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
      } else {
        throw Exception('목표 삭제 실패 (${response.statusCode}): $responseBody');
      }
    }
  }

  Future<bool> updateGoalStatus(Goal goal, Status newStatus) async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    
    final url = Uri.parse('${Constants.baseUrl}/goals/update/status/${goal.id}');
    print('🔄 목표 상태 업데이트 요청 URL: $url');
    
    // 토큰 형식 확인 및 수정 (Bearer 프리픽스가 중복되지 않도록)
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');
    
    final requestBody = {
      'status': newStatus.index, // enum의 index로 상태 전달 (0, 1, 2)
    };
    
    print('🚀 요청 바디: $requestBody');

    final response = await client.put(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    
    print('📥 응답 코드: ${response.statusCode}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('✅ 목표 상태 업데이트 성공');
      print('message: ${data['message']}');
      print('progress: ${data['progress']}');
      return true;
    } else if (response.statusCode == 403) {
      throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 401) {
      throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): $responseBody');
    } else {
      throw Exception('목표 상태 업데이트 실패 (${response.statusCode}): $responseBody');
    }
  }

  Future<bool> updateGoalProgress(Goal goal, double newProgress) async {
    final token = await authRepository.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다.');
    }
    
    // progress 값 검증 (선택 사항, 서버에서 검증하지만 클라이언트에서도 한번 더)
    if (newProgress < 0 || newProgress > 100) {
      throw Exception('progress 값은 0~100 사이여야 합니다.');
    }
    
    final url = Uri.parse('${Constants.baseUrl}/goals/update/progress/${goal.id}');
    print('📊 목표 진행률 업데이트 요청 URL: $url');
    
    // 토큰 형식 확인 및 수정 (Bearer 프리픽스가 중복되지 않도록)
    String authToken = token;
    if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
      authToken = 'Bearer $token';
    }
    
    final headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    print('🚀 요청 헤더: $headers');
    
    final requestBody = {
      'progress': newProgress.toInt(), // 서버는 정수 기대할 수도 있으니 int 변환
    };
    
    print('🚀 요청 바디: $requestBody');
    
    final response = await client.put(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    
    print('📥 응답 코드: ${response.statusCode}');
    
    // UTF-8 디코딩 처리
    String responseBody = '';
    try {
      responseBody = utf8.decode(response.bodyBytes);
      print('📥 응답 바디: $responseBody');
    } catch (e) {
      print('📥 응답 바디 디코딩 오류: $e');
      responseBody = response.body;
      print('📥 원본 응답 바디: $responseBody');
    }
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('✅ 목표 진행률 업데이트 성공');
      print('message: ${data['message']}');
      print('progress: ${data['progress']}');
      return true;
    } else if (response.statusCode == 403) {
      throw Exception('권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 401) {
      throw Exception('인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): $responseBody');
    } else {
      throw Exception('목표 진행률 업데이트 실패 (${response.statusCode}): $responseBody');
    }
  }
}
