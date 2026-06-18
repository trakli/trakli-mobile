# AGENTS.md

Guidance for AI coding assistants (and humans pairing with them) working in the **Trakli** Flutter app. The goal of this file is simple: **let you implement features quickly without breaking the parts of the codebase you didn't touch.**

Read this before generating code. When in doubt, copy the pattern of the nearest existing feature rather than inventing a new one.

> This file applies to the whole repo. Two companion docs go deeper:
> - [doc/bloc_cubit_patterns.md](doc/bloc_cubit_patterns.md) — state management patterns (read before touching any Cubit).
> - [doc/drift_sync_crash_reporting.md](doc/drift_sync_crash_reporting.md) — sync error reporting.
> - [CONTRIBUTING.md](CONTRIBUTING.md) — environment setup, commit/style rules.

---

## 1. What this project is

Trakli is an **offline-first** personal finance tracker (income/expenses, wallets, budgets, transfers, groups, categories, parties). It is a Flutter app built with **Clean Architecture** and a **local-first sync** model: the UI always reads/writes the local Drift (SQLite) database, and changes are synced to the server in the background via `drift_sync_core`.

- **Flutter:** pinned to `3.38.9` via FVM (see [.fvmrc](.fvmrc)). Use `fvm flutter ...` if FVM is installed.
- **Dart SDK:** `>=3.4.3 <4.0.0`.

---

## 2. Architecture — the layering rule (most important section)

Code lives in three layers under `lib/`. **Dependencies point inward only.** Breaking this is the #1 way AI-generated code corrupts the codebase.

```
presentation/  ──depends on──>  domain/  <──implemented by──  data/
   (UI + Cubits)                (pure contracts)              (Drift, Dio, sync)
        │                                                          │
        └──────────────── never imports data/ directly ───────────┘
```

### `lib/domain/` — pure business contracts (no Flutter, no Drift, no Dio)
- `entities/` — immutable `@freezed` domain models (e.g. `CategoryEntity`). UI and use cases speak in entities.
- `repositories/` — **abstract** repository interfaces returning `Future<Either<Failure, T>>` / `Stream<Either<Failure, T>>`.
- `usecases/` — one class per operation, implementing `UseCase<T, Params>` or `StreamUseCase<T, Params>` (see `lib/core/usecases/usecase.dart`). Use cases hold no logic beyond delegating to a repository.

### `lib/data/` — implementation details
- `database/tables/` — Drift table definitions. `database/app_database.dart` — the database + generated `app_database.g.dart`.
- `datasources/<feature>/` — `*_local_datasource.dart` (Drift queries) and `*_remote_datasource.dart` (Dio calls), plus `dtos/` for wire models.
- `repositories/*_impl.dart` — implement the domain repository interface; orchestrate local datasource + sync.
- `mappers/` — convert Drift row types ↔ domain entities (`CategoryMapper.toDomain`).
- `sync/*_sync_handler.dart` — `SyncTypeHandler` subclasses that drive `drift_sync_core`.

### `lib/presentation/<feature>/`
- `cubit/` — `Cubit` + `@freezed` state. Cubits depend **only on use cases**, never on repositories or datasources directly.
- screens + `widgets/`.

### `lib/core/` — cross-cutting, framework-agnostic helpers
Errors (`error/`), DI base types, network, sync wiring, constants, extensions, utils. Anything shared across features.

**Rules of thumb:**
- A Cubit imports use cases. It must **not** import anything from `lib/data/`.
- A use case imports a domain repository interface. It must **not** import an `*_impl` or a datasource.
- Drift row classes (e.g. `db.Category`) **stay in the data layer.** Convert to entities with a mapper before returning to domain.
- If you need a new operation, add it to the repository **interface** first, then implement it.

---

## 3. The vertical-slice recipe (adding/extending a feature)

To add a feature end-to-end, follow the existing **Category** slice as the canonical template. Touch files in this order:

