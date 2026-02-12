# Fastlane in GitHub Actions – verification summary

## Gemfile layout (aligned with mindpad)

- **iOS**: `ios/fastlane/Gemfile` (fastlane + cocoapods + plugins). `ios/Gemfile` evals it so workflows using `working-directory: ios` still work.
- **Android**: `android/fastlane/Gemfile` (fastlane + plugins). `android/Gemfile` at repo root is still used by deploy-with-fastlane.

## Workflows and lanes

| Workflow | Job / step | Working dir | Lanes used | Status |
|----------|------------|-------------|------------|--------|
| **ios-release.yml** | Setup Ruby | `ios/fastlane` | — | ✓ Uses `ios/fastlane/Gemfile` |
| **ios-release.yml** | Release to TestFlight (Dev/Staging/Prod) | `ios/fastlane` | `release_testflight_dev`, `release_testflight_staging`, `release_app_store` | ✓ |
| **ios-release.yml** | Release to Firebase | `ios/fastlane` | `release_firebase` | ✓ |
| **android-release.yml** | Setup Ruby | `android/fastlane` | — | ✓ Uses `android/fastlane/Gemfile` |
| **android-release.yml** | Release to Firebase / Play Store | `android/fastlane` | `release_play_store_using_firebase`, `release_play_store` | ✓ |
| **deploy-with-fastlane.yaml** | iOS: Set up Ruby, pod install, fastlane | `ios` | `release_app_store` | ✓ `ios/Gemfile` evals `fastlane/Gemfile` |
| **deploy-with-fastlane.yaml** | Android: Set up Ruby, fastlane | `android` | `release_play_store` | ✓ Uses `android/Gemfile` |
| **ios-setup.yml** | Setup Ruby, fastlane | `ios` | `setup_certificates` | ✓ `ios/Gemfile` evals `fastlane/Gemfile` |

## Build number and version

- **Root `Fastfile`**: `get_build_number(store, app_identifier)` uses `get_new_build_number` (from `fastlane-plugin-get_new_build_number`) to fetch the next build from App Store Connect / Play Store.
- **Root `Fastfile`**: `get_version_from_pubspec` reads `pubspec.yaml` for the version.
- **Plugins**: `fastlane-plugin-versioning` (iOS) and `fastlane-plugin-versioning_android` (Android) are available for reading/incrementing version in native projects; the main lanes still rely on the root Fastfile helpers above.

## After adding or changing gems

From repo root:

```bash
cd ios/fastlane && bundle install && cd ../..
cd android/fastlane && bundle install && cd ../..
# If you use working-directory: ios in CI, also:
cd ios && bundle install && cd ..
```

Commit any updated `Gemfile.lock` files.
