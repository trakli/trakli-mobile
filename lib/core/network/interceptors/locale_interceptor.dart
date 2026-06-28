import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/presentation/utils/globals.dart';

/// Sends the user's current app locale as `Accept-Language` so the backend
/// (and the AI it calls) responds and localizes its messages in that language.
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
