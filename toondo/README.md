# 🎨 ToonDo - 목표 관리 & 동기 부여 앱

ToonDo는 캐릭터 기반의 목표 관리 및 동기 부여를 돕는 Flutter 앱입니다.  
사용자의 투두리스트를 재미있고 직관적으로 관리하며, 캐릭터와의 상호작용을 통해 꾸준한 동기 부여를 제공합니다.

---

## 🏗️ 프로젝트 아키텍처

본 프로젝트는 **MVVM 기반의 Clean Architecture**를 Flutter로 구현하여,  
**관심사의 분리**와 **유지보수성**, **테스트 용이성**을 고려한 구조를 따릅니다.


---

## 🔨 기술 스택

| Layer           | 기술/라이브러리          |
|-----------------|---------------------------|
| Language        | Dart                      |
| Framework       | Flutter (3.x.x)           |
| Architecture    | MVVM + Clean Architecture |
| 상태관리          | Provider + GetIt (DI)     |
| 로컬DB          | Hive                      |
| 네트워킹        | Retrofit (Dio 기반) <TODO>   |
| 캐릭터 애니메이션 | Rive             |

---

## ⚙️ 클린 아키텍처 구성

### 1. Domain Layer
- **Entities**  
  앱의 핵심 비즈니스 모델을 정의합니다. (ex. `TodoEntity`)
- **Repositories (Interfaces)**  
  데이터 접근에 대한 추상화입니다. (ex. `TodoRepository`)
- **UseCases**  
  비즈니스 로직을 담당하며, 하나의 기능을 독립적으로 처리합니다. (ex. `GetTodosUseCase`)

### 2. Data Layer
- **RepositoryImpl**  
  Domain에서 정의한 Repository를 실제 구현합니다.  
  Remote(Local) DataSource와 통신합니다.
  (ex. `TodoRepositoryImpl`)
- **DataSource (Remote/Local)**  
  원천 데이터 소스와 연결합니다. (ex. `TodoLocalDatasource`, `TodoRemoteDataSource`)
- **DTO → Entity 변환**  
  외부 데이터와 도메인 모델 간 변환을 담당합니다.(ex. `TodoModel`)

### 3. Presentation Layer
- **View (Screen)**  
  실제 화면을 구성합니다.
- **ViewModel**  
  화면의 상태 관리와 비즈니스 로직을 담당합니다.  
  UseCase를 호출하여 데이터를 가져오고, UI에 반영합니다.
- **Widget**
  View에서 자주 사용되거나, 내부 로직이 복잡한 경우 Widget으로 모듈화를 했습니다.
---

## 🗂️ 디렉토리 구조 예시

~~~
bash

C:.
├─assets
│  ├─audios
│  ├─icons
│  ├─images
│  └─rives
├─doc
│  └─api
├─injection
├─lib
│  ├─injection
│  ├─docs
│  └─utils
├─packages
│  ├─data
│  │  └─lib
│  │      ├─datasources
│  │      │  ├─local
│  │      │  └─remote
│  │      ├─injection
│  │      ├─models
│  │      └─repositories
│  ├─domain
│  │  └─lib
│  │      ├─entities
│  │      ├─injection
│  │      ├─repositories
│  │      └─usecases
│  │          ├─auth
│  │          ├─character
│  │          ├─goal
│  │          ├─gpt
│  │          ├─sms
│  │          ├─todo
│  │          └─user
│  └─presentation
│      └─lib
│          ├─injection
│          ├─navigation
│          ├─viewmodels
│          │  ├─auth
│          │  ├─character
│          │  ├─goal
│          │  ├─home
│          │  ├─my_page
│          │  ├─onboarding
│          │  ├─todo
│          │  └─welcome
│          ├─views
│          │  ├─auth
│          │  ├─goal
│          │  ├─home
│          │  ├─my_page
│          │  ├─onboarding
│          │  ├─todo
│          │  └─welcome
│          └─widgets
│              ├─app_bar
│              ├─bottom_button
│              ├─calendar
│              ├─card
│              ├─character
│              ├─chart
│              ├─chip
│              ├─goal
│              ├─my_page
│              ├─navigation
│              ├─text_fields
│              ├─todo
│              └─top_menu_bar
└─test
~~~

---

---

## 📝 기능 예시 - Todo 흐름

1. `TodoManageViewModel` → `GetTodosUseCase` 호출  
2. `GetTodosUseCase` → `TodoRepository.getTodos()` 호출  
3. `TodoRepositoryImpl` → `RemoteDataSource` 또는 `LocalDataSource`에서 데이터 수신  
4. DTO → Entity 변환 후 ViewModel에 전달  
5. ViewModel이 상태 변경 → UI 반영

---