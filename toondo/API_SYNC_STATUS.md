# ToonDo 백엔드 API 동기화 현황

## 동기화 완료
  - 목표 생성 (`POST /api/v1/goals`): 구현/테스트 정상 통과
  - 모든 목표 조회 (`GET /api/v1/goals?status=0`): 구현/테스트 정상 통과
  - 특정 목표 조회 (`GET /api/v1/goals/{goalId}`): 구현/테스트 정상 통과
  - 목표 수정 (`PUT /api/v1/goals/{goalId}`): 구현/테스트 정상 통과
  - 목표 성취도 직접 수정 (`PATCH /api/v1/goals/{goalId}/progress`): 구현/테스트 정상 통과
  - 목표 완료 상태 전환 (`PATCH /api/v1/goals/{goalId}/status`): 구현/테스트 정상 통과
  - 목표 삭제 (`DELETE /api/v1/goals/{goalId}`): 구현/테스트 정상 통과

  - 구현: `AuthRemoteDataSource.registerUser`, `AuthRepositoryImpl.registerUser`
  - 테스트: 정상 통과
  - 구현: `AuthRemoteDataSource.login`, `AuthRepositoryImpl.login`
  - 테스트: 정상 통과
  - 구현: `UserRemoteDatasource.changeNickName`, `UserRepositoryImpl.updateNickName`
  - 테스트: 정상 통과
  - 구현: `UserRemoteDatasource.checkLoginId`
  - 테스트: 정상 통과
  - 구현: `UserRemoteDatasource.getUserMe`
  - 테스트: 정상 통과
  - 구현: `UserRemoteDatasource.updatePassword`
  - 테스트: 정상 통과
  - 투두 추가 (`POST /api/v1/todos`): 구현/테스트 정상 통과
  - 날짜 기준 전체 조회 (`GET /api/v1/todos/by-date?date=YYYY-MM-DD`): 구현/테스트 정상 통과
  - 목표 기준 전체 조회 (`GET /api/v1/todos/by-goal/{goalid}`): 구현/테스트 정상 통과
  - 투두 디테일 조회 (`GET /api/v1/todos/{todoid}`): 구현/테스트 정상 통과
  - 투두 수정 (`PUT /api/v1/todos/{todoid}`): 구현/테스트 정상 통과
  - 투두 완료/미완료 체크 (`PATCH /api/v1/todos/{todoid}/status`): 구현/테스트 정상 통과
  - 투두 삭제 (`DELETE /api/v1/todos/{todoid}`): 구현/테스트 정상 통과
  - 동기화 클릭 (`POST /todos/all/commit`): 구현/테스트 정상 통과
  - 로그인 시 로컬 데이터 조회 (`GET /todos/all/fetch`): 구현/테스트 정상 통과

## 동기화 미완료/확인 필요

목표 성취도 계산 로직 등 백엔드 기능
  - 구현/테스트 미확인 (API가 아닌 내부 로직, 별도 검증 필요)


---
## ToonDo 백엔드 API 동기화 작업 보고서 (2025-07-29)

### 1. 동기화/테스트 완료 내역

- 회원가입, 로그인, 닉네임 저장/수정, 로그인ID 중복 확인, 내 정보 조회, 비밀번호 수정 등 사용자 관련 API
- 목표 생성/조회/수정/삭제, 목표 성취도 직접 수정, 목표 완료 상태 전환 등 목표 관련 API
- 투두리스트 추가/조회/수정/삭제, 완료/미완료 체크 등 투두 관련 API
- 동기화 클릭(`POST /todos/all/commit`), 로그인 시 로컬 데이터 조회(`GET /todos/all/fetch`) 등 동기화/로컬 연동 API

→ 모든 항목에 대해 코드 구현 및 테스트 코드 작성, 정상 동작 확인

### 2. 미확인/추가 검증 필요 내역

- 목표 성취도 계산 로직 등 백엔드 내부 기능 (API가 아닌 로직, 별도 검증 필요)

### 3. 작업 방식 및 참고 사항

- Notion MCP 서버에서 백엔드 API 문서 추출 및 엔드포인트 목록화
- 각 API별로 Data/Domain 계층 코드 및 테스트 코드 동기화
- 테스트 코드 실행 결과를 바탕으로 동기화 현황을 실시간 업데이트
- 모든 완료된 항목은 "동기화 완료"에 기록, 미확인/추가 검증 필요 항목은 별도 관리

---

## 주요 백엔드 API URL 목록

### Base URL
`http://localhost:8080/`

### User 관련
- `/api/v1/users/check-loginid?loginid={loginid}` : 로그인ID 중복 존재 여부 확인 (GET)
- `/api/v1/users/signup` : 회원가입 (POST)
- `/api/v1/users/login` : 로그인 (POST)
- `/api/v1/users/me` : 내 정보 조회 (GET)
- `/api/v1/users/me/nickname` : 닉네임 최초 저장 및 수정 (PATCH)
- `/api/v1/users/me/password` : 비밀번호 수정 (PATCH)

### Goal, Todo 관련

#### Goal 관련
- `POST   /api/v1/goals` : 목표 생성
- `GET    /api/v1/goals?status=0` : 모든 목표 조회
- `GET    /api/v1/goals/{goalId}` : 특정 목표 조회
- `PUT    /api/v1/goals/{goalId}` : 목표 수정
- `PATCH  /api/v1/goals/{goalId}/progress` : 목표 성취도 직접 수정
- `PATCH  /api/v1/goals/{goalId}/status` : 목표 완료 상태 전환 (진행중0 ↔ 완료1)
- `DELETE /api/v1/goals/{goalId}` : 목표 삭제

#### Todo 관련
- `POST   /api/v1/todos` : 투두리스트 추가
- `GET    /api/v1/todos/by-date?date=YYYY-MM-DD` : 투두리스트 (날짜 기준) 전체 조회
- `GET    /api/v1/todos/by-goal/{goalid}` : 투두리스트 (목표 기준) 전체 조회
- `GET    /api/v1/todos/{todoid}` : 투두아이디로 디테일 조회
- `PUT    /api/v1/todos/{todoid}` : 투두리스트 수정
- `PATCH  /api/v1/todos/{todoid}/status` : 투두리스트 완료/미완료 체크
- `DELETE /api/v1/todos/{todoid}` : 투두리스트 삭제

#### 기타
- `POST   /todos/all/commit` : 동기화 클릭 → DB
- `GET    /todos/all/fetch` : 로그인 시 백엔드 → 로컬 데이터 조회

※ 목표 성취도 계산 로직은 API가 아닌 백엔드 기능 (설명 참고)

### 기타
- Notion 문서 내 테이블/하위 페이지에서 추가 엔드포인트 존재 가능

## 참고
- 백엔드 API 문서 Notion: [백엔드 API 문서](https://www.notion.so/API-23ff0d0db88481f180f3ccc413238e31)
- 동기화 현황은 작업이 진행될 때마다 업데이트 필요

---

작업이 완료된 부분과 미완료/확인 필요한 부분을 계속 기록하며 동기화 작업을 진행합니다.
