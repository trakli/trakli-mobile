import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/presentation/utils/globals.dart';

class LocaleInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      options.headers['Accept-Language'] = context.locale.languageCode;
    }
    return handler.next(options);
  }
}
