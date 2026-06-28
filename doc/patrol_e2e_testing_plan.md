# Patrol E2E Testing Plan

> Status: **Planned — not yet implemented.** This document is the implementation
> blueprint. Nothing in here has been added to the codebase yet.

## 1. Goal & scope

Add native end-to-end (E2E) / integration testing with
[Patrol](https://patrol.leancode.co/) to cover the critical user journeys that
unit and widget tests cannot reach — flows that cross native boundaries
(permission dialogs, system file/photo pickers, OAuth webviews, secure storage)
and span multiple screens, cubits, the Drift database, and the network layer.

We currently have **18 unit/widget/drift tests** and **zero integration tests**.
The CI `test` job in [build.yml](../.github/workflows/build.yml) runs only
`flutter test`. This plan closes that gap.

### Why Patrol (vs. plain `integration_test`)

| Need in Trakli | Plain `integration_test` | Patrol |
|---|---|---|
| Tap native permission dialogs (camera, photos) | ❌ | ✅ `$.native.grantPermissionWhenInUse()` |
| Drive system file picker / `image_picker` / `pdfx` import | ❌ | ✅ native automation |
| OAuth webview (Google / Apple sign-in) | ❌ flaky | ✅ native interaction |
| Hot-restart between tests, better finders | partial | ✅ `patrol_finders` |
| Run on real devices / CI | ✅ | ✅ via `patrol_cli` |

Trakli leans on `image_picker`, `image_cropper`, `file_picker`, `pdfx`,
`flutter_secure_storage`, `google_sign_in`, and `sign_in_with_apple` — all of
which touch native UI. That is exactly Patrol's sweet spot.

### Non-goals

- Replacing unit/widget/drift tests (they stay; E2E is the top of the pyramid).
- Visual / golden testing.
- Load/performance testing.

## 2. Key facts this plan is built on

- **Flutter** pinned to `3.38.9` via `.fvmrc`; Dart SDK `>=3.4.3 <4.0.0`.
- **Flavors:** `development`, `staging`, `production` with entrypoints
  `lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`,
  all delegating to [bootstrap.dart](../lib/bootstrap.dart).
- **App ID:** `com.whilesmart.trakli` (`.dev`, `.stg` suffixes per flavor).
- **iOS:** deployment target `13.0`.
- **DI:** `configureDependencies(String env)` in [injection.dart](../lib/di/injection.dart);
  base URL is flavor-driven in [http_module.dart](../lib/core/module/http_module.dart)
  (dev → `https://api.dev.trakli.app/api/v1/`).
- **Auth/session:** access + refresh tokens live in **SharedPreferences**
  (`auth_token`, `auth_refresh_token`) via
  [token_manager.dart](../lib/data/datasources/auth/token_manager.dart);
  onboarding state in `onboarding_completed`
  ([preference_manager.dart](../lib/data/datasources/auth/preference_manager.dart)).
- **Root widget:** `AppWidget` ([app_widget.dart](../lib/presentation/app_widget.dart)),
  a `MultiBlocProvider` that routes authenticated → `MainNavigationScreen`,
  unauthenticated → `LoginScreen`/`OnboardingScreen`.
- **Startup side effects (important for tests):** `bootstrap()` calls
  `Firebase.initializeApp`, crash reporting, `FeatureRemoteConfig`,
  `RemoteUpdateCheck`, and attaches a 5-minute sync trigger. These must be
  neutralized or stubbed under test (see §5).
- **No widget `Key`s** exist today → finders rely on text/icon. We add keys as a
  prerequisite (see §4).

## 3. Dependencies & versions

Add to `pubspec.yaml` `dev_dependencies`:

```yaml
dev_dependencies:
  patrol: ^4.0.0            # verify the exact version compatible with Flutter 3.38.9
  integration_test:
    sdk: flutter
```

CLI (developer machines + CI):

```bash
dart pub global activate patrol_cli
patrol doctor   # verifies Android/iOS native setup
```

> Pin the precise `patrol` version with `flutter pub add dev:patrol` so it
> resolves against the pinned SDK rather than guessing. tmail-flutter runs
> `patrol 4.5.0`, which is a good reference point for this ecosystem.

Add Patrol config at repo root `patrol.yaml`:

```yaml
android:
  package_name: com.whilesmart.trakli.dev
ios:
  bundle_id: com.whilesmart.trakli.dev   # confirm dev bundle id in Xcode
```

## 4. Prerequisite: make the app testable (do this first)

These small refactors make every later test stable and cheap. They are the
highest-leverage part of the plan.

### 4a. Extract `initializeApp()` from `bootstrap()`

Today `bootstrap()` does async init **and** calls `runApp`. Tests need the init
without `runApp`. Split it:

```dart
// lib/bootstrap.dart
Future<void> initializeApp(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();           // skippable under test
  configureDependencies(env);
  await _initServices();           // version, remote config, etc.
  await EasyLocalization.ensureInitialized();
}

Future<void> bootstrap(String env) async {
  await initializeApp(env);
  _attachSyncTriggers();           // NOT called in tests
  runApp(_wrapApp(const AppWidget()));
}
```

Tests then call `initializeApp('development')` and pump `_wrapApp(AppWidget())`
themselves. This keeps prod behavior identical while giving tests a clean hook.

### 4b. Add `Key`s to critical interactive widgets

Text-based finders break when copy/translations change and are ambiguous when a
label repeats. Add stable keys to the widgets the E2E tests drive. Proposed
convention: `Key('<screen>_<element>')`.

Minimum set for Phase 1–2:

| Screen | Widget | Proposed key |
|---|---|---|
| `login_screen.dart` | "Login with email" button | `login_email_btn` |
| `login_with_email_screen.dart` | email field | `login_email_field` |
| `login_with_email_screen.dart` | password field | `login_password_field` |
| `login_with_email_screen.dart` | submit button | `login_submit_btn` |
| `main_navigation_screen.dart` | add-transaction FAB | already `heroTag: 'addFab'` → add `Key('home_add_fab')` |
| `add_transaction_form_compact_layout.dart` | amount field | `txn_amount_field` |
| `add_transaction_form_compact_layout.dart` | submit button | `txn_submit_btn` |
| `wallet_screen.dart` | add-wallet button | `wallet_add_btn` |

> Keys are additive and harmless to production. Bundle them with each test PR so
> they land next to the test that needs them.

### 4c. Decide the backend strategy (decision needed — see §9)

Three options, pick per environment:

1. **Live `development` backend** — simplest; tests hit `api.dev.trakli.app`.
   Pro: realistic. Con: flaky/slow, needs a stable seeded test account, network
   dependency in CI.
2. **Mock server / Dio interceptor** — register a fake `Dio` (or
   `http_mock_adapter`) in `getIt` after `configureDependencies`, returning
   canned JSON. Pro: hermetic, fast, deterministic. Con: must maintain fixtures.
3. **Hybrid** — smoke/auth against live dev; data flows against mocked HTTP.

Recommended default: **option 2 (mocked HTTP)** for CI determinism, with a small
nightly **option 1** suite against live dev for contract drift.

## 5. Test harness design

Create `integration_test/` with a shared harness so individual tests stay short.

```
integration_test/
├── e2e_test.dart                 # entry that aggregates suites (for `patrol test`)
├── helpers/
│   ├── patrol_harness.dart       # initializeApp + pump AppWidget + reset DI/db
│   ├── auth_seed.dart            # seed/clear tokens + onboarding flags
│   ├── http_mock.dart            # fake Dio / fixtures (if option 2)
│   └── finders.dart              # KeyedFinders for the keys added in §4b
└── flows/
    ├── smoke_test.dart
    ├── auth_login_test.dart
    ├── add_transaction_test.dart
    ├── wallet_create_test.dart
    └── navigation_test.dart
```

### Harness responsibilities (`patrol_harness.dart`)

```dart
Future<void> pumpTrakliApp(
  PatrolIntegrationTester $, {
  String env = 'development',
  bool authenticated = false,
}) async {
  await getIt.reset();                 // clean container per test
  await initializeApp(env);            // from §4a (Firebase stubbed in test mode)
  if (option2_mockHttp) registerMockHttp();
  await resetDatabase();               // AppDatabase().deleteAllData() or fresh db
  authenticated ? await seedAuthToken() : await clearAuthToken();
  await $.pumpWidgetAndSettle(wrapApp(const AppWidget()));
}
```

### Auth seeding (`auth_seed.dart`)

```dart
Future<void> seedAuthToken() async {
  final tm = getIt<TokenManager>();
  await tm.persistToken('test-access-token');
  await tm.persistRefreshToken('test-refresh-token');
  // mark onboarding complete so we land on MainNavigationScreen
  await getIt<PreferenceManager>().setOnboardingCompleted(true);
}

Future<void> clearAuthToken() async => getIt<TokenManager>().clearToken();
```

This lets data-flow tests (add transaction, wallet) start already logged in,
instead of going through OAuth every run.

### Firebase under test

`Firebase.initializeApp` must not call the network in CI. Options: guard
`_initFirebase()` behind a `const bool.fromEnvironment('PATROL_TEST')` flag set
via `--dart-define`, or use `firebase_auth_mocks` / no-op. Crashlytics, remote
config, and the 5-minute sync trigger should be **disabled** in test mode.

## 6. Test scenarios (prioritized)

Ordered by value-to-effort. Each is one file under `integration_test/flows/`.

### Phase 1 — Smoke & auth (prove the harness works)

1. **App boots** — `pumpTrakliApp(authenticated: false)` settles and shows
   onboarding/login without crashing. (Validates §4a + §5 end-to-end.)
2. **Login with email (happy path)** — from `LoginScreen` → tap
   `login_email_btn` → fill `login_email_field` / `login_password_field` → tap
   `login_submit_btn` → assert `MainNavigationScreen` (find `home_add_fab`).
3. **Login validation error** — bad credentials → assert error snackbar/text.

### Phase 2 — Core money flows (the product's reason to exist)

4. **Add expense transaction** — start authenticated → tap `home_add_fab` →
   fill amount, pick wallet/category/date → tap `txn_submit_btn` → assert it
   appears in the home/transactions list and persists in Drift.
5. **Add income transaction** — variant toggling income/expense.
6. **Create wallet** — Wallet tab → `wallet_add_btn` → fill form → assert it
   shows in the wallet list and is selectable in the add-transaction dropdown.

### Phase 3 — Native-boundary flows (Patrol's unique value)

7. **Attach receipt via camera** — add-transaction → attachment → Patrol grants
   the camera permission dialog (`$.native.grantPermissionWhenInUse()`) →
   capture → assert attachment chip appears.
8. **Import document** (`file_picker` + `pdfx`) — drive the native picker, select
   a bundled fixture PDF, assert parsed/preview state.
9. **OAuth sign-in (Google)** — drive the native webview far enough to assert the
   flow launches and returns (may stay in nightly-only suite due to flakiness).

### Phase 4 — Cross-cutting

10. **Bottom-nav navigation** — visit Home / Statistics / Wallet / Budgets,
    assert each renders.
11. **Pull-to-refresh sync** — trigger refresh on home, assert sync runs and
    list reconciles (against mocked HTTP).
12. **Logout** — drawer → logout → assert tokens cleared and back at login.

## 7. Example test (reference implementation)

```dart
// integration_test/flows/add_transaction_test.dart
import 'package:patrol/patrol.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/patrol_harness.dart';
import '../helpers/finders.dart';

void main() {
  patrolTest('logged-in user can add an expense', ($) async {
    await pumpTrakliApp($, authenticated: true);

    // Land on home, open the add-transaction sheet
    await $(K.homeAddFab).tap();

    await $(K.txnAmountField).enterText('2500');
    // category / wallet dropdowns — keyed in §4b
    await $(K.txnCategoryDropdown).tap();
    await $(#groceriesOption).tap();

    await $(K.txnSubmitBtn).tap();
    await $.pumpAndSettle();

    // Assert it surfaced in the list and persisted
    expect($('2500'), findsOneWidget);
    final count = await getIt<AppDatabase>().transactionCount();
    expect(count, greaterThan(0));
  });
}
```

## 8. CI integration

Add a dedicated workflow (or a gated job in
[build.yml](../.github/workflows/build.yml)). Keep it **separate from the fast
`flutter test` job** so unit tests stay quick and E2E can run on a heavier
runner / schedule.

```yaml
# .github/workflows/e2e.yml
name: E2E (Patrol)
on:
  pull_request:
    paths: ['lib/**', 'integration_test/**', 'pubspec.yaml']
  schedule:
    - cron: '0 2 * * *'   # nightly live-dev suite
jobs:
  android-e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: 3.38.9, cache: true }
      - run: dart pub global activate patrol_cli
      - uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 30
          arch: x86_64
          script: patrol test --flavor development --target integration_test/e2e_test.dart
```

Notes:
- Android emulator on `ubuntu-latest` is cheapest; add an iOS job on
  `macos-latest` once Android is green.
- Use `--flavor development` so it builds the dev entrypoint/app id.
- Pass secrets (test account creds, `--dart-define PATROL_TEST=true`) via repo
  secrets; reference [ENV_AND_SECRETS.md](../.github/ENV_AND_SECRETS.md).
- Gate PRs on the **Phase 1–2 (mocked)** suite only; keep native/OAuth and
  live-dev flows in the nightly `schedule` run to avoid PR flakiness.

## 9. Open decisions (resolve before Phase 1)

1. **Backend strategy** (§4c): mocked HTTP vs live dev vs hybrid. → recommend
   mocked for PR CI, live for nightly.
2. **Firebase in test**: dart-define guard vs mock package.
3. **Test account**: do we provision a seeded `development` user + reset
   mechanism, or stay fully hermetic with mocks?
4. **iOS scope**: Android-only at first, or both platforms from day one?
5. **Where keys live**: confirm the `<screen>_<element>` naming and whether to
   centralize them in a `keys.dart` constants file.

## 10. Implementation roadmap (checklist)

**Phase 0 — Setup (≈0.5 day)**
- [ ] Add `patrol` + `integration_test` to `pubspec.yaml`; `patrol doctor` green.
- [ ] Native setup: Android instrumentation runner + `androidTest`, iOS UITest
      target (`patrol` package setup steps).
- [ ] Add `patrol.yaml`.

**Phase 1 — Testability + smoke/auth (≈1.5 days)**
- [ ] Refactor `bootstrap.dart` → `initializeApp()` (§4a).
- [ ] Add Phase 1–2 widget `Key`s (§4b).
- [ ] Build harness + auth seeding + (chosen) HTTP strategy (§5).
- [ ] Write smoke + login tests; get green locally.

**Phase 2 — Core money flows (≈2 days)**
- [ ] Add transaction (expense/income), create wallet tests.
- [ ] Wire the Phase 1–2 suite into PR CI (mocked) (§8).

**Phase 3 — Native-boundary flows (≈2 days)**
- [ ] Camera/photo permission + attachment, file/PDF import, OAuth (nightly).

**Phase 4 — Cross-cutting + hardening (≈1 day)**
- [ ] Navigation, pull-to-refresh sync, logout.
- [ ] Nightly live-dev suite; flake triage; document run instructions in
      [CONTRIBUTING.md](../CONTRIBUTING.md).

## 11. Local run cheatsheet (for when implemented)

```bash
# one flow, on a connected device/emulator
patrol test --flavor development --target integration_test/flows/auth_login_test.dart

# full suite
patrol test --flavor development --target integration_test/e2e_test.dart

# verify native setup
patrol doctor
```

## 12. References

- Patrol docs: https://patrol.leancode.co/
- Reference usage (tmail-flutter, `patrol 4.5.0`):
  https://github.com/linagora/tmail-flutter
- Internal: [bloc_cubit_patterns.md](bloc_cubit_patterns.md),
  [drift_sync_crash_reporting.md](drift_sync_crash_reporting.md)
