# 인증/회원 기능 연동 가이드 (Flutter / Dio / Cookie 기반 JWT)

## 개요
백엔드가 8083 포트로 전환되었고, 로그인/회원가입/토큰 재발급 정책이 확정되었습니다. 앱은 **JWT 쿠키** 기반 인증을 사용하므로 별도의 Authorization 헤더 대신 쿠키 자동 저장/전송을 활성화해야 합니다.

## 엔드포인트 요약
| 기능 | 메서드 | 엔드포인트 | 요청 Body (현재/예정) | 비고 |
|------|--------|------------|------------------------|------|
| 로그인 | POST | `/login` (우선) / fallback `/users/login` | `{ "id": "loginId", "password": "1234" }` | 서버는 key `id` 사용. 기존 코드 `loginId` -> 통일 필요 |
| 로그아웃 | POST | `/logout` | (빈 바디) | 쿠키 삭제/무효 처리 예상 |
| 회원가입 | POST | `/api/v1/users/signup` | 현재: `{ "loginId", "password" }` / 예정: `+ phoneNumber, nickname` | 기존 코드 경로 수정 필요 |
| 토큰 재발급 | POST | `/api/v1/auth/refreshToken` | (쿠키 자동 포함) | 401 `TOKEN_EXPIRED` 수신 시 호출 |
| 로그인ID 중복 체크 | GET | `/api/v1/users/check-loginid?loginid={id}` | 없음 | 응답 `{ exists: bool }` |
| 계정 탈퇴(예상) | DELETE | `/api/v1/users/delete-account` (추정) | 없음 | 백엔드 스펙 확정 후 수정 |

## Dio 설정 (쿠키 기반 JWT)
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'http://3.36.80.237:8083', // TODO: Constants.baseUrl 통합
  connectTimeout: const Duration(seconds: 8),
  receiveTimeout: const Duration(seconds: 8),
));

final cookieJar = CookieJar();
dio.interceptors.add(CookieManager(cookieJar));

dio.interceptors.add(InterceptorsWrapper(
  onError: (e, handler) async {
    // 401 처리: 백엔드에서 TOKEN_EXPIRED 문구 혹은 코드 제공하는지 확인 필요
    if (e.response?.statusCode == 401 &&
        (e.response?.data.toString().contains('TOKEN_EXPIRED') == true)) {
      try {
        // refresh
        await dio.post('/api/v1/auth/refreshToken');
        // 재시도 (원래 요청 복제)
        final retryRequest = await dio.fetch(e.requestOptions);
        return handler.resolve(retryRequest);
      } catch (refreshErr) {
        return handler.reject(refreshErr is DioException
            ? refreshErr
            : DioException(requestOptions: e.requestOptions, error: refreshErr));
      }
    }
    handler.next(e);
  },
));
```

### TOKEN_EXPIRED 처리 주의사항
1. 중복 재시도 폭주 방지: 한 번의 요청당 최대 1회 refresh 시도 (flag 사용)
2. refresh 실패 시 사용자 로그아웃/재로그인 유도
3. 추후 서버에서 별도 에러 코드(JSON `{code: 'TOKEN_EXPIRED'}`) 제공 시 문자열 파싱 대신 코드 비교 권장

```dart
bool _isRefreshing = false;
final _refreshQueue = <PendingRequest>[]; // 선택: 동시에 여러 401 발생 시 큐 처리
```

## 회원가입/로그인 DTO 정리 (예정 변경 포함)
```dart
class SignupRequest {
  final String loginId;
  final String password;
  final String phoneNumber; // TODO: UI 입력 추가
  final String nickname;    // TODO: UI 입력 추가
  Map<String, dynamic> toJson() => {
    'loginId': loginId,
    'password': password,
    'phoneNumber': phoneNumber,
    'nickname': nickname,
  };
}

class LoginRequest {
  final String id; // 서버 명세에 맞춰 'id'
  final String password;
  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
  };
}
```

## 기존 코드 변경 TODO 목록 (요약)
- `Constants.baseUrl` 포트 8081 -> 8083 (이미 수정) 및 HTTPS 전환 시 `https://` 반영
- `AuthRemoteDataSource.registerUser` 경로 `/users/signup` -> `/api/v1/users/signup`
- 회원가입 payload: phoneNumber, nickname 추가 (ViewModel, UseCase, Repository, DataSource, Entity/Model 확장)
- 로그인 요청 키 `loginId` -> 백엔드 스펙 `id` 통일 (프론트 내부는 loginId 유지, 전송 시 변환)
- http.Client -> Dio 마이그레이션 (쿠키 자동 처리, timeout/인터셉터 구성)
- 401 TOKEN_EXPIRED 인터셉터 재시도 로직 추가
- 테스트 우회(`enableLocalTestBypass`) 프로덕션 빌드에서 비활성화
- 커스텀 헤더 `X-Custom-User-Id` 정책 재검토 (쿠키 기반 JWT 확정 시 제거 가능)
- 회원탈퇴 실제 엔드포인트 확정 후 구현 교체 (현재 mock delay)

## 안전한 마이그레이션 순서 제안
1. Dio 인스턴스 및 CookieManager 추가 (기존 http.Client 병행 유지)
2. AuthRemoteDataSource를 Dio 버전 복제 `auth_remote_datasource_dio.dart` 작성 후 DI 전환 플래그로 스위칭
3. 401 인터셉터 도입 후 QA에서 토큰 만료 시나리오 테스트
4. DTO & UI 확장 (phoneNumber, nickname) - 단계적 feature flag
5. 테스트 우회 제거 및 사용자 흐름 검증
6. HTTPS 전환 (인증서 pinning 필요 시 `SecurityContext` or `dio_http2_adapter` 고려)
7. OAuth(Google/Kakao) 진입: 별도 로그인 버튼 -> 백엔드 OAuth redirect flow 연동

## 에러 처리 권장 패턴
```dart
T safeCall<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on DioException catch (e) {
    // 네트워크/서버 오류 매핑
    throw mapDioError(e);
  } catch (e, st) {
    // 예상 밖 오류 로깅 후 사용자 친화 메시지 변환
    // log('Unexpected: $e', stackTrace: st);
    throw GenericAppException('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
  }
}
```

## 향후 작업 (백엔드 예정 반영)
- HTTPS 전환: dev/stage/prod 환경 분리 (`--dart-define=ENV=prod`)
- Google/Kakao OAuth: WebView / CustomTab / native SDK 비교 후 선택, 백엔드 redirect 처리 후 쿠키 세팅
- Refresh Token 동시성 처리 개선: 여러 401 동시 발생 시 단일 refresh 후 대기중 요청 재시도
- Observability: 실패율/토큰 재발급 횟수 추적 (Sentry/Crashlytics + custom logs)

## 체크리스트 (최종 배포 전)
- [ ] 모든 엔드포인트 200/에러 시나리오 수동/자동 테스트
- [ ] 만료 토큰 -> 401 -> refresh -> 원요청 성공 플로우 E2E 확인
- [ ] 회원가입 필드 추가 후 Validation/에러 메시지 i18n 적용
- [ ] 로컬 테스트 우회 플래그 비활성화
- [ ] 커스텀 헤더 제거 또는 문서화
- [ ] 보안 점검 (MITM, 토큰 유출 경로)

---
최신 스펙 변경 시 이 문서 업데이트 바랍니다.
