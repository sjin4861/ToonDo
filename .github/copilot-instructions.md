# ToonDo (Flutter) – Copilot Agent Instructions

## Big picture
- This repo is a Flutter app using **multi-package Clean Architecture + MVVM**.
- App entry is in `toondo/lib/main.dart`; UI lives in `toondo/packages/presentation`, business rules in `toondo/packages/domain`, implementations (Hive/HTTP/etc) in `toondo/packages/data`, shared assets/constants in `toondo/packages/common`.

## Layering & dependencies (keep boundaries)
- `presentation` depends on `domain` (UseCases/Entities) and should not import from `data` directly.
- `data` implements `domain` repositories and owns datasources/models/mappers.
- Prefer adding new behavior as: **ViewModel → UseCase → Repository (interface) → RepositoryImpl → DataSource**.
- Architectural overview: `toondo/lib/docs/architecture.md`.

## State management & DI
- Presentation uses `provider` + `ChangeNotifier` ViewModels (see `toondo/packages/presentation/lib/viewmodels/**`).
- DI uses `get_it` + `injectable`.
  - App-level bootstrap: `toondo/lib/injection/di.dart` (wires `data/domain/presentation` micro-packages).
  - Generated files like `**/*.config.dart` and `**/*.g.dart` are produced by build_runner — don’t hand-edit.

## Design system conventions (UI work)
- Use the design system instead of ad-hoc styles:
  - Typography: `toondo/packages/presentation/lib/designsystem/typography/app_typography.dart`
  - Spacing: `toondo/packages/presentation/lib/designsystem/spacing/app_spacing.dart`
  - Dimensions: `toondo/packages/presentation/lib/designsystem/dimensions/app_dimensions.dart`
  - Reusable components: `toondo/packages/presentation/lib/designsystem/components/**`
- Todo/Goal list items are composed via:
  - `toondo/packages/presentation/lib/designsystem/components/items/app_todo_item.dart`
  - `toondo/packages/presentation/lib/designsystem/components/items/app_goal_item.dart`

## Navigation
- Routes are generated via `toondo/packages/presentation/lib/navigation/router.dart` (`AppRouter.generateRoute`).

## Local persistence & models
- Local storage uses Hive (adapters registered in `toondo/lib/main.dart`).
- Hive box names currently include `todos` and `deleted_todos` (see `toondo/lib/main.dart`).

## Dev workflows (run from `toondo/`)
- Install deps: `flutter pub get`
- Codegen (injectable/hive/flutter_gen): `dart run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run`
- Unit tests: `flutter test`
- Integration tests: `flutter test integration_test`

## Editing guidelines
- Avoid touching `toondo/build/**`, `**/*.g.dart`, `**/*.config.dart`, and generated assets in `toondo/packages/common/lib/gen/**`.
- When adjusting UI sizes, prefer changing the design system primitives (Typography/Dimensions) rather than hard-coding numbers in screens.