1. **Entity** — `lib/domain/entities/<x>_entity.dart` (`@freezed`).
2. **Repository interface** — `lib/domain/repositories/<x>_repository.dart` (returns `Either<Failure, T>`).
3. **Use case(s)** — `lib/domain/usecases/<x>/<verb>_<x>_usecase.dart`, `@injectable`, one per operation, with a `...Params` class.
4. **Drift table** (if persisted) — `lib/data/database/tables/<x>.dart` using `with SyncTable`; register it in `app_database.dart`.
5. **Local datasource** — `lib/data/datasources/<x>/<x>_local_datasource.dart` (abstract + `@Injectable(as: ...)` impl).
6. **Remote datasource + DTO** (if synced) — `..._remote_datasource.dart`, `dtos/<x>_dto.dart`.
7. **Sync handler** (if synced) — `lib/data/sync/<x>_sync_handler.dart` extending `SyncTypeHandler`.
8. **Mapper** — `lib/data/mappers/<x>_mapper.dart`.
9. **Repository impl** — `lib/data/repositories/<x>_repository_impl.dart`, `@LazySingleton(as: <X>Repository)`.
10. **Cubit + state** — `lib/presentation/<x>/cubit/`, `@injectable`.
11. **Wire the Cubit into the tree** — add a `BlocProvider(create: (_) => getIt<XCubit>())` in `lib/presentation/app_widget.dart` (or the feature's local provider) as appropriate.
12. **Run codegen** (Section 5) and **`flutter analyze`**.

> **Adding a field to an existing feature** (vs. a whole new slice)? Trace the same chain, and don't forget the easy-to-miss edit points: the use-case **`...Params` classes** (e.g. `AddCategoryUseCaseParams`), the **mapper**, and **every** method of the sync handler (see §8). A field added to the entity/table but missed in any link is silently dropped at that boundary.

> Reuse existing UI helpers instead of re-implementing them: `showSnackBar`, `showDeleteConfirmationDialog`, `showConfirmationDialog` (`lib/presentation/utils/helpers.dart`, `dialogs.dart`), and `AppNavigator` (`lib/presentation/utils/app_navigator.dart`).

---

## 4. State management — Cubit + freezed (read doc/bloc_cubit_patterns.md)

The app uses **flutter_bloc Cubits** (no events) with **freezed immutable state**. Non-negotiable rules:

- State is a `@freezed` class with a `.initial()` factory and a `required Failure failure` field.
- **Never mutate state** — always `emit(state.copyWith(...))`.
- **Reset the failure at the start of every operation:** `emit(state.copyWith(isLoading: true, failure: const Failure.none()))`.
- Per-operation loading flags: `isLoading`, `isSaving`, `isDeleting`, etc.
- Fold the `Either` result; **store failures in state, never throw out of a Cubit.**
- **Cancel stream subscriptions** in `close()` — forgetting this is a memory leak.
- Side effects (navigation, snackbars) go in `BlocListener` with `listenWhen`; reactive UI goes in `BlocBuilder` with `buildWhen`.

See the doc for the full Add/Update/Delete/listen patterns and anti-patterns.

---

## 5. Code generation — DO NOT hand-edit generated files

Large parts of the codebase are generated. Editing generated files by hand will be overwritten and will break builds.

**Never edit files ending in:** `.g.dart`, `.freezed.dart`, `injection.config.dart`, `assets.gen.dart`, `codegen_loader.g.dart`, `locale_keys.g.dart`, `app_database.g.dart`.

Instead, edit the **source** annotation file and regenerate. (Flutter/Dart are **fvm-pinned** here — see §1. If you run tools through FVM, prefix every command below with `fvm`, e.g. `fvm dart run build_runner ...`, `fvm flutter pub run ...`. The bare forms work only if the pinned SDK is your active `dart`/`flutter`.)

```bash
# freezed / json_serializable / injectable / drift  (run after changing any annotated source)
dart run build_runner build --delete-conflicting-outputs

# assets (after adding/removing an image or SVG under assets/)
dart run flutter_gen_runner          # or: fluttergen -c pubspec.yaml

# localization (after editing assets/translations/*.json)
flutter pub run easy_localization:generate -S "assets/translations/" -O "lib/gen/translations" -o "codegen_loader.g.dart" -f keys
```

Reminders:
- After adding `@injectable`/`@LazySingleton`/`@Injectable` to a class, **run build_runner** so `injection.config.dart` picks it up. A new use case/repository/Cubit that isn't registered will fail at runtime with a `get_it` lookup error.
- After changing a Drift table, run build_runner **and** add a schema migration (see Section 8).

---

## 6. Dependency injection (injectable + get_it)

- The container is `getIt` (`lib/di/injection.dart`); `configureDependencies(env)` is called from `bootstrap.dart`.
- Annotate registrable classes:
  - Repositories: `@LazySingleton(as: <X>Repository)`.
  - Datasources / sync handlers: `@Injectable(as: ...)` / `@lazySingleton`.
  - Use cases & Cubits: `@injectable`.
- Resolve dependencies via **constructor injection**. Only resolve via `getIt<T>()` directly at composition roots (e.g. `BlocProvider(create: (_) => getIt<XCubit>())`).
- Manual registrations and `ignoreUnregisteredTypes` live in `lib/di/injection.dart` — touch with care.

---

## 7. Error handling — `Either<Failure, T>`

- Repository methods return `Future<Either<Failure, T>>`. Wrap datasource calls in `RepositoryErrorHandler.handleApiCall(() async { ... })` (`lib/core/error/repository_error_handler.dart`) — it maps exceptions → typed `Failure`s.
- `Failure` is a freezed union (`lib/core/error/failures/failures.dart`): `serverError`, `networkError`, `validationError`, `unauthorizedError`, `duplicate`, `notFound`, `none`, etc.
- Throw the matching exception from datasources (e.g. `DuplicateException`) — don't return failures from datasources.
- In the UI, use `state.failure.hasError` and `state.failure.customMessage` (already localized). Pass the `Failure` straight to `showSnackBar(message: state.failure)`.

---

## 8. Offline-first sync (drift_sync) — handle with extra care

This is the most fragile subsystem. Breaking it causes silent data loss or sync loops.

- Every **synced** table mixes in `SyncTable` (`lib/data/database/tables/sync_table.dart`). That mixin supplies all sync columns and their server-side `@JsonKey` names — `clientId` (the **primary key**, locally generated), `id` (nullable server id), `userId`, `rev`, `createdAt` / `updatedAt` / `deletedAt`, `lastSyncedAt`. Just write `class Foo extends Table with SyncTable`; never redeclare those columns or change the primary key.
- **Two infrastructure tables back the sync engine — do not treat them as feature tables or touch them unless you are working on sync itself:**
  - `LocalChanges` (`tables/local_changes.dart`) — the outbox queue of pending local mutations (entityType/entityId/rev/data/error/...), keyed by `(entityId, entityType)`.
  - `SyncMetadata` (`tables/sync_meta_data.dart`) — per-entity-type `lastSyncedAt` cursor.
  - `AppDatabase` implements the `drift_sync_core` hooks against these (`getPendingLocalChanges`, `insertLocalChange`, `concludeLocalChange`, `getLocalSyncMetadata`, …). Don't bypass them with ad-hoc reads/writes.
- **Client IDs:** generate local rows' `clientId` with `generateDeviceScopedId()` (`lib/core/utils/id_helper.dart`). Never reuse or hand-craft IDs.
- Repository write methods write **locally first**, then fire-and-forget the sync via `unawaited(post(...))` / `put(...)` / `delete(...)` (provided by `SyncEntityRepository`). Keep this pattern — the UI must not wait on the network.
- Each synced entity needs a `*SyncHandler` implementing marshal/unmarshal, local upsert/delete, and id resolution. Mirror an existing handler exactly.
  - **When you add a field to a synced entity, audit the WHOLE handler — not just `upsertLocal`.** Some handler methods **hand-build the data class** instead of returning the Drift row (e.g. `CategorySyncHandler.getLocalByServerId` does `return Category(id: …, name: …, …)`). A hand-built constructor **silently drops any column you don't list**, so add your new field there too. `marshal`/`unmarshal` that delegate to the generated `toJson()`/`fromJson()` pick up new columns automatically after codegen; hand-built constructors do not.
- Sync triggers (lifecycle/connectivity/5-min timer) are wired in `bootstrap.dart`. Don't add ad-hoc sync calls.

### Drift migrations (any table change is a schema change)

The app migrates with drift's **`stepByStep`** strategy. The moving parts:

- `lib/data/database/app_database.dart` — the `schemaVersion` getter and the **hand-written** `from<N>To<M>` callbacks (the `Migrations` extension at the bottom; see the existing `from4To5`).
- `lib/data/database/app_database.steps.dart` — generated per-version schema snapshots (`// GENERATED BY drift_dev, DO NOT MODIFY`).
- `drift_schemas/default/drift_schema_v<N>.json` — exported schema per version.
- `test/drift/default/generated/schema_v<N>.dart` — generated snapshots used by `test/drift/default/migration_test.dart`.

> `default` is the database name from `build.yaml` (`databases: { default: ... }`). drift's default `schema_dir` (`drift_schemas/`) and `test_dir` (`test/drift/`) already match this repo, so no extra config is needed.

**The tool scaffolds; you (with AI help) write the actual logic.** `drift_dev make-migrations` regenerates the schema snapshots, the `.steps.dart` file, and the test files — and adds an **empty** `from<N>To<M>` callback. It cannot infer your intent, so you fill in each callback body by hand (`createTable` / `addColumn` / data backfills).

**Workflow when you add/alter/remove a table or column:**

1. Edit the table under `lib/data/database/tables/` (register new tables in the `@DriftDatabase(tables: [...])` list in `app_database.dart`).
2. **Bump `schemaVersion`** (e.g. `5` → `6`) in `app_database.dart`.
3. Regenerate code + migration scaffolding:
   ```bash
   dart run build_runner build --delete-conflicting-outputs   # app_database.g.dart, freezed, etc.
   dart run drift_dev make-migrations                          # schema json + .steps.dart + test snapshots
   ```
4. **Fill in the new `from<old>To<new>` callback** in the `Migrations` extension in `app_database.dart`, using the `schema.*` snapshot — never the live tables. Example:
   ```dart
   from5To6: (Migrator m, Schema6 schema) async {
     await m.createTable(schema.myNewTable);
     // await m.addColumn(schema.transactions, schema.transactions.newColumn);
   },
   ```
5. Run `flutter test` (the migration tests live in `test/drift/default/migration_test.dart`). The simple-migration suite currently ships `skip: true`, and the data-integrity tests are TODO templates — for column type/constraint changes (not pure additions), fill in a data-integrity test so the migration is proven not to lose data.

**Never** change a table without bumping the version and adding a step callback — existing users' on-device databases will fail to open or silently lose data. Also note `build.yaml` sets `store_date_time_values_as_text: true`, so `DateTime` columns persist as ISO text.

---

## 9. Localization, assets & theming

**Localization**
- **No hardcoded user-facing strings.** Add the key to every `assets/translations/<lang>.json` (en, de, es, fr, it, ru), regenerate (Section 5), then use `LocaleKeys.my_key.tr()`.

**Assets**
- Reference via generated `Assets` (`Assets.images...`), not raw string paths. Regenerate after adding files.

**Theming (light + dark — every screen must work in both)**
- Themes are defined in `lib/presentation/utils/theme.dart` as `AppTheme.lightTheme` / `AppTheme.darkTheme`, applied in `MaterialApp` and switched by `ThemeCubit` (mode is persisted in Config under `ConfigConstants.theme`). Component styling (buttons, cards, inputs, date/time pickers) is themed centrally there — prefer relying on the theme over per-widget overrides.
- **Use semantic design tokens, not raw colors.** Colors live in the `AppTones` theme extension (`lib/presentation/utils/design_tokens.dart`) and are read via the `context.tones` getter — e.g. `context.tones.brand.accent`, `context.tones.income`, `context.tones.textMuted`, `context.tones.tone(...)`. These resolve to the right light/dark value automatically.
- **Do NOT hardcode `Color(0xFF…)` in widgets**, and avoid the legacy flat globals in `lib/presentation/utils/colors.dart` and `lib/core/constants/colors.dart` — they predate `AppTones` and are being migrated away from. New or changed UI should use `context.tones` (and `Theme.of(context)` for text/component styles). Hardcoded colors break dark mode.
- ⚠️ **Some existing screens predate `AppTones` and still hardcode colors** (e.g. the Category add form hardcodes `Color(0xFFEB5757)` as its accent). When §3 says "copy the nearest feature," copy its *structure*, **not** its color usage — replace any hardcoded `Color(...)` with the matching `context.tones` token as you go.
- **Responsive sizing:** the app uses `flutter_screenutil` (design size 390×844, set in `bootstrap.dart`). Express font/icon sizes and dimensions with `.sp` (and `.w` / `.h` / `.r` where appropriate) — e.g. `fontSize: 13.sp`, `size: 16.sp` — not raw logical pixels.

---

## 10. Build, run, test

Three flavors, each with its own entrypoint and Firebase config:

```bash
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging     --target lib/main_staging.dart
flutter run --flavor production  --target lib/main_production.dart
```
(VS Code launch configs `mobile:development|staging|production` are in `.vscode/launch.json`.)

```bash
flutter pub get          # after editing pubspec.yaml
flutter analyze          # must pass — enforced by the pre-commit hook
flutter test             # must pass — enforced by the pre-push hook
dart format .            # formatting standard
```

Tests live in `test/` (`unit/`, `widget/`, `drift/`). Use `mocktail` and `bloc_test`.

---

## 11. Git, commits, and hooks

- **Branch** off `dev` (the main branch). Don't commit directly to `dev`.
- **Conventional Commits, sentence-case subject, ≤72 chars** (enforced by commitlint). Allowed types: `feat, fix, docs, style, refactor, test, chore, build, ci, enh, enhance, tweak, imp, improve`.
- Hooks (Husky) run automatically:
  - **pre-commit:** `lint_staged` + `flutter analyze` (+ GitHub Actions validation). Commit is blocked if analysis fails.
  - **pre-push:** `flutter test`.
- Don't bypass hooks (`--no-verify`) to land code.

---

## 12. Guardrails — before you finish, verify you did NOT:

- [ ] Import `lib/data/...` from a Cubit, screen, or use case.
- [ ] Edit a generated file (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`, etc.) by hand.
- [ ] Add an `@injectable`/repository/Cubit without running build_runner (→ runtime `get_it` failure).
- [ ] Mutate Cubit state instead of `copyWith`, or forget to reset `failure` / cancel a subscription in `close()`.
- [ ] Return Drift row types from the domain layer instead of mapping to entities.
- [ ] Change a Drift table without bumping the schema version + adding a migration + updating migration tests.
- [ ] Hardcode a user-facing string, a raw asset path, or a `Color(0xFF…)` / raw pixel size (use `LocaleKeys`, `Assets`, `context.tones`, `.sp`) — and verify the screen still works in **dark mode**.
- [ ] Read/write the sync infrastructure tables (`LocalChanges`, `SyncMetadata`) directly, or redeclare `SyncTable` columns on a feature table.
- [ ] Make the UI block on a network/sync call (writes are local-first; sync is fire-and-forget).
- [ ] Leave `flutter analyze` or `flutter test` failing.

When unsure how something should look, **find the equivalent in an existing feature (Category, Wallet, Budget) and match it.**
