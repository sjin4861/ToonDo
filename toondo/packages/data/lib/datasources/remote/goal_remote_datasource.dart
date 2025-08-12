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
  // GET /api/v1/goals?status=0 status=0: 진행중
  // GET /api/v1/goals?status=1 status=1: 완료 + 포기
  Future<List<Goal>> readGoals() async {
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    final url = Uri.parse('${Constants.baseUrl}/api/v1/goals');
    print('📡 요청 URL: $url');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
      'Content-Type': 'application/json; charset=UTF-8',
    };

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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    final url = Uri.parse('${Constants.baseUrl}/api/v1/goals');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/${goal.id}');
    print('🔄 목표 업데이트 요청 URL: $url');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
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

  // TODO : URL: api/v1/goals/{goalId}인데 Delete인지 확인 필요
  Future<void> deleteGoal(String goalId) async {
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    final url = Uri.parse('${Constants.baseUrl}/api/v1/goals/$goalId');
    print('🗑️ 목표 삭제 요청 URL: $url');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
      'Content-Type': 'application/json; charset=UTF-8',
    };

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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    final url = Uri.parse(
      '${Constants.baseUrl}/api/v1/goals/${goal.id}/status',
    );
    print('🔄 목표 상태 업데이트 요청 URL: $url');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)

    // progress 값 검증 (선택 사항, 서버에서 검증하지만 클라이언트에서도 한번 더)
    if (newProgress < 0 || newProgress > 100) {
      throw Exception('progress 값은 0~100 사이여야 합니다.');
    }

    final url = Uri.parse(
      '${Constants.baseUrl}/api/v1/goals/${goal.id}/progress',
    );
    print('📊 목표 진행률 업데이트 요청 URL: $url');

    final headers = {
      'X-Custom-User-Id': '15', // 임시 사용자 ID
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
}
