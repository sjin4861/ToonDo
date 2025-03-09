# Flutter 아키텍처

이 문서는 Flutter 애플리케이션의 아키텍처 구조에 대해 설명합니다. 이 아키텍처는 **Presentation Layer**, **Domain Layer**, **Data Layer**를 기본으로 나누며, 각 레이어의 책임과 구성 요소에 대해 설명합니다.

---

## **Presentation Layer**

Flutter에서 Presentation Layer는 UI와 비즈니스 로직을 분리하는 중요한 역할을 합니다. 화면을 표시하고 사용자 상호작용을 처리하는 레이어로, 세 가지 주요 구성 요소로 나눌 수 있습니다:

### 1. **View**
- 화면에 표시되는 위젯들입니다. Flutter에서는 모든 UI 요소가 위젯으로 구성됩니다.
- **Screen**: 각 화면을 나타내는 위젯으로, 일반적으로 **Navigator**를 통해 화면 간 전환을 관리합니다.
- **Overlay**: 화면 위에 겹쳐서 표시되며, 일정 시간이 지난 후 사라지거나 특정 작업을 수행한 후 사라지는 위젯입니다. **OverlayEntry**, **showDialog**, **showModalBottomSheet**와 함께 사용됩니다.
- **Component**: 화면을 구성하는 작은 단위의 위젯들입니다. `Button`, `Card`, `TextField` 등이 이에 해당하며, 화면이나 오버레이에 포함되어 사용됩니다.

### 2. **ViewModel**
- 비즈니스 로직을 담당하는 컴포넌트입니다. 
- **State 관리**를 통해 화면의 상태를 관리하고, 필요한 **UseCase**를 호출하여 데이터를 처리하고, **View**로 변경된 상태를 전달합니다.

### 3. **Helper**
- 서비스 기능에 한정된 재사용 가능한 함수들입니다. 
- 일반적인 유틸리티 기능은 **Util** 패키지에 포함되며, 서비스와 관련된 특정 기능은 Helper로 관리됩니다.

---

## **Domain Layer**

Domain Layer는 애플리케이션의 핵심 비즈니스 로직을 포함하는 레이어입니다. 간단하지만 중요한 코드들이 존재하며, UI나 데이터 레이어의 복잡성에 영향을 받지 않습니다.

### 1. **Entity**
- 비즈니스 로직에서 필요한 최소한의 데이터를 포함하는 객체입니다.
- DTO(Data Transfer Object)나 VO(Value Object)와는 다릅니다. 데이터 전송이나 특정 값의 래핑보다는 비즈니스 로직을 지원하는 핵심 요소입니다.

### 2. **UseCase**
- 비즈니스 기능을 수행하는 최소 단위입니다.
- UseCase는 주로 **Entity**를 입력받아 처리하고, 결과를 반환하거나 다음 작업을 수행합니다.
- 예시: `GetTodoListUseCase`, `CreateGoalUseCase` 등.

### 3. **Repository**
- **UseCase**에서 필요한 데이터를 가져오는 인터페이스를 정의합니다.
- Repository는 데이터 레이어로부터 데이터를 받아서 **Entity**로 변환하여 반환합니다.
- 데이터의 소스(API, DB 등)에 대한 세부 사항을 몰라도 되도록 합니다.

---

## **Data Layer**

Data Layer는 외부 데이터 소스(예: API, 데이터베이스 등)와 상호작용하는 레이어입니다. Domain Layer와의 의존성을 차단하여, 데이터의 소스와 형식에 관계없이 **Repository**가 일관된 방식으로 데이터를 제공할 수 있도록 합니다.

### 1. **RepositoryImpl**
- **Repository** 인터페이스를 구현한 클래스입니다.
- **RepositoryImpl**은 데이터 소스로부터 데이터를 받아 **VO**(Value Object) 형식으로 처리한 후, **Entity**로 변환하여 **UseCase**에 제공합니다.
- Repository는 외부 API나 데이터베이스와 직접 통신하며, 데이터의 세부사항을 처리합니다.

### 2. **DataSource**
- 데이터 소스는 외부 API나 로컬 데이터베이스 등, 데이터 제공을 위한 인터페이스를 정의합니다.
- 데이터 소스에서 데이터를 가져오는 역할을 하며, RepositoryImpl에서 호출됩니다.

### 3. **Model**
- 외부 API와 데이터를 주고받기 위한 전송 형식인 **Model**입니다.
- 요청은 `Map` 형식으로, 응답은 `JSON` 형식으로 처리됩니다.
- **Model**은 API와의 데이터 전송 규격을 따르며, 응답 결과는 **VO** 형태로 변환되어 **Entity**로 전달됩니다.

---

## **Util**

- **Util**은 프로젝트와 관련 없는 범용적인 코드로, 플랫폼이나 서비스에 의존하지 않는 유틸리티 기능을 포함합니다.
- 예시: 날짜 및 시간 포맷, 데이터 암호화 및 복호화, 공통 알고리즘 등이 포함됩니다.

---

## **전체 아키텍처 흐름**

1. **User interacts with UI**: 사용자는 **View**에서 UI 요소와 상호작용합니다.
2. **ViewModel processes business logic**: ViewModel은 **UseCase**를 호출하여 필요한 비즈니스 로직을 처리합니다.
3. **UseCase calls Repository**: **UseCase**는 **Repository**를 호출하여 필요한 데이터를 가져옵니다.
4. **RepositoryImpl calls DataSource**: **RepositoryImpl**은 데이터 소스에서 데이터를 가져옵니다.
5. **Repository returns Entity to UseCase**: **Repository**는 데이터가 변환된 **Entity**를 **UseCase**에 반환합니다.
6. **UseCase updates ViewModel**: **UseCase**는 처리된 데이터를 **ViewModel**에 반환합니다.
7. **ViewModel updates View**: **ViewModel**은 상태를 업데이트하여 **View**를 변경합니다.

---

## **핵심 원칙**

1. **분리된 책임 (Separation of Concerns)**: 각 레이어는 자신만의 책임을 가지고, 서로의 구현 세부사항을 알지 못하도록 합니다.
2. **단일 책임 원칙 (Single Responsibility Principle)**: 각 클래스는 하나의 책임만을 가지며, 해당 책임을 충실히 수행합니다.
3. **의존성 주입 (Dependency Injection)**: 각 레이어 간 의존성을 외부에서 주입하여, 결합도를 낮추고 테스트 가능성을 높입니다.
4. **데이터 변환 (Data Transformation)**: 데이터는 각 레이어 간 변환되어 전달됩니다. API에서 받은 데이터를 **VO**로 변환하고, 다시 **Entity**로 변환하여 사용합니다.

---

이 아키텍처는 **유지보수성**, **확장성**, **테스트 용이성**을 고려하여 설계되었습니다. 각 레이어는 독립적으로 테스트할 수 있도록 설계되었으며, 비즈니스 로직과 UI 로직의 분리를 통해 코드의 재사용성과 유연성을 보장합니다.
