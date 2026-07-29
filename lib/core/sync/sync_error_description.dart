import 'package:dio/dio.dart';

/// Human-readable form of a sync failure for local_changes.error, carrying
/// the response body DioException.toString() omits.
String describeSyncError(Object error, {int maxBodyLength = 500}) {
  if (error is DioException) {
    final options = error.requestOptions;
    final status = error.response?.statusCode;
    final head =
        'HTTP ${status ?? 'error'} on ${options.method} ${options.uri.path}';
    final body = error.response?.data?.toString() ?? '';
    if (body.isEmpty) return '$head — ${error.message ?? error.type.name}';
    return '$head — ${body.length > maxBodyLength ? body.substring(0, maxBodyLength) : body}';
  }
  return error.toString();
}
