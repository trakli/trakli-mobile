#!/usr/bin/env bash
# Build staging APK. Use Flutter storage mirror if default (storage.googleapis.com) is unreachable.
set -e
cd "$(dirname "$0")/.."

# Optional: use mirror for Flutter engine artifacts (e.g. when storage.googleapis.com is blocked)
# Uncomment or set in your environment if downloads fail:
# export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

flutter build apk --flavor staging --target lib/main_staging.dart "$@"
