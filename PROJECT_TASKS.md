# ToonDo 프로젝트 작업 내역 및 향후 계획

## 📋 완료된 작업 (2025-09-21)

### ✅ 1. 마감일 없는 목표 기능 구현
**이슈 제목**: [Feature] 마감일 없는 목표 생성 기능 추가
**설명**: 사용자가 특정 마감일 없이 지속적으로 진행할 수 있는 목표를 설정할 수 있는 기능 구현

**주요 변경사항**:
- `Goal` 엔티티의 `endDate` 필드를 `DateTime?`로 변경하여 nullable 지원
- `GoalModel`과 `TodoModel`에서 null 안전성 처리 추가
- Goal 입력 화면에 "마감일 없이 할래요" 체크박스 추가
- 체크박스 상태에 따른 날짜 입력 필드 애니메이션 (SizeTransition, FadeTransition)
- 마감일 없는 목표에 대한 D-Day 계산 및 표시 로직 수정
- 서버 호환성을 위한 null endDate → 2099-12-31 변환 로직

**관련 파일**:
- `packages/domain/lib/entities/goal.dart`
- `packages/data/lib/models/goal_model.dart`
- `packages/presentation/lib/viewmodels/goal/goal_input_viewmodel.dart`
- `packages/presentation/lib/views/goal/input/goal_input_body.dart`
- `packages/data/lib/datasources/remote/goal_remote_datasource.dart`

### ✅ 2. 메인화면 투두 우선순위 시스템 개선
**이슈 제목**: [Enhancement] 메인화면 투두 표시 규칙을 아이젠하워 매트릭스 기반으로 개선
**설명**: 기존 showOnHome 플래그 의존 방식에서 우선순위 기반 자동 정렬 시스템으로 변경

**주요 변경사항**:
- `todayTop3Todos` 필터링 로직 개선:
  1. 오늘 날짜 기준 필터링
  2. 완료되지 않은 투두만 선택
  3. 아이젠하워 매트릭스 기반 우선순위 정렬
  4. 진행률 및 마감일 고려한 2차, 3차 정렬
- 상세한 디버깅 로그 추가로 필터링 과정 추적 가능

**관련 파일**:
- `packages/presentation/lib/viewmodels/home/home_viewmodel.dart`

### ✅ 3. 메인화면 UI 시각적 개선
**이슈 제목**: [UI] 메인화면 투두/목표 항목에 우선순위 배지 및 진행률 표시 추가
**설명**: 사용자가 한눈에 우선순위와 진행 상황을 파악할 수 있도록 시각적 요소 강화

**주요 변경사항**:
- `HomeListItem`에 우선순위 배지 추가:
  - 🔴 긴급 (아이젠하워 0)
  - 🟡 중요 (아이젠하워 1)
  - 🔵 보통 (아이젠하워 2)
  - ⚪ 낮음 (아이젠하워 3)
- 투두 진행률 퍼센트 표시
- 마감일 없는 목표/투두에 대한 "무제한" 표시
- 빈 상태 메시지 개선

**관련 파일**:
- `packages/presentation/lib/views/home/widget/home_list_item.dart`
- `packages/presentation/lib/views/home/widget/home_todo_list_section.dart`

---

## 🔍 현재 진행 중인 작업

### 🚧 4. 메인화면 노출 기능 문제 해결
**이슈 제목**: [Bug] 메인화면 노출 체크박스가 작동하지 않는 문제 수정
**설명**: 투두/목표 생성 시 "메인화면 노출" 체크박스를 클릭해도 메인화면에 표시되지 않는 문제

**현재 분석 상황**:
- 투두 필터링에서 `showOnHome` 체크 로직이 일시적으로 제거됨
- 목표 필터링은 여전히 `showOnHome` 체크를 사용 중
- 투두/목표 생성 시 `showOnHome` 값은 정상적으로 전달되고 있음
- 디버깅 로그를 추가하여 데이터 흐름 추적 중

