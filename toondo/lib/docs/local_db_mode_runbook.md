# Local DB 모드 운영 가이드

## 현재 상태
- 현재 앱 데이터 모드는 **로컬 DB(Hive) 전용**입니다.
- 기준 플래그:
  - [packages/data/lib/constants.dart](packages/data/lib/constants.dart)
  - `Constants.localDbOnlyMode = true`

## 로컬 전용에서 보장되는 기능
- 목표: 생성/조회/수정/삭제/완료 처리
- 투두: 생성/조회/수정/삭제/완료 처리
- 회원가입/로그인/로그아웃/중복확인/계정삭제
- 닉네임/비밀번호 수정

## 핵심 원칙
1. UI/UseCase는 변경하지 않고 Repository에서만 분기
2. 원격 DataSource 코드는 삭제하지 않고 유지
3. 모드 전환은 `Constants.localDbOnlyMode` 1개로 제어

## 서버 재연결 방법
1. [packages/data/lib/constants.dart](packages/data/lib/constants.dart)에서
   - `Constants.localDbOnlyMode = false` 로 변경
2. 앱 실행 후 인증/목표/투두 흐름 점검
3. 필요 시 최초 1회 동기화 로직 실행

## 점검 체크리스트
- [ ] 회원가입 후 로그인 가능
- [ ] 목표 생성 직후 목록/홈 반영
- [ ] 투두 생성/완료 반영
- [ ] 앱 재시작 후 데이터 유지
- [ ] 로그아웃 후 재로그인 동작

## 주의
- 로컬 계정 비밀번호는 secure storage에 저장됩니다.
- 서버 재연결 시 계정/데이터 마이그레이션 정책을 별도 정의해야 합니다.
