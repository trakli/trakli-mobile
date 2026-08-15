import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
import 'package:trakli/core/network/interceptors/crash_reporting_interceptor.dart';
import 'package:trakli/core/network/interceptors/locale_interceptor.dart';
import 'package:trakli/core/network/interceptors/logger_interceptor.dart';
import 'package:trakli/core/network/interceptors/remove_null_exceptions.dart';
import 'package:trakli/core/network/interceptors/token_interceptor.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/di/injection.dart';

@module
abstract class InjectHttpClientModule {
  @Named('HttpUrl')
  @dev
  String get devHttpUrl => 'https://api.dev.trakli.app/api/v1/';

  @Named('HttpUrl')
  @prod
  String get prodHttpUrl => 'https://api.trakli.app/api/v1/';

  @lazySingleton
  Dio dio(@Named('HttpUrl') String url) {
    final dio = Dio(
      BaseOptions(
        baseUrl: url,
        headers: {'Accept': 'application/json'},
        // Without these, a stalled connection falls through to the OS socket
        // timeout, which can hang a request for minutes.
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([
      RemoveNullValuesInterceptor(),
      TokenInterceptor(getIt<TokenManager>(), getIt<AuthService>()),
      LocaleInterceptor(),
      LoggerInterceptor(),
      CrashReportingInterceptor(getIt<CrashReportingService>()),
    ]);

    return dio;
  }
}
