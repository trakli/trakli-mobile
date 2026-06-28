# Bloc Lint + Framework-Aware Static Analysis Plan

> Status: **Planned — not yet implemented.** This is the implementation
> blueprint. Nothing here has been added to the codebase yet.

## 1. Goal & scope

Layer **Bloc-aware static analysis** on top of the existing `flutter_lints`
baseline, so the analyzer catches Cubit/Bloc anti-patterns that generic Dart
lints miss (business logic leaking Flutter imports, public mutable fields on
state, inconsistent file naming, etc.).

This mirrors what tmail-flutter does with `riverpod_lint` — framework-specific
lints for their state-management library. Our library is **Bloc/Cubit**
(`flutter_bloc ^9.1.1`, `bloc ^9.0.0`), so the direct analog is the official
[`bloc_lint`](https://pub.dev/packages/bloc_lint) package from the Bloc author.

### Scope

- **Primary:** add `bloc_lint` (official, Bloc-specific) and wire it into editor,
  pre-commit, and CI.
- **Optional (Phase 4):** add `custom_lint` for *project-specific* rules we write
  ourselves (the framework `riverpod_lint` is built on).
- **Optional (appendix):** tighten the base `flutter_lints` ruleset, which is
  currently the bare default with zero customizations.

### Non-goals

- Migrating state management (we keep Cubit).
- Adopting `very_good_analysis` wholesale (considered in the appendix, not the
  main plan).

## 2. Current state (what this builds on)

- [analysis_options.yaml](../analysis_options.yaml): includes
  `package:flutter_lints/flutter.yaml`, ignores `invalid_annotation_target`,
  excludes `android/vendor/**` + `ios/vendor/**`. **No custom lint rules, no
  generated-file exclusion.**
- [pubspec.yaml](../pubspec.yaml): `flutter_lints: ^4.0.0`; SDK
  `>=3.4.3 <4.0.0`; `flutter_bloc ^9.1.1`, `bloc ^9.0.0`, `bloc_test ^10.0.0`.
- **Pre-commit** (husky + `lint_staged`) already runs, per pubspec:
  `dart fix --apply && dart format && dart analyze --fatal-infos --fatal-warnings`
  on staged `lib/**.dart` (excluding `*.g.dart` / `*.freezed.dart`). This is
  already stricter than tmail's setup.
- **CI** [build.yml](../.github/workflows/build.yml): `analyze` job runs
  `build_runner` then `flutter analyze`; `test` job runs `flutter test`.
- Cubits live per-feature under `lib/presentation/**/cubit/` (e.g.
  `transactions/cubit/transaction_cubit.dart`, `auth/cubits/...`).

## 3. Important: `bloc_lint` is a *separate* linter

This is the single most important thing to understand before implementing.

`bloc_lint` is **not** a `flutter_lints` rule set and **not** a Dart analyzer
plugin in the `dart analyze` pipeline. It is a standalone linter executed by the
**`bloc` CLI** (shipped via the `bloc_tools` global package), reading its own
`bloc:` section from `analysis_options.yaml`.

Consequences:

- `flutter analyze` will **not** report `bloc_lint` violations. We must add a
  dedicated `bloc lint .` step to pre-commit and CI, or they won't be enforced.
- The existing `include: package:flutter_lints/flutter.yaml` and the new `bloc:`
  section coexist — they're consumed by two different tools.
- Editor diagnostics require the Bloc VS Code/IntelliJ extension (LSP), separate
  from the Dart analyzer. (Confirm current editor-integration story during
  Phase 0; CLI enforcement works regardless.)

> This is different from tmail's `riverpod_lint`, which *is* a `custom_lint`
> plugin and therefore shows up in `dart analyze`. For Bloc, the official tool is
> CLI-based. If we want everything inside `dart analyze` instead, that's the
> `custom_lint` route in §7.

## 4. Compatibility / blocker to resolve first

`bloc_lint` requires **Dart ≥ 3.7.0**. Our `pubspec.yaml` floor is `>=3.4.3`.

- Flutter `3.38.9` (pinned in `.fvmrc` and CI) ships a Dart that is ≥ 3.7, so it
  runs fine in practice.
- But we must **bump the pubspec SDK floor** to `>=3.7.0` (or whatever the
  bundled Dart is) so resolution succeeds and we don't claim to support a Dart
  that can't run our dev tooling.
- Action in Phase 0: run `dart --version` under FVM, then set
  `environment: sdk: ">=3.7.0 <4.0.0"` (adjust to actual). Verify the app still
  resolves and builds — this is the only change with blast radius beyond tooling.

## 5. Dependencies

```bash
# global CLI (developer machines + CI)
dart pub global activate bloc_tools

# dev dependency
dart pub add --dev bloc_lint
```

Resulting `pubspec.yaml` `dev_dependencies` addition:

```yaml
dev_dependencies:
  # ...existing...
  bloc_lint: ^0.x.x   # pin the version `dart pub add` resolves for our SDK
```

## 6. Configuration

Because we already use `include: package:flutter_lints/flutter.yaml`, we **do
not** use `bloc_lint`'s `include: package:bloc_lint/recommended.yaml` (only one
`include:` is allowed). Instead, add an explicit top-level `bloc:` section.

