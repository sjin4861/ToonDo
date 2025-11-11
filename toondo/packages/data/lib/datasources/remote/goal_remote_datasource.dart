import 'package:domain/entities/status.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:data/models/goal_model.dart';
import 'package:domain/entities/goal.dart';
import 'package:injectable/injectable.dart';
import 'package:data/constants.dart';

@LazySingleton()
class GoalRemoteDataSource {
  final Dio dio;
  final AuthRepository authRepository;

  GoalRemoteDataSource(this.dio, this.authRepository);

  // TODO : readGoal에 status에 따라서 달리 조회할 수 있는데 아직 이 부분 구현 x
  // GET /api/v1/goals
  // GET /api/v1/goals?status=0 진행중
  // GET /api/v1/goals?status=1 완료+포기
  Future<List<Goal>> readGoals() async {
    final options = await _authOptions();
    final resp = await dio.get('/api/v1/goals', options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data as List<dynamic>;
      final models = data.map((item) => GoalModel.fromJson(Map<String, dynamic>.from(item))).toList();
      return models.map((m) => m.toEntity()).toList();
    } else if (status == 403) {
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
      );
    } else if (status == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
      );
    }

    throw Exception('목표 목록 조회 실패 ($status): ${resp.data}');
  }

  Future<Goal> createGoal(Goal goal) async {
    final options = await _authOptions();

    // '마감일 없이 할래요' 기능 - 서버 API에서 endDate null을 허용하지 않으므로 
    // null인 경우 먼 미래 날짜(2099-12-31)로 대체하여 전송
    final endDateToSend = goal.endDate ?? DateTime(2099, 12, 31);
    
    final requestBody = {
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": endDateToSend.toIso8601String().split('T')[0], // null인 경우 2099-12-31 전송
      "icon": goal.icon ?? "",
    };

    final resp = await dio.post('/api/v1/goals', data: requestBody, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200 || status == 201) {
      final data = resp.data;
      // 백엔드가 최소 응답 { goalId, message } 만 내려주는 경우 대응
      if (data is Map &&
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
      final model = GoalModel.fromJson(Map<String, dynamic>.from(data));
      return model.toEntity();
    } else if (status == 403) {
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
      );
    } else if (status == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
      );
    }
    throw Exception('목표 생성 실패 ($status): ${resp.data}');
  }

  Future<void> updateGoal(Goal goal) async {
    final options = await _authOptions();

    // 서버 스펙: endDate 가 null 허용 가능성 → null 그대로 전송, 값이 있으면 yyyy-MM-dd
    final endDateStr = goal.endDate?.toIso8601String().split('T')[0];
    final requestBody = <String, dynamic>{
      "goalName": goal.name,
      "startDate": goal.startDate.toIso8601String().split('T')[0],
      "endDate": endDateStr, // null 허용
      "icon": goal.icon,     // null 허용
    };

    // 경로 후보: 우선 '/api/v1/goals/update/{id}' → 실패 시 기존 '/api/v1/goals/{id}'
    final paths = <String>[
      '/api/v1/goals/update/${goal.id}',
      '/api/v1/goals/${goal.id}',
    ];

    Response resp;
    int status = 0;
    DioException? lastErr;
    for (final path in paths) {
      try {
        // 디버그용 경로/바디 로깅
        print('🛣️ Goal update try: $path body=$requestBody');
        resp = await dio.put(path, data: requestBody, options: options);
        status = resp.statusCode ?? 0;
        print('🛣️ Goal update resp: $status path=$path');
        if (status == 404) {
          // 다른 후보 경로를 계속 시도
          continue;
        }
        if (status != 200) {
          if (status == 403) {
            throw Exception(
              '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
            );
          } else if (status == 400) {
            // 요구사항 반영: 시작일/종료일 검증 실패 등
            throw Exception(
              '잘못된 요청 (400 Bad Request): ${resp.data}',
            );
          } else if (status == 401) {
            throw Exception(
              '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
            );
          } else if (status == 404) {
            throw Exception('리소스를 찾을 수 없습니다. (404): ${resp.data}');
          } else {
            throw Exception('목표 업데이트 실패 ($status): ${resp.data}');
          }
        }
        // 200 성공이면 탈출
        return;
      } on DioException catch (e) {
        lastErr = e;
        // 다음 후보 시도
        continue;
      }
    }
    // 모든 후보 실패
    if (lastErr != null) {
      throw Exception('목표 업데이트 실패: ${lastErr.message}');
    }
    throw Exception('목표 업데이트 실패: 알 수 없는 오류');
  }

  // DELETE /api/v1/goals/{goalId}
  Future<void> deleteGoal(String goalId) async {
    final options = await _authOptions();
    final resp = await dio.delete('/api/v1/goals/$goalId', options: options);
    final status = resp.statusCode ?? 0;
    if (status != 200) {
      if (status == 403) {
        throw Exception(
          '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
        );
      } else if (status == 400) {
        throw Exception(
          '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: ${resp.data}',
        );
      } else if (status == 401) {
        throw Exception(
          '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
        );
      } else {
        throw Exception('목표 삭제 실패 ($status): ${resp.data}');
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
    final options = await _authOptions();

    final requestBody = {
      'status': newStatus.index, // enum의 index로 상태 전달 (0, 1, 2)
    };

    final resp = await dio.put('/api/v1/goals/${goal.id}/status', data: requestBody, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      print('✅ 목표 상태 업데이트 성공');
      if (data is Map) {
        print('message: ${data['message']}');
        print('progress: ${data['progress']}');
      }
      return true;
    } else if (status == 403) {
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
      );
    } else if (status == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): ${resp.data}');
    } else {
      throw Exception('목표 상태 업데이트 실패 ($status): ${resp.data}');
    }
  }

  // TODO : Method PUT -> PATCH로 변경 필요
  Future<bool> updateGoalProgress(Goal goal, double newProgress) async {
    final options = await _authOptions();

    // progress 값 검증 (선택 사항, 서버에서 검증하지만 클라이언트에서도 한번 더)
    if (newProgress < 0 || newProgress > 100) {
      throw Exception('progress 값은 0~100 사이여야 합니다.');
    }

    final requestBody = {
      'progress': newProgress.toInt(), // 서버는 정수 기대할 수도 있으니 int 변환
    };
    final resp = await dio.put('/api/v1/goals/${goal.id}/progress', data: requestBody, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      print('✅ 목표 진행률 업데이트 성공');
      if (data is Map) {
        print('message: ${data['message']}');
        print('progress: ${data['progress']}');
      }
      return true;
    } else if (status == 403) {
      throw Exception(
        '권한 오류 (403 Forbidden): 서버가 요청을 거부했습니다. 토큰 형식이나 권한을 확인하세요. 응답: ${resp.data}',
      );
    } else if (status == 400) {
      throw Exception(
        '잘못된 요청 (400 Bad Request): 요청 형식이 잘못되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 401) {
      throw Exception(
        '인증 오류 (401 Unauthorized): 토큰이 유효하지 않거나 만료되었습니다. 응답: ${resp.data}',
      );
    } else if (status == 500) {
      throw Exception('서버 내부 오류 (500 Internal Server Error): ${resp.data}');
    } else {
      throw Exception('목표 진행률 업데이트 실패 ($status): ${resp.data}');
    }
  }
  // --- Auth Options (cookie 우선, 토큰은 보조) ---
  Future<Options> _authOptions() async {
    // 쿠키 기반 인증이므로 기본적으로 Authorization 헤더는 필요 없음.
    // 단, 로컬 bypass용 토큰은 JWT 형식이 아니므로 헤더 전송을 생략해야 한다.
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
    if (!Constants.disableAuthHeaderAttach && token != null && _looksLikeJwt(token)) {
      headers['Authorization'] = token.startsWith('Bearer') ? token : 'Bearer $token';
    }
    // 옵션: 사용자 숫자 ID 헤더 부착 (테스트/임시)
    if (Constants.useCustomUserIdHeader == true) {
      headers[Constants.customUserIdHeader] = Constants.testUserNumericId.toString();
    }
    return Options(headers: headers);
  }

  bool _looksLikeJwt(String token) => RegExp(r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$').hasMatch(token.replaceFirst('Bearer ', ''));
}

// TODO: 필요 시 endDate 정규화 로직(무기한 -> 특수값) 재도입 고려
