/// Result of checking for an in-app update (Android Play Core).
/// Null or [updateAvailable] false means no in-app update flow is available.
class InAppUpdateInfo {
  const InAppUpdateInfo({
    required this.updateAvailable,
    required this.immediateUpdateAllowed,
    required this.flexibleUpdateAllowed,
  });

  final bool updateAvailable;
  final bool immediateUpdateAllowed;
  final bool flexibleUpdateAllowed;
}