Proposed [analysis_options.yaml](../analysis_options.yaml):

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "android/vendor/**"
    - "ios/vendor/**"
    # consider also excluding generated code from analysis noise:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/di/injection.config.dart"
    - "lib/gen/**"

# Consumed by the `bloc` CLI (bloc_lint), NOT by `flutter analyze`.
bloc:
  rules:
    - avoid_flutter_imports
    - avoid_public_fields
    - prefer_file_naming_conventions
    # add incrementally (see §6.2):
    # - prefer_void_public_cubit_methods
    # - prefer_cubit
    # - avoid_public_bloc_methods
```

> Verify `flutter analyze` does not warn about the unknown `bloc:` top-level key.
> If it does, that's a Phase 0 finding to resolve (e.g. keep bloc config in a
> separate options file the `bloc` CLI points at).

### 6.1 The rules (recommended set = 5, complete = 9)

| Rule | What it catches | Fit for Trakli |
|---|---|---|
| `avoid_flutter_imports` | Bloc/Cubit business logic importing `package:flutter/material.dart` etc. | **High** — keeps cubits pure / testable; aligns with our clean-architecture layering |
| `avoid_public_fields` | Public mutable fields on Bloc/Cubit/state | **High** — protects immutability (we use `equatable`/`freezed` states) |
| `prefer_file_naming_conventions` | Enforces `*_cubit.dart` / `*_bloc.dart` / `*_state.dart` naming | **High** — we already follow this; the rule prevents drift |
| `avoid_public_bloc_methods` | Public methods on a `Bloc` (should use events) | **Low/medium** — we use Cubits, not event-based Blocs; mostly inert |
| `prefer_void_public_cubit_methods` | Public Cubit methods returning values instead of `void`/emitting state | **Medium** — many of our cubit methods are `Future<void>`; verify it doesn't flag those before enabling |
| `avoid_build_context_extensions` / `prefer_build_context_extensions` | Opinionated, mutually exclusive — pick at most one | **Optional** |
| `prefer_cubit` | Flags `Bloc` usage, nudging toward `Cubit` | **Medium** — matches our Cubit-only convention; enables consistency |
| `prefer_bloc` | Opposite of `prefer_cubit` | **Do not enable** — conflicts with our Cubit convention |

### 6.2 Recommended adoption order

1. **Start with 3 low-friction, high-value rules:** `avoid_flutter_imports`,
   `avoid_public_fields`, `prefer_file_naming_conventions`. These are almost
   certainly near-clean already.
2. **Trial `prefer_cubit`** to lock in the Cubit-only convention.
3. **Trial `prefer_void_public_cubit_methods`** — run it, count violations on our
   `Future<void>` cubit methods; enable only if the churn is acceptable.
4. Leave `prefer_bloc` and the redundant build_context pair off.

## 7. Optional — `custom_lint` for project-specific rules (Phase 4)

`bloc_lint` covers Bloc idioms. For **Trakli-specific** conventions, `custom_lint`
(the framework `riverpod_lint` is built on) lets us write our own analyzer rules
that *do* surface in `dart analyze` and the IDE. Candidate house rules:

- No hardcoded UI strings — require `LocaleKeys.*.tr()` (we use
  `easy_localization`).
- Repository/usecase naming and layering (no `presentation` importing `data`
  directly, etc.).
- Enforce `Key` presence on key interactive widgets (ties into the
  [Patrol plan](patrol_e2e_testing_plan.md)).

Cost: `custom_lint` version must track the analyzer/Dart SDK closely, and we'd
maintain rule code. Treat as a later, separate effort — only if the team wants
bespoke enforcement.

## 8. Enforcement wiring

### 8.1 Pre-commit (husky + lint_staged)

`bloc lint` is repo-wide, not per-file, so add it to the husky **pre-commit**
hook *after* `lint_staged` rather than inside the `lint_staged` globs:

```sh
# .husky/pre-commit (append)
dart run lint_staged
bloc lint .            # NEW — fails the commit on bloc_lint violations
flutter analyze
```

(Confirm the `bloc` CLI is on PATH for contributors; document
`dart pub global activate bloc_tools` in [CONTRIBUTING.md](../CONTRIBUTING.md).)

### 8.2 CI (build.yml analyze job)

Add a step to the existing `analyze` job in
[build.yml](../.github/workflows/build.yml):

```yaml
  analyze:
    name: Analyze code (SAST)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: ${{ env.FLUTTER_CHANNEL }}
          cache: true
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: dart pub global activate bloc_tools      # NEW
      - run: bloc lint .                              # NEW
