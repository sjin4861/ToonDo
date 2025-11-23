# 백엔드 이슈 보고 - 2025년 11월 23일

## 🚨 문제 요약

목표 업데이트 API (`PUT /api/v1/goals/{goalId}`)가 401 TOKEN_EXPIRED 에러를 반환하지만, **실제로는 백엔드 내부 인증 문제**입니다.

## 📋 재현 방법

1. 정상적으로 로그인 (JWT 토큰 발급됨)
2. `PUT /api/v1/goals/83` 호출
3. 올바른 Authorization 헤더 포함:
   ```
   Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NjM4OTE3NzQsImV4cCI6MTc2NDQ5NjU3NCwianRpIjoiNTFmMjIwYjMtN2IwZi00NDQxLTk4ZDAtY2UyZjdjZDdhZmU0In0...
   ```

## 🔍 서버 응답

```json
{
  "errorCode": "TOKEN_EXPIRED",
  "errorMessage": "feign.FeignException$Forbidden: [403] during [GET] to [http://TOONDO-SECURITY/api/v1/user-info] [UserInfoClient#getUserInfo()]: []"
}
```

## 🎯 근본 원인 분석

1. **클라이언트 → API Gateway**: ✅ 정상 (올바른 JWT 포함)
2. **API Gateway → TOONDO-SECURITY**: ❌ 403 Forbidden 발생
3. **내부 서비스 호출 시 인증 실패**

### JWT 토큰 상태

디코딩된 claims:
```json
{
  "iat": 1763891774,  // 발급: 2025-11-23
  "exp": 1764496574,  // 만료: 2025-12-30
  "jti": "51f220b3-7b0f-4441-98d0-ce2f7cd7afe4"
}
```

- ✅ 토큰은 **아직 유효** (만료 전)
- ✅ JWT 형식 정상
- ✅ 쿠키에도 정상적으로 포함됨

## ❓ 백엔드 팀 확인 필요 사항

### 1. TOONDO-SECURITY 서비스 인증 설정

- [ ] `/api/v1/user-info` 엔드포인트가 Feign 클라이언트에서 호출될 때 인증 헤더가 전달되는가?
- [ ] 마이크로서비스 간 호출 시 JWT를 어떻게 전달하는가?
  - 옵션 A: 클라이언트 JWT를 그대로 전달 (pass-through)
  - 옵션 B: 서비스 간 별도 인증 토큰 사용
  - 옵션 C: API Gateway에서 변환

### 2. UserInfoClient 설정

```java
// 현재 구현 추정
@FeignClient(name = "TOONDO-SECURITY")
public interface UserInfoClient {
    @GetMapping("/api/v1/user-info")
    UserInfoResponse getUserInfo();  // 🚨 인증 헤더 누락?
}
```

**필요한 수정** (예시):
```java
@FeignClient(name = "TOONDO-SECURITY", configuration = FeignConfig.class)
public interface UserInfoClient {
    @GetMapping("/api/v1/user-info")
    UserInfoResponse getUserInfo(@RequestHeader("Authorization") String auth);
}
```

### 3. Goals 서비스 인증 전달 로직

목표 업데이트 시 내부적으로 사용자 정보를 조회하는 이유:
- [ ] 사용자 권한 확인?
- [ ] 사용자 존재 여부 검증?
- [ ] 사용자 ID 추출?

**제안**: 
- JWT에 이미 `jti` (사용자 식별자)가 있으므로, 별도 API 호출 없이 JWT claims에서 직접 추출 가능
- 또는 API Gateway에서 `X-User-Id` 헤더를 추가하여 하위 서비스로 전달

### 4. 에러 메시지 개선

현재:
```json
{"errorCode": "TOKEN_EXPIRED", "errorMessage": "...403..."}
```

**문제점**: 
- `TOKEN_EXPIRED`는 부정확 (토큰은 만료되지 않음)
- 실제 원인은 "내부 서비스 인증 실패"

**제안**:
```json
{"errorCode": "INTERNAL_AUTH_FAILED", "errorMessage": "사용자 정보 조회 실패"}
```

## 🔧 임시 해결책 (백엔드 측)

### 옵션 1: Feign Interceptor 추가

```java
@Component
public class FeignAuthInterceptor implements RequestInterceptor {
    @Override
    public void apply(RequestTemplate template) {
        // 현재 요청의 Authorization 헤더를 Feign 요청에 전달
        ServletRequestAttributes attrs = 
            (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs != null) {
            String auth = attrs.getRequest().getHeader("Authorization");
            if (auth != null) {
                template.header("Authorization", auth);
            }
        }
    }
}
```

### 옵션 2: JWT에서 직접 사용자 정보 추출

```java
// UserInfoClient 호출 대신
String userId = jwtTokenProvider.getUserIdFromToken(token);
```

## 📊 클라이언트 로그 전문

### 요청
```
PUT http://3.36.80.237:8083/api/v1/goals/83
Headers:
  Content-Type: application/json
  Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
  Cookie: accessToken=...; refreshToken=...
Body:
  {
    "goalName": "2026 ACL",
    "startDate": "2025-10-12",
    "endDate": "2026-01-06",
    "icon": "assets/icons/ic_file-text.svg"
  }
```

### 응답
```
Status: 401 Unauthorized
Body:
  {
    "errorCode": "TOKEN_EXPIRED",
    "errorMessage": "feign.FeignException$Forbidden: [403] during [GET] to [http://TOONDO-SECURITY/api/v1/user-info] [UserInfoClient#getUserInfo()]: []"
  }
```

## ✅ 클라이언트 측 완료 사항

- [x] Authorization 헤더에 올바른 JWT 포함
- [x] 쿠키에 accessToken/refreshToken 포함
- [x] API 문서에 맞는 엔드포인트 사용 (`/api/v1/goals/{goalId}`)
- [x] 요청 body 형식 정확 (nullable 필드 처리)

## 🎯 다음 단계

1. **백엔드 팀**: Feign 클라이언트 인증 설정 확인 및 수정
2. **클라이언트 팀**: 백엔드 수정 후 재테스트
3. **공통**: 마이크로서비스 간 인증 전략 문서화

---

**보고 일시**: 2025년 11월 23일  
**심각도**: High (핵심 기능 동작 불가)  
**영향 범위**: 모든 목표 수정 요청  
**클라이언트 담당자**: jun  
