/// Converts a semantic version string (e.g. "1.2.3") to a comparable integer
/// for version comparison. Format: major * 100000 + minor * 1000 + patch.
int getExtendedVersionNumber(String version) {
  final parts = version.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  final major = parts.isNotEmpty ? parts[0] : 0;
  final minor = parts.length > 1 ? parts[1] : 0;
  final patch = parts.length > 2 ? parts[2] : 0;
  return major * 100000 + minor * 1000 + patch;
}
