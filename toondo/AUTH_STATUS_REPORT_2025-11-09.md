# 인증/토큰 이슈 상태 보고 (2025-11-09)

## 1. 개요
- 목표: 기존 http.Client → Dio 마이그레이션 + 쿠키 기반 JWT 인증 + 자동 토큰 갱신(Refresh) 안정화.
- 현재 증상: 로그인 후 accessToken/refreshToken 쿠키는 수신되나, 보호된 API(닉네임 변경, 목표 수정 등) 호출 시 401 응답 + 본문에 `{"errorCode":"TOKEN_EXPIRED"}` 포함. Refresh 시도 역시 401 반복.
- 영향: 사용자 프로필 수정, 목표/투두 변경 등 인증 필요한 기능 모두 제한.

## 2. 진행 작업 요약
| 항목 | 내용 | 상태 |
|------|------|------|
| Dio 클라이언트 구축 | CookieManager + AuthInterceptor + AccessToken 자동 부착 | 완료 |
| Authorization 헤더 정비 | 잘못된 값(ROLE_MEMBER) 제거, JWT 패턴일 때만 부착 | 완료 |
| Refresh 로직 | 401 TOKEN_EXPIRED 감지 후 refresh 재시도, 동시성 제어(Completer) | 1차 구현 완료 |
| Refresh 개선 | Authorization 제외 / 다중 경로 fallback / 쿠키 로그 추가 | 진행 중 |
| 엔드포인트 fallback | 닉네임 저장, 로그인 경로 다중 후보 처리 | 진행 중 |
| 테스트 정비 | 기존 테스트 http→Dio 재작성 및 Mockito 충돌 해결 | 미착수 |

## 3. 현재 문제 상세
1. 첫 보호 API 호출에서 401(TOKEN_EXPIRED) 발생 → 내부적으로 user-info 조회 403을 TOKEN_EXPIRED로 래핑한 추정.
2. Refresh 요청(POST /api/v1/auth/refreshToken) 역시 401으로 거절 → 기존 세션 자체를 서버가 유효 사용자로 매핑하지 못함.
3. 토큰은 형태상 정상(JWT)이며 exp 시간이 현재 시각 기준 적절. 즉 단순 만료가 아닌 "사용자/권한 매핑 실패" 가능성이 높음.

## 4. 가설 (Hypotheses)
| # | 가설 | 설명 | 우선순위 |
|---|------|------|---------|
| H1 | 로그인 payload 키 불일치 | 서버는 loginId 키를 기대하는데 클라이언트는 id 사용 → 비정상/게스트 토큰 발급 | 높음 |
| H2 | 추가 식별 헤더 필요 | `X-Custom-User-Id` 헤더를 서버가 아직 요구(마이그레이션 중) → 미부착 시 user-info 403 | 높음 |
| H3 | Refresh 경로/메서드 상이 | 실제 서버 경로 혹은 메서드(GET/POST)가 다름 → refresh 실패 후 원 요청도 실패 | 중간 |
| H4 | 토큰 payload 권한 누락 | roles/유저ID claim이 비어 있어 권한 검사 단계 실패 | 중간 |
| H5 | 쿠키 도메인/경로 문제 | 내부 security 서비스로 쿠키 전달 누락 | 중간 |
| H6 | 시계 편차 | 서버 clock 검증 엄격 → iat/exp 평가 실패 | 낮음 |

## 5. 이미 수행한 진단/실험
| 실험 | 결과 | 해석 |
|------|------|------|
| Authorization 자동 부착 제거(Refresh) | Refresh 여전히 401 | 헤더 문제 아님 |
| 다중 refresh 경로 시도 | 첫 경로 401 → 두번째 경로 시도 중 | 경로 불일치 가능성 존재 |
| JWT 정규식 검사 도입 | Invalid 헤더 제거 성공 | 토큰 자체는 정규식 만족 |

## 6. 즉시 수행할 추가 실험 (제안)
1. 로그인 요청을 `{loginId: ..., password: ...}`로 변경한 토큰으로 재시도.
2. 인터셉터로 모든 보호된 API에 `X-Custom-User-Id: 15` (테스트값) 부착 후 재호출.
3. `/api/v1/user-info` 직접 GET (쿠키+Authorization) 하여 403인지 확인.
4. Refresh GET 메서드 시도 및 `/auth/refreshToken` 경로(비 prefix) 호출 결과 비교.
5. accessToken payload 디코딩(roles, sub, userId 등) 확인.

