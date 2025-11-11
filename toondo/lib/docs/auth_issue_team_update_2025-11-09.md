# [팀 공유] 인증 이슈 요약 보고 (2025-11-09)

## TL;DR
- 로그인은 성공하여 accessToken/refreshToken 쿠키를 받지만, 보호된 API 호출 시 401이 반복됩니다.
- 서버 내부에서 user-info(권한/사용자 확인) 단계가 403으로 실패 → 상위에서 TOKEN_EXPIRED로 래핑되어 내려오는 것으로 보입니다.
- 클라이언트는 Authorization 헤더/Refresh 로직을 정비했으나, 여전히 refresh도 401입니다. 즉, "토큰-사용자 매핑" 문제가 유력합니다.

## 영향 범위
- 닉네임 변경, 목표 수정/생성 등 인증 필요한 API 전반에서 401 발생 → 기능 사용 제한.

## 현재까지 적용한 조치 (클라이언트)
- Dio + CookieManager 도입, 전역 AuthInterceptor 구성.
- Authorization 헤더 자동 부착 로직 정비: JWT 형태일 때만 부착.
- Refresh 요청 시 Authorization 헤더 강제 제거(쿠키만으로 갱신), 동시성 제어.
- Refresh 다중 경로 fallback 및 진단 로그(쿠키 before/after) 추가.

## 대표 로그 (요약)
- 보호 API 401 응답 본문 예시:
  - `{ "errorCode":"TOKEN_EXPIRED", "errorMessage":"... 403 ... /api/v1/user-info ..." }`
- refresh 호출 결과: 401 (Authorization 없이 쿠키만 첨부해도 동일)

### 최신 추가 로그 (오후 재실험: 회원가입 → 로그인 → 닉네임 단계)
1. 회원가입 시퀀스
  - `/api/v1/users/check-loginid?loginId=test1` → 200 (중복 없음)
  - `/api/v1/users/signup` → 201 (본문 없음, 쿠키 미발급 정상)
2. 로그인
  - `/login` → 200, `set-cookie: accessToken, refreshToken` 수신 (HttpOnly, Path=/)
  - Authorization 헤더는 비활성화 플래그(`disableAuthHeaderAttach=true`)로 인해 전송되지 않음 → 순수 쿠키 기반 인증 테스트 통과
3. 보호 API(닉네임 제출 과정에서 내부 보호 엔드포인트 호출) 시도
  - 최초 보호 호출에서 401 수신 → 인터셉터가 즉시 refresh 절차 진입
4. Refresh 재시도
  - `/api/v1/auth/refreshToken` → 401
  - `/api/v1/auth/refresh-token` → 401 (후속 후보도 실패, 토큰/쿠키 조합 불인정)

로그 패턴 요약:
```
[AuthInterceptor] Refresh start (from onResponse)
[AuthInterceptor] Cookies before refresh: accessToken=..., refreshToken=...
... refreshToken endpoint(s) 모두 401 ...
```

결론: 회원가입/로그인 자체는 정상이며 쿠키도 부여되지만, 보호 API 및 refresh 모두 동일하게 세션/사용자 매핑 실패 상태 지속.

## 가설 (원인 후보)
1) 로그인 요청 바디 키 불일치: 서버는 `loginId`를 기대, 현재 `id`로 전송 → 토큰은 발급되지만 사용자/권한 매핑 실패.
2) 추가 식별 헤더 의존: `X-Custom-User-Id` 헤더가 아직 필요한 이행 단계.
3) refresh 경로/메서드 상이: 실제 서버 스펙과 차이.
4) 토큰 payload 권한 누락: roles/userId claim 미포함.
5) 쿠키 속성(도메인/보안/SameSite)의 서버 검증 규칙 미충족 → 이후 요청에서 세션 조회 실패 (서버 설정 확인 필요).

## 재현 절차(간단)
1) /login 호출 → set-cookie(accessToken, refreshToken) 수신.
2) /api/v1/goals/{id} 등 보호 API 호출 → 401 + TOKEN_EXPIRED.
3) 인터셉터가 /api/v1/auth/refreshToken 호출 → 401.

## 다음 액션 제안 (합의 필요)
- FE (오늘):
  1. 로그인 바디를 **명시적으로** `{ loginId, password }` 로 고정하여 재로그인 → 새 쿠키 발급 후 재현.
  2. `/api/v1/user-info` 혹은 사용자 프로필 엔드포인트 직접 호출로 401/403 raw 응답 확보.
  3. accessToken payload(디코딩 로그 추가 예정) 실제 포함 claim(userId, roles 등) 확인 후 서버 기대 스펙과 diff 비교.
  4. 필요 시 Authorization 헤더를 단건 강제 부착하는 실험 플래그(`__forceAuthHeader`) 추가하여 서버가 헤더를 요구하는지 교차 확인.
  5. refresh 후보 경로 확장(`/auth/reissue`, `/api/auth/refresh`, `/auth/refresh`) 및 메서드(GET/POST) 변조 실험.
- BE (병행):
  1. 로그인 요청 바디 스펙 확정(키 이름, 경로) 및 문서화.
  2. refresh 정확 경로/메서드 확정(POST/GET, prefix 여부).
  3. TOKEN_EXPIRED 매핑 로직 설명(어떤 조건에서 user-info 403을 TOKEN_EXPIRED로 변환하는지).
  4. accessToken payload 예시 공유(roles, userId claim 포함 여부).

## 요청 사항 (BE에 질문)
- 로그인 키 id vs loginId 중 최종 스펙은?
- refresh 엔드포인트 최종 경로/메서드?
  - 401 지속 발생 중이므로 정확한 경로/메서드/필요 헤더(CSRF 등) 조기 명세 필요.
- user-info 호출 시 필요한 추가 헤더 또는 조건?
- TOKEN_EXPIRED 변환 규칙(403→401 래핑) 명세?

## 상태 보드
- 클라이언트: Authorization/Refresh 경로 정비 완료, 쿠키 로그로 진단 가능. 보호 API 여전히 401.
- 원인 추정: "사용자/권한 매핑 실패" + "refresh 엔드포인트 스펙 불일치" 복합 가능성. BE 스펙 확정이 필요.

## 담당/ETA 제안
- FE: 위 1~3 실험 즉시 적용(0.5d), 결과 공유.
- BE: 스펙 회신(0.5d), 필요 시 서버 응답/claim 조정. refresh/user-info 규칙 문서화.

---
문의: FE @jun / BE @security
