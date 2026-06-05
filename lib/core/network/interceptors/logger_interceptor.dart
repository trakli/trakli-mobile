import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';

import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    // Customize the printer
    printer: PrettyPrinter(
      methodCount: 0,
    ),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger
      ..e('${options.method} request => $requestPath') // Debug log
      ..d('Error: ${err.error}, Message: ${err.message}') // Error log
      ..d('Response data: ${err.response?.data}') // Response log
      ..d('Response status code: ${err.response?.statusCode}'); // Response log
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath'); // Info log
    logger.i('Headers:');

    options.headers.forEach((k, dynamic v) => logger.i('$k: $v'));

    if (options.data != null) {
      logger.i('body => ${options.data}');
    }

    logger.d('\n'
        '-- headers --\n'
        '${options.headers.toString()} \n'
        '');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger.d(
      'StatusCode: ${response.statusCode} \n'
      'Headers: ${response.headers.toString()}',
    );
    final encoded = jsonEncode(response.data);
    const chunkSize = 800;
    for (var i = 0; i < encoded.length; i += chunkSize) {
      final end =
          (i + chunkSize < encoded.length) ? i + chunkSize : encoded.length;
      debugPrint('Data[${i ~/ chunkSize}]: ${encoded.substring(i, end)}');
    }
    return super.onResponse(response, handler);
  }
}