```

## 9. Rollout strategy (avoid a red wall on day one)

1. **Measure:** install, configure the 3 starter rules, run `bloc lint .`, count
   violations. Do **not** enable in CI yet.
2. **Fix or baseline:** clean up violations in a dedicated PR. For anything
   intentional, use `// ignore: <rule>` / `// ignore_for_file: <rule>` with a
   reason comment.
3. **Enforce:** once green, add the CI + pre-commit steps so regressions are
   blocked.
4. **Expand:** trial additional rules one at a time, repeating measure→fix→enforce.

## 10. Decisions needed (resolve in Phase 0)

1. **SDK floor bump** to `>=3.7.0` — confirm the actual bundled Dart and that the
   app still resolves/builds (§4).
2. Does `flutter analyze` tolerate the `bloc:` key, or do we need a split config
   file (§6)?
3. Which rules ship in the first enforced set — the 3 starters only, or also
   `prefer_cubit` (§6.2)?
4. Adopt `custom_lint` for house rules now or defer (§7)?
5. Do we also exclude generated files from `flutter analyze` while here (§6)?

## 11. Implementation roadmap (checklist)

**Phase 0 — Spike & decisions (≈0.5 day)**
- [ ] `dart --version` under FVM; bump pubspec SDK floor; confirm build.
- [ ] `dart pub global activate bloc_tools`; `dart pub add --dev bloc_lint`.
- [ ] Add `bloc:` section with the 3 starter rules; confirm `flutter analyze`
      stays clean (no unknown-key error).
- [ ] Run `bloc lint .`; record violation count.

**Phase 1 — Clean up & enforce starters (≈0.5–1 day)**
- [ ] Fix/baseline starter-rule violations in one PR.
- [ ] Add `bloc lint .` to husky pre-commit + CI `analyze` job.
- [ ] Document `bloc_tools` setup in [CONTRIBUTING.md](../CONTRIBUTING.md).

**Phase 2 — Expand ruleset (≈0.5 day, iterative)**
- [ ] Trial `prefer_cubit`, then `prefer_void_public_cubit_methods`; enable per
      §9.

**Phase 3 (optional) — Tighten base lints (appendix)**
- [ ] Enable a curated set of additional core Dart lints (see appendix).

**Phase 4 (optional) — custom_lint house rules (§7)**
- [ ] Spike one project-specific rule; decide whether to invest.

## Appendix — optional: tighten the base `flutter_lints` ruleset

Independent of Bloc, our `analysis_options.yaml` enables zero rules beyond the
`flutter_lints` default. High-value, low-friction additions to consider under the
existing `linter: rules:` block:

```yaml
linter:
  rules:
    - prefer_single_quotes
    - require_trailing_commas
    - avoid_redundant_argument_values
    - unnecessary_parenthesis
    - directives_ordering
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - use_super_parameters
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
```

Heavier alternative: replace the `flutter_lints` include with
[`very_good_analysis`](https://pub.dev/packages/very_good_analysis) for a much
stricter baseline (closer to a "max strictness" posture). This is a bigger
cleanup and a separate decision — flagged, not recommended by default.

## 12. References

- [bloc_lint — pub.dev](https://pub.dev/packages/bloc_lint)
- [Bloc Library — Linter Configuration](https://bloclibrary.dev/lint/configuration/)
- [Bloc Library — Customizing Lint Rules](https://bloclibrary.dev/lint/customizing-rules/)
- [Dart — Customizing static analysis](https://dart.dev/tools/analysis)
- Reference (tmail-flutter uses `riverpod_lint`): https://github.com/linagora/tmail-flutter
- Internal: [patrol_e2e_testing_plan.md](patrol_e2e_testing_plan.md),
  [bloc_cubit_patterns.md](bloc_cubit_patterns.md)
