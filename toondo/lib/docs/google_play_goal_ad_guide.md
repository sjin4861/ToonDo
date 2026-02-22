# Goal 조회 진입 광고 설계/구현 가이드 (Google Play 기준)

> Figma 참고
> - 목표 조회 진입 플로우: node-id=2442:4093
> - 광고 노출안: node-id=2450:8074

## 1) 목적
- 목표 조회 화면으로 이동할 때 전환형 광고를 자연스럽게 노출.
- Google Play/AdMob 정책 위반 없이 수익화.
- 앱 UX 손상 최소화(과도한 빈도 금지).

---

## 2) 권장 광고 타입
### 권장: Interstitial Ad (전면 광고)
- **이유**: “화면 전환 시점”에 가장 자연스럽게 삽입 가능.
- **노출 시점**: 홈/탭에서 "목표 관리"로 진입 직전.
- **주의**: 버튼 클릭 직후 즉시 풀스크린으로 튀는 느낌을 줄이기 위해, 짧은 로딩/전환 문맥에서만 노출.

### 대안
- App Open Ad: 앱 복귀/실행 시점 전용이라 목표 조회 전용 요구와는 덜 맞음.
- Banner/Native: 상시 노출형. 현재 Figma 의도(전환형)와 다름.

---

## 3) Google Play/AdMob 정책 핵심 체크
1. **자연스러운 인터럽션만 허용**
   - 화면 전환, 레벨 종료 같은 자연 지점에서만 전면광고 노출.
2. **빈도 제한 필수**
   - 예: `최소 120초 쿨다운 + 하루 최대 8회 + 목표화면 진입 3회당 1회`.
3. **오탭 유도 금지**
   - 광고 직전 UI가 급변하거나 버튼 위치가 바뀌지 않게.
4. **콘텐츠 차단형 강제 시청 금지**
   - 닫기 불가/반복 강제 노출 금지.
5. **아동 대상 여부 설정**
   - 아동 타겟이면 AdMob 요청 설정/개인화 옵션 별도 반영.
6. **개인정보/동의 처리**
   - EEA/UK 대상은 UMP(동의 SDK) 적용 권장.

---

## 4) ToonDo 아키텍처에 맞는 적용 구조
Clean Architecture + MVVM 기준으로 아래처럼 분리 권장.

### Data
- `AdRemoteDatasource`:
  - Interstitial 로드/표시/콜백 처리
- `AdPolicyLocalDatasource`:
  - 마지막 노출 시간, 일일 카운트, 진입 카운트 저장 (`SharedPreferences`)
- `AdRepositoryImpl`:
  - 정책 판단 + SDK 호출 조합

### Domain
- `ShouldShowGoalEntryAdUseCase`
- `PreloadGoalEntryAdUseCase`
- `ShowGoalEntryAdUseCase`
- `RecordGoalEntryUseCase`

### Presentation
- `GoalEntryAdViewModel` (또는 기존 `HomeViewModel`/`GoalManagementViewModel`에 위임)
- 목표 화면 진입 라우팅 직전:
  1) `recordEntry()`
  2) `shouldShow()`
  3) true면 `showAdThenNavigate()`
  4) false면 즉시 navigate

---

## 5) 상태머신(권장)
- `idle` → `loading` → `ready` → `showing` → `closed`/`failed`
- 실패 시 항상 **콘텐츠 우선**:
  - 광고 실패/미로드이면 즉시 목표 화면으로 이동.

---

## 6) 구현 순서 (실무 체크리스트)
1. 패키지 추가
   - `google_mobile_ads`
   - (선택) `google_user_messaging_platform` 또는 동의 처리 패키지
2. Android 설정
   - `AndroidManifest.xml`에 AdMob App ID 메타데이터 추가
3. 앱 시작 시 SDK 초기화
   - `main.dart`에서 `MobileAds.instance.initialize()`
4. 광고 단위 ID 관리
   - dev/prod 분리, 코드 하드코딩 금지 (`--dart-define` 권장)
5. 정책 저장소 구현
   - 쿨다운/일일 캡/진입 N회당 1회 계산
6. 목표 진입 라우팅 훅 연결
   - 목표 탭/목표 화면 push 전에 광고 게이트 실행
7. 로그/분석 이벤트 추가
   - `ad_load`, `ad_impression`, `ad_click`, `ad_close`, `ad_fail`, `ad_skipped_by_policy`
8. QA
   - 테스트 광고 ID로 검증 후 실광고 전환

---

## 7) 노출 정책 예시 (추천 기본값)
- 앱 첫 실행 후 30초 이내: 노출 금지
- 목표 진입 3회당 1회
- 광고 노출 간 최소 120초
- 1일 최대 8회
- 유저 결제(광고 제거 상품) 시 완전 비노출

정책 수식 예시:
- 노출 조건 = `진입카운트 % 3 == 0` AND `now-lastShownAt >= 120s` AND `todayCount < 8`

---

## 8) 실패/예외 처리 원칙
- 광고 로드 실패: 목표 화면 즉시 진입
- 광고 표시 실패: 목표 화면 즉시 진입
- 네트워크 오프라인: 광고 시도 생략
- 예외 발생: 절대 네비게이션 블로킹 금지

---

## 9) 샘플 플로우 (의사코드)
```dart
Future<void> onTapGoalTab() async {
  await recordGoalEntryUseCase();

  final canShow = await shouldShowGoalEntryAdUseCase();
  if (!canShow) {
    navigateToGoal();
    return;
  }

  final shown = await showGoalEntryAdUseCase(
    onDismissed: () => navigateToGoal(),
    onFailed: () => navigateToGoal(),
  );

  if (!shown) navigateToGoal();
}
```

---

## 10) 출시 전 점검
- [ ] 테스트 광고 ID → 운영 광고 ID 교체
- [ ] 개인정보처리방침에 광고 SDK/식별자 처리 고지
- [ ] 아동 대상 여부/개인화 광고 설정 확인
- [ ] 과도한 노출로 인한 이탈률(A/B) 측정
- [ ] Play Console 정책 경고/제한 이력 없는지 확인

---

## 11) 권장 운영 전략
- 초기 릴리즈는 보수적으로 시작
  - `3회 진입당 1회`, `일 5회`부터 시작
- 지표 기반 조정
  - 유지율/이탈률 악화 시 빈도 즉시 하향
  - eCPM/ARPDAU 상승 대비 UX 손실 균형 유지
