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

  // TODO : readGoal에 status에 따라서 달리 조회할 수 있는데 아직 이 부분 구현 x
  // GET /api/v1/goals
  // GET /api/v1/goals?status=0 진행중
  // GET /api/v1/goals?status=1 완료+포기
  Future<List<Goal>> readGoals() async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals');
    print('📡 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    final response = await client.get(url, headers: headers);

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
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
      );
    } else if (response.statusCode == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
      );
    }

    throw Exception('목표 목록 조회 실패 (${response.statusCode}): $responseBody');
  }

  Future<Goal> createGoal(Goal goal) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals'); // POST create
  print('🚀 요청 헤더: $headers');

    // '마감일 없이 할래요' 기능 - 서버 API에서 endDate null을 허용하지 않으므로 
    // null인 경우 먼 미래 날짜(2099-12-31)로 대체하여 전송
    final endDateToSend = goal.endDate ?? DateTime(2099, 12, 31);
    
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": endDateToSend.toIso8601String().split('T')[0], // null인 경우 2099-12-31 전송
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
      // 백엔드가 최소 응답 { goalId, message } 만 내려주는 경우 대응
      if (data is Map<String, dynamic> &&
          data.containsKey('goalId') &&
          !data.containsKey('goalName')) {
        final newId = data['goalId'].toString();
        print('ℹ️ Minimal goal create response detected. Building Goal locally with id=$newId');
        print('🔍 원본 goal.showOnHome 값: ${goal.showOnHome}');
        final rebuiltGoal = Goal(
          id: newId,
          name: goal.name,
          icon: goal.icon,
          startDate: goal.startDate,
          endDate: goal.endDate,
          progress: goal.progress, // 초기 0.0 가정
          status: goal.status,      // 기본 active 가정
          showOnHome: goal.showOnHome, // showOnHome 값 누락 수정
        );
        print('🔍 재구성된 goal.showOnHome 값: ${rebuiltGoal.showOnHome}');
        return rebuiltGoal;
      }
      final model = GoalModel.fromJson(data);
      return model.toEntity();
    } else if (response.statusCode == 403) {
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
      );
    } else if (response.statusCode == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
      );
    }

    throw Exception('목표 생성 실패 (${response.statusCode}): $responseBody');
  }

  Future<void> updateGoal(Goal goal) async {
  final token = await authRepository.getToken();
  final headers = await _buildAuthHeaders(token);

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/${goal.id}'); // PUT update
    print('🔄 목표 업데이트 요청 URL: $url');
  print('🚀 요청 헤더: $headers');

    // '마감일 없이 할래요' 기능 - 서버 API에서 endDate null을 허용하지 않으므로 
    // null인 경우 먼 미래 날짜(2099-12-31)로 대체하여 전송
    final endDateToSend = goal.endDate ?? DateTime(2099, 12, 31);
    
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": endDateToSend.toIso8601String().split('T')[0], // null인 경우 2099-12-31 전송
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
        throw Exception(
          '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
        );
      } else if (response.statusCode == 400) {
        throw Exception(
          '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
        );
      } else {
        throw Exception('목표 업데이트 실패 (${response.statusCode}): $responseBody');
      }
    }
  }

  // DELETE /api/v1/goals/{goalId}
  Future<void> deleteGoal(String goalId) async {
  final token = await authRepository.getToken();
  final headers = await _buildAuthHeaders(token);

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/$goalId');
    print('🗑️ 목표 삭제 요청 URL: $url');
  print('🚀 요청 헤더: $headers');

    final response = await client.delete(url, headers: headers);

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
        throw Exception(
          '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
        );
      } else if (response.statusCode == 400) {
        throw Exception(
          '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
        );
      } else {
        throw Exception('목표 삭제 실패 (${response.statusCode}): $responseBody');
      }
    }
  }

  // TODO : Method PUT -> PATCH로 변경 필요
  //   - **설명**: 목표 상태를 0(진행중) ↔ 1(완료)로 토글합니다.
  // - ✅ **목표 상태가 `진행 중(0) → 완료(1)`이면 자동으로 progress를 100(1.0)으로 변경**
  // - ✅ **목표 상태가 `완료(1) → 진행 중(0)`변경되 progress 자동 계산됨!**
  // TODO2 : Request Body에 아무것도 안 보내도 됨. 그냥 0->1 / 1->0 상태만 변경
  // TODO3 : 관련해서 status 그냥 boolean으로 변경해도 될 것 같은데 검토 필요
  Future<bool> updateGoalStatus(Goal goal, Status newStatus) async {
  final token = await authRepository.getToken();
  final headers = await _buildAuthHeaders(token);

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/${goal.id}/status'); // PUT or PATCH (백엔드 스펙 기준 사용)
    print('🔄 목표 상태 업데이트 요청 URL: $url');
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
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
      );
    } else if (response.statusCode == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): $responseBody');
    } else {
      throw Exception('목표 상태 업데이트 실패 (${response.statusCode}): $responseBody');
    }
  }

  // TODO : Method PUT -> PATCH로 변경 필요
  Future<bool> updateGoalProgress(Goal goal, double newProgress) async {
  final token = await authRepository.getToken();
  final headers = await _buildAuthHeaders(token);

    // progress 값 검증 (선택 사항, 서버에서 검증하지만 클라이언트에서도 한번 더)
    if (newProgress < 0 || newProgress > 100) {
      throw Exception('progress 값은 0~100 사이여야 합니다.');
    }

  final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/${goal.id}/progress');
    print('📊 목표 진행률 업데이트 요청 URL: $url');
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
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: $responseBody',
      );
    } else if (response.statusCode == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: $responseBody',
      );
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): $responseBody');
    } else {
      throw Exception('목표 진행률 업데이트 실패 (${response.statusCode}): $responseBody');
    }
  }
  // --- Auth Header Builder ---
  Future<Map<String, String>> _buildAuthHeaders(String? token) async {
    // 1) 정상 JWT 사용
    if (token != null) {
      String authToken = token;
      if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
        authToken = 'Bearer $token';
      }
      return {
        'Authorization': authToken,
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
    // 2) 토큰 없고 Custom User Header 허용 시
    if (Constants.useCustomUserIdHeader) {
      return {
        Constants.customUserIdHeader: Constants.testUserNumericId.toString(),
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
    // 3) 둘 다 불가 → 예외
    throw Exception('인증 수단이 없습니다. (JWT/CustomUserHeader 모두 미사용)');
  }
}

// TODO: 필요 시 endDate 정규화 로직(무기한 -> 특수값) 재도입 고려