**TODO 항목들**:
```dart
// home_viewmodel.dart
// TODO: 메인화면 노출 문제 분석 - showOnHome 체크 로직 확인
// TODO: 메인화면 노출 문제 해결 - showOnHome 체크 복원

// todo_input_viewmodel.dart  
// TODO: 메인화면 노출 문제 디버깅 - showOnHome 값 로깅

// goal_input_viewmodel.dart
// TODO: 메인화면 노출 문제 디버깅 - 목표 생성 시 showOnHome 값 로깅

// goal_management_viewmodel.dart
// TODO: 메인화면 노출 문제 분석 - 자동 완료 로직에서 showOnHome 확인
```

**다음 단계**:
1. 투두 필터링에 `showOnHome` 체크 로직 복원
2. 목표와 투두의 일관된 메인화면 노출 정책 수립
3. 사용자 체크박스 상태와 실제 표시 여부 간 동기화 확인
4. 로컬 저장소와 원격 서버 간 `showOnHome` 값 동기화 검증

**관련 파일**:
- `packages/presentation/lib/viewmodels/home/home_viewmodel.dart`
- `packages/presentation/lib/viewmodels/todo/todo_input_viewmodel.dart`
- `packages/presentation/lib/viewmodels/goal/goal_input_viewmodel.dart`

---

## 📅 향후 계획

### 🎯 5. 서버 API 동기화 개선
**이슈 제목**: [Enhancement] 마감일 없는 목표에 대한 서버 API 스펙 개선 요청
**설명**: 현재 클라이언트에서 2099-12-31 변환 처리하고 있는 부분을 서버에서 네이티브 지원하도록 개선

**계획**:
- 백엔드 팀과 협의하여 `endDate: null` 허용하는 API 스펙 변경
- 클라이언트의 임시 변환 로직 제거
- 더 직관적인 데이터 모델 구조로 개선

### 🎯 6. 사용자 경험 개선
**이슈 제목**: [UX] 마감일 없는 목표에 대한 진행률 및 성취도 측정 방식 개선
**설명**: 마감일이 없는 목표의 경우 시간 기반이 아닌 다른 성취도 측정 방식 도입

**계획**:
- 주기적 체크인 기능 (주간/월간 리뷰)
- 마일스톤 기반 진행률 측정
- 사용자 정의 성취 기준 설정 기능

### 🎯 7. 성능 최적화
**이슈 제목**: [Performance] 메인화면 필터링 로직 성능 최적화
**설명**: 투두/목표 개수가 많아질 때를 대비한 필터링 및 정렬 성능 개선

**계획**:
- 인덱싱 기반 필터링 최적화
- 메모이제이션을 통한 반복 계산 방지
- 가상화된 리스트 렌더링 고려

### 🎯 8. 테스트 커버리지 확장
**이슈 제목**: [Testing] 새로 추가된 기능들에 대한 단위 테스트 및 통합 테스트 추가
**설명**: 마감일 없는 목표 기능과 우선순위 시스템에 대한 포괄적인 테스트 코드 작성

**계획**:
- nullable endDate 처리 로직 테스트
- 아이젠하워 매트릭스 정렬 알고리즘 테스트
- UI 애니메이션 상태 변화 테스트
- 서버 호환성 변환 로직 테스트

---

## 🐛 알려진 이슈

1. **메인화면 노출 기능 비활성화**: 현재 진행 중인 작업 항목 #4 참조
2. **서버 API endDate null 비지원**: 임시 해결책 적용됨, 향후 계획 #5에서 근본적 해결 예정

---

## 🔧 기술 부채

1. **2099-12-31 변환 로직**: 서버 호환성을 위한 임시 해결책으로 추후 제거 필요
2. **중복된 필터링 로직**: 투두와 목표에서 유사한 필터링 로직이 중복됨, 공통 유틸리티로 리팩토링 필요
3. **하드코딩된 상수값들**: 우선순위 색상, 애니메이션 duration 등 상수화 필요

---

*Last Updated: 2025-09-21*
*Next Review: 2025-09-28*