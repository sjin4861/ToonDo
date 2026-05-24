# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

The Flutter app lives under `toondo/`. Run all Flutter/Dart commands from that directory, not the repo root.

```
toondo/
├── lib/                    # App entry, DI bootstrap, Hive adapter registration
│   ├── main.dart
│   ├── injection/di.dart   # Wires data/domain/presentation micro-packages
│   └── docs/architecture.md
└── packages/
    ├── common/             # Shared constants, audio, flutter_gen output (assets/colors/fonts)
    ├── domain/             # Pure Dart: entities, repository interfaces, usecases
    ├── data/               # Repository impls, Hive local + HTTP remote datasources, DTOs/mappers
    └── presentation/       # Views, Provider/ChangeNotifier ViewModels, design system, routing
```

## Commands (run from `toondo/`)

- Install deps (resolves all path-based local packages): `flutter pub get`
- Codegen — required after touching `@injectable`, Hive `@HiveType`, or assets: `dart run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run`
- Unit tests: `flutter test`
- Single test file: `flutter test path/to/foo_test.dart`
- Single test by name: `flutter test --plain-name "<test name>"`
- Per-package tests (each sub-package has its own `test/`): `cd packages/data && flutter test`
- Integration tests: `flutter test integration_test`

## Architecture (multi-package Clean Architecture + MVVM)

Dependency direction is strictly **presentation → domain ← data**, with `common` available to all:

- `presentation` imports `domain` (UseCases, Entities, Repository *interfaces*). It must **not** import from `data`.
- `data` implements `domain` repository interfaces; it owns datasources, DTOs (`*Model`), and DTO↔Entity mappers.
- New behavior flows: **ViewModel → UseCase → Repository (interface in domain) → RepositoryImpl (data) → DataSource (local Hive / remote HTTP)**.

State management is `provider` + `ChangeNotifier` ViewModels under `packages/presentation/lib/viewmodels/**`. DI uses `get_it` + `injectable`; the app-level container is bootstrapped in `toondo/lib/injection/di.dart`, and each package contributes its own `@module` annotations. Generated DI/Hive files (`**/*.config.dart`, `**/*.g.dart`) are produced by `build_runner` — do not hand-edit them.

Routing is centralized in `packages/presentation/lib/navigation/router.dart` (`AppRouter.generateRoute`).

Local persistence is Hive; **all `TypeAdapter`s and box openings are registered in `toondo/lib/main.dart`**. When adding a new Hive-backed entity, register the adapter there and run codegen.

The remote layer uses Dio with a `MockApiInterceptor` (`packages/data/lib/network/mock_api_interceptor.dart` + `mock/mock_response_registry.dart`) — endpoints can be served from canned responses when the backend is unavailable; check the registry before assuming a call is hitting the network.

## Design system (UI work)

Do **not** hardcode typography, spacing, or dimensions in screens. Use:

- `packages/presentation/lib/designsystem/typography/app_typography.dart`
- `packages/presentation/lib/designsystem/spacing/app_spacing.dart`
- `packages/presentation/lib/designsystem/dimensions/app_dimensions.dart`
- Reusable components in `packages/presentation/lib/designsystem/components/**`, especially `items/app_todo_item.dart` and `items/app_goal_item.dart` for list rows.

If a size needs to change globally, adjust the design system primitive rather than individual call sites. The app uses `flutter_screenutil` for responsive sizing.

## Don't edit

- `toondo/build/**`
- Any `**/*.g.dart` or `**/*.config.dart` (regenerate via `build_runner` instead)
- Generated assets/colors/fonts under `packages/common/lib/gen/**` (regenerate via `flutter_gen`)