## 7. 권장 실행 순서
1) 로그인 payload 교차 테스트 (H1 검증)  
2) Custom User Header 인터셉터 적용 (H2 검증)  
3) user-info 직접 호출 (원인 확정)  
4) Refresh GET/다른 경로 추가 시도 (경로 문제 여부)  
5) 토큰 payload 확인 후 권한 claim 누락이면 백엔드 팀에 스키마 확인 요청.

## 8. 백엔드 팀에 요청할 정보
- 실제 로그인 요청 바디 필드명 스펙 (id vs loginId vs username)  
- refresh 엔드포인트 메서드/경로 확정 (POST /api/v1/auth/refreshToken인지)  
- user-info 호출 시 필요한 추가 헤더 또는 쿠키 종류  
- TOKEN_EXPIRED 매핑 로직: user-info 403 시 항상 TOKEN_EXPIRED로 래핑되는지 여부  
- accessToken payload 예시 (roles, userId claim 포함 여부)

## 9. 향후 개선 로드맵
| 단계 | 작업 | 기대 효과 |
|------|------|-----------|
| 단기 | H1/H2 실험으로 401 루프 해소 | 기본 기능 복구 |
| 단기 | user-info 사전 호출 후 결과 캐시 | 초기 오류 조기 감지 |
| 단기 | 도메인 에러 타입화 (AuthExpiredError 등) | UI/로깅 명확성 향상 |
| 중기 | Refresh 로직 안정화 & 경로 확정 | 재시도 신뢰성 확보 |
| 중기 | 테스트 재작성 (FakeDio + 시나리오) | 회귀 방지 |
| 장기 | 서버와 토큰 claim 구조 최종 합의 & 옵저버블(로그) 표준화 | 유지보수 용이성 |

## 10. 현재 코드 상태 요약
- `dio_client.dart`: AuthInterceptor + AccessTokenAttachInterceptor + Refresh 다중 후보.
- Authorization 헤더: JWT 형태만 자동 부착, refresh에서는 의도적 생략.
- 여전히 401 반복 → 사용자 식별/권한 레벨 미연결 추정.

## 11. 액션 아이템 (담당 제안)
| 담당 | 액션 | ETA |
|-------|------|-----|
| FE | 로그인 payload 교차 실험, custom header 인터셉터 추가 | 0.5d |
| FE | user-info 핑 테스트 + 로그 캡처 | 0.5d |
| BE | 로그인/refresh/user-info 스펙 재확인 및 문서화 | 0.5d |
| BE | user-info 403 → TOKEN_EXPIRED 변환 로직 설명 공유 | 0.5d |
| FE | 테스트 케이스 갱신 (401→refresh→성공) | 1d |
| FE/BE | 토큰 claim(roles,userId) 설계 확정 | 1d |

## 12. 의사결정 필요 사항
- Custom User Header (X-Custom-User-Id) 유지 vs 제거 여부
- 로그인 필드명 표준화 (id vs loginId) 및 레거시 경로 제거 시점
- Refresh 경로/메서드 단일화

## 13. 리스크 & 대응
| 리스크 | 영향 | 대응 |
|--------|------|------|
| 잘못된 필드명 지속 사용 | 세션 미확립 및 기능 차단 | 필드명 스펙 조기 확정 |
| Custom Header 종속 장기화 | 표준 JWT 흐름 복잡화 | 서버 전환 일정 공유 후 제거 계획 |
| 테스트 부재 | 회귀 발생 시 장시간 디버깅 | 핵심 인증 시나리오 테스트 추가 |

## 14. 결론
현재 401 루프는 단순 토큰 만료가 아니라 "사용자 식별/권한 매핑 실패" 가능성이 매우 높습니다. FE 측에서는 로그인 payload/커스텀 헤더 실험을 즉시 진행하고, BE 측 스펙 확인이 병행되어야 합니다. 위 액션 플랜대로 진행하면 하루 이내 원인 확정 및 정상 흐름 복구가 기대됩니다.

---
(문의/수정 요청 시 이 문서 업데이트 예정)
