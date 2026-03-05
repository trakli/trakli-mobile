// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:drift_sync_core/drift_sync_core.dart' as _i877;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/app_update/app_version_info.dart' as _i1063;
import '../core/app_update/fake_in_app_update_service.dart' as _i0;
import '../core/app_update/feature_remote_config.dart' as _i196;
import '../core/app_update/in_app_update_service.dart' as _i47;
import '../core/app_update/remote_update_check.dart' as _i493;
import '../core/error/crash_reporting/crash_reporting_interface.dart' as _i414;
import '../core/error/crash_reporting/crash_reporting_service.dart' as _i538;
import '../core/error/crash_reporting/implementations/firebase_crashlytics_service.dart'
    as _i529;
import '../core/error/crash_reporting/user_context_service.dart' as _i481;
import '../core/module/http_module.dart' as _i488;
import '../core/module/sync_module.dart' as _i680;
import '../core/network/network_info.dart' as _i6;
import '../core/services/auth_service.dart' as _i377;
import '../core/services/oauth_service.dart' as _i624;
import '../core/services/request_authorization_service.dart' as _i1066;
import '../core/sync/drift_sync_crash_reporting_adapter.dart' as _i705;
import '../core/sync/drift_sync_crash_reporting_service.dart' as _i545;
import '../core/sync/sync_database.dart' as _i646;
import '../core/sync/sync_service.dart' as _i957;
import '../core/utils/services/shared_prefs.dart' as _i789;
import '../data/database/app_database.dart' as _i704;
import '../data/datasources/auth/auth_local_data_source.dart' as _i276;
import '../data/datasources/auth/auth_remote_data_source.dart' as _i496;
import '../data/datasources/auth/preference_manager.dart' as _i683;
import '../data/datasources/auth/token_manager.dart' as _i483;
import '../data/datasources/benefits/cloud_benefit_remote_data_source.dart'
    as _i61;
import '../data/datasources/category/category_local_datasource.dart' as _i148;
import '../data/datasources/category/category_remote_datasource.dart' as _i558;
import '../data/datasources/configuration/config_local_datasource.dart'
    as _i514;
import '../data/datasources/configuration/configuration_remote_datasource.dart'
    as _i587;
import '../data/datasources/exchange-rate/exchange_rate_local_datasource.dart'
    as _i900;
import '../data/datasources/exchange-rate/exchange_rate_remote_datasource.dart'
    as _i632;
import '../data/datasources/group/group_local_datasource.dart' as _i873;
import '../data/datasources/group/group_remote_datasource.dart' as _i478;
import '../data/datasources/media_file/media_file_local_datasource.dart'
    as _i216;
import '../data/datasources/media_file/media_file_remote_datasource.dart'
    as _i237;
import '../data/datasources/notification/notification_local_datasource.dart'
    as _i937;
import '../data/datasources/notification/notification_remote_datasource.dart'
    as _i513;
import '../data/datasources/party/party_local_datasource.dart' as _i655;
import '../data/datasources/party/party_remote_datasource.dart' as _i656;
import '../data/datasources/subscription/subscription_remote_data_source.dart'
    as _i682;
import '../data/datasources/transaction/transaction_local_datasource.dart'
    as _i662;
import '../data/datasources/transaction/transaction_remote_datasource.dart'
    as _i79;
import '../data/datasources/wallet/wallet_local_datasource.dart' as _i849;
import '../data/datasources/wallet/wallet_remote_datasource.dart' as _i624;
import '../data/repositories/auth_repository_imp.dart' as _i135;
import '../data/repositories/category_repository_impl.dart' as _i324;
import '../data/repositories/cloud_benefit_repository_imp.dart' as _i415;
import '../data/repositories/config_repository_impl.dart' as _i379;
import '../data/repositories/exchange_rate_imp.dart' as _i827;
import '../data/repositories/group_repository_impl.dart' as _i875;
import '../data/repositories/media_repository_impl.dart' as _i74;
import '../data/repositories/notification_repository_impl.dart' as _i888;
import '../data/repositories/party_repository_impl.dart' as _i168;
import '../data/repositories/subscription_repository_imp.dart' as _i1047;
import '../data/repositories/transaction_repository_impl.dart' as _i114;
import '../data/repositories/wallet_repository_impl.dart' as _i305;
import '../data/sync/category_sync_handler.dart' as _i463;
import '../data/sync/config_sync_handler.dart' as _i480;
import '../data/sync/group_sync_handler.dart' as _i235;
import '../data/sync/media_sync_handler.dart' as _i382;
import '../data/sync/notification_sync_handler.dart' as _i217;
import '../data/sync/party_sync_handler.dart' as _i280;
import '../data/sync/transaction_sync_handler.dart' as _i893;
import '../data/sync/wallet_sync_handler.dart' as _i849;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/category_repository.dart' as _i410;
import '../domain/repositories/cloud_benefit_repository.dart' as _i11;
import '../domain/repositories/config_repository.dart' as _i899;
import '../domain/repositories/exchange_rate_repository.dart' as _i1057;
import '../domain/repositories/group_repository.dart' as _i957;
import '../domain/repositories/media_repository.dart' as _i442;
import '../domain/repositories/notification_repository.dart' as _i965;
import '../domain/repositories/party_repository.dart' as _i661;
import '../domain/repositories/subscription_repository.dart' as _i804;
import '../domain/repositories/transaction_repository.dart' as _i118;
import '../domain/repositories/wallet_repository.dart' as _i368;
import '../domain/usecases/app_update/check_app_update_usecase.dart' as _i150;
import '../domain/usecases/app_update/get_app_update_config_usecase.dart'
    as _i854;
import '../domain/usecases/auth/get_loggedin_user.dart' as _i880;
import '../domain/usecases/auth/get_otp_usecase.dart' as _i402;
import '../domain/usecases/auth/is_onboarding_completed.dart' as _i828;
import '../domain/usecases/auth/login_by_email_usecase.dart' as _i42;
import '../domain/usecases/auth/login_by_phone_usecase.dart' as _i498;
import '../domain/usecases/auth/login_with_email_password.dart' as _i768;
import '../domain/usecases/auth/login_with_email_usecase.dart' as _i524;
import '../domain/usecases/auth/login_with_phone_password.dart' as _i723;
import '../domain/usecases/auth/login_with_phone_usecase.dart' as _i400;
import '../domain/usecases/auth/logout_usecase.dart' as _i640;
import '../domain/usecases/auth/onboarding_completed.dart' as _i2;
import '../domain/usecases/auth/password_reset_code_usecase.dart' as _i542;
import '../domain/usecases/auth/password_reset_usecase.dart' as _i494;
import '../domain/usecases/auth/register_usecase.dart' as _i705;
import '../domain/usecases/auth/stream_auth_status.dart' as _i444;
import '../domain/usecases/auth/verify_email_usecase.dart' as _i100;
import '../domain/usecases/category/add_category_usecase.dart' as _i445;
import '../domain/usecases/category/delete_category_usecase.dart' as _i292;
import '../domain/usecases/category/get_categories_usecase.dart' as _i961;
import '../domain/usecases/category/listen_to_categories_usecase.dart' as _i500;
import '../domain/usecases/category/update_category_usecase.dart' as _i986;
import '../domain/usecases/cloud_benefits/fetch_benefits_usecase.dart' as _i61;
import '../domain/usecases/configs/delete_config_usecase.dart' as _i536;
import '../domain/usecases/configs/get_config_usecase.dart' as _i933;
import '../domain/usecases/configs/get_configs_usecase.dart' as _i132;
import '../domain/usecases/configs/listen_to_configs_usecase.dart' as _i608;
import '../domain/usecases/configs/save_config_usecase.dart' as _i833;
import '../domain/usecases/configs/update_config_usecase.dart' as _i436;
import '../domain/usecases/exchange_rate/listen_to_exchange_rate.dart' as _i397;
import '../domain/usecases/exchange_rate/update_default_currency_usecase.dart'
    as _i798;
import '../domain/usecases/group/add_group_usecase.dart' as _i353;
import '../domain/usecases/group/delete_group_usecase.dart' as _i759;
import '../domain/usecases/group/get_groups_usecase.dart' as _i982;
import '../domain/usecases/group/listen_to_groups_usecase.dart' as _i146;
import '../domain/usecases/group/update_group_usecase.dart' as _i820;
import '../domain/usecases/notification/get_notifications_usecase.dart'
    as _i422;
import '../domain/usecases/notification/listen_to_notifications_usecase.dart'
    as _i320;
import '../domain/usecases/notification/mark_notification_as_read_usecase.dart'
    as _i837;
import '../domain/usecases/party/add_party_usecase.dart' as _i84;
import '../domain/usecases/party/delete_party_usecase.dart' as _i56;
import '../domain/usecases/party/get_parties_usecase.dart' as _i12;
import '../domain/usecases/party/listen_to_parties_usecase.dart' as _i714;
import '../domain/usecases/party/update_party_usecase.dart' as _i911;
import '../domain/usecases/subscription/fetch_subscription_usecase.dart'
    as _i314;
import '../domain/usecases/sync/check_pending_changes_usecase.dart' as _i662;
import '../domain/usecases/transaction/add_media_to_transaction_usecase.dart'
    as _i843;
import '../domain/usecases/transaction/create_transaction_usecase.dart'
    as _i669;
import '../domain/usecases/transaction/delete_media_usecase.dart' as _i706;
import '../domain/usecases/transaction/delete_transaction_usecase.dart'
    as _i163;
import '../domain/usecases/transaction/get_all_transactions_usecase.dart'
    as _i947;
import '../domain/usecases/transaction/get_file_content_usecase.dart' as _i150;
import '../domain/usecases/transaction/get_media_for_transaction_usecase.dart'
    as _i1026;
import '../domain/usecases/transaction/listen_to_transactions_usecase.dart'
    as _i973;
import '../domain/usecases/transaction/update_transaction_usecase.dart'
    as _i241;
import '../domain/usecases/transaction/usecase.dart' as _i1022;
import '../domain/usecases/wallet/add_wallet_usecase.dart' as _i80;
import '../domain/usecases/wallet/delete_wallet_usecase.dart' as _i62;
import '../domain/usecases/wallet/ensure_default_wallet_exists_usecase.dart'
    as _i225;
import '../domain/usecases/wallet/get_wallets_usecase.dart' as _i713;
import '../domain/usecases/wallet/listen_to_wallets_usecase.dart' as _i82;
import '../domain/usecases/wallet/update_wallet_usecase.dart' as _i418;
import '../presentation/app_update/cubit/app_update_cubit.dart' as _i559;
import '../presentation/app_update/cubit/in_app_update_cubit.dart' as _i288;
import '../presentation/app_update/in_app_update_cubit.dart' as _i78;
import '../presentation/auth/cubits/auth/auth_cubit.dart' as _i872;
import '../presentation/auth/cubits/login/login_cubit.dart' as _i15;
import '../presentation/auth/cubits/oauth/oauth_cubit.dart' as _i91;
import '../presentation/auth/cubits/register/register_cubit.dart' as _i831;
import '../presentation/benefits/cubit/benefits_cubit.dart' as _i88;
import '../presentation/category/cubit/category_cubit.dart' as _i455;
import '../presentation/config/cubit/config_cubit.dart' as _i408;
import '../presentation/config/theme_cubit/theme_cubit.dart' as _i627;
import '../presentation/currency/cubit/currency_cubit.dart' as _i484;
import '../presentation/exchange_rate/cubit/exchange_rate_cubit.dart' as _i311;
import '../presentation/groups/cubit/group_cubit.dart' as _i676;
import '../presentation/notifications/cubit/notification_cubit.dart' as _i1056;
import '../presentation/parties/cubit/party_cubit.dart' as _i841;
import '../presentation/plans/cubit/plans_cubit.dart' as _i977;
import '../presentation/statistics/cubit/statistics_filter_cubit.dart' as _i1069;
import '../presentation/transactions/cubit/transaction_cubit.dart' as _i117;
import '../presentation/utils/sync_cubit.dart' as _i1041;
import '../presentation/wallets/cubit/wallet_cubit.dart' as _i1068;

const String _dev = 'dev';
const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final syncModule = _$SyncModule();
  final injectHttpClientModule = _$InjectHttpClientModule();
  gh.factory<_i624.OAuthService>(() => _i624.OAuthService());
  gh.factory<_i1041.SyncCubit>(() => _i1041.SyncCubit());
  gh.singleton<_i957.SyncService>(() => _i957.SyncService());
  gh.singleton<_i196.FeatureRemoteConfig>(() => _i196.FeatureRemoteConfig());
  gh.lazySingleton<_i877.SyncDependencyManagerBase>(
      () => syncModule.provideSyncDependencyManager());
  gh.lazySingleton<_i627.ThemeCubit>(() => _i627.ThemeCubit());
  gh.factory<_i6.NetworkInfo>(() => _i6.NetworkInfoImpl()..init());
  gh.factory<_i91.OAuthCubit>(() => _i91.OAuthCubit(gh<_i624.OAuthService>()));
  gh.singleton<_i1063.AppVersionInfo>(() => _i1063.AppVersionInfoImpl());
  gh.factory<_i632.ExchangeRateRemoteDataSource>(
      () => _i632.ExchangeRateRemoteDataSourceImpl());
  gh.singleton<_i789.SharedPrefs>(() => _i789.SharedPrefsImpl());
  gh.factory<_i483.TokenManager>(() => _i483.TokenManagerImpl());
  gh.singleton<_i493.RemoteUpdateCheck>(() => _i493.RemoteUpdateCheckImpl());
  gh.factory<_i377.AuthService>(
      () => _i377.AuthService(gh<_i483.TokenManager>()));
  gh.singleton<_i47.InAppUpdateService>(
    () => _i0.FakeInAppUpdateService(),
    registerFor: {_dev},
  );
  gh.factory<_i414.CrashReportingInterface>(
      () => _i529.FirebaseCrashlyticsService());
  gh.singleton<_i683.PreferenceManager>(
      () => _i683.PreferenceManagerImpl()..init());
  gh.factory<_i662.CheckPendingChangesUsecase>(
      () => _i662.CheckPendingChangesUsecase(gh<_i704.AppDatabase>()));
  gh.factory<String>(
    () => injectHttpClientModule.devHttpUrl,
    instanceName: 'HttpUrl',
    registerFor: {_dev},
  );
  gh.factory<_i655.PartyLocalDataSource>(
      () => _i655.PartyLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i937.NotificationLocalDataSource>(
      () => _i937.NotificationLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i78.InAppUpdateCubit>(
      () => _i78.InAppUpdateCubit(gh<_i47.InAppUpdateService>()));
  gh.factory<_i288.InAppUpdateCubit>(
      () => _i288.InAppUpdateCubit(gh<_i47.InAppUpdateService>()));
  gh.factory<_i276.AuthLocalDataSource>(
      () => _i276.AuthLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i216.MediaFileLocalDataSource>(
      () => _i216.MediaFileLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i873.GroupLocalDataSource>(
      () => _i873.GroupLocalDataSourceImpl(database: gh<_i704.AppDatabase>()));
  gh.factory<_i849.WalletLocalDataSource>(
      () => _i849.WalletLocalDataSourceImpl(database: gh<_i704.AppDatabase>()));
  gh.factory<_i514.ConfigLocalDataSource>(
      () => _i514.ConfigLocalDataSourceImpl(database: gh<_i704.AppDatabase>()));
  gh.factory<_i148.CategoryLocalDataSource>(
      () => _i148.CategoryLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.lazySingleton<_i361.Dio>(
      () => injectHttpClientModule.dio(gh<String>(instanceName: 'HttpUrl')));
  gh.factory<String>(
    () => injectHttpClientModule.prodHttpUrl,
    instanceName: 'HttpUrl',
    registerFor: {_prod},
  );
  gh.factory<_i558.CategoryRemoteDataSource>(
      () => _i558.CategoryRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i656.PartyRemoteDataSource>(
      () => _i656.PartyRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i854.GetAppUpdateConfigUseCase>(
      () => _i854.GetAppUpdateConfigUseCase(gh<_i196.FeatureRemoteConfig>()));
  gh.lazySingleton<_i463.CategorySyncHandler>(() => _i463.CategorySyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i558.CategoryRemoteDataSource>(),
      ));
  gh.factory<_i513.NotificationRemoteDataSource>(
      () => _i513.NotificationRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i877.RequestAuthorizationService>(
      () => _i1066.RequestAuthorizationServiceImpl(gh<_i377.AuthService>()));
  gh.factory<_i61.CloudBenefitRemoteDataSource>(
      () => _i61.CloudBenefitRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.factory<_i496.AuthRemoteDataSource>(
      () => _i496.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.factory<_i538.CrashReportingService>(
      () => _i538.CrashReportingService(gh<_i414.CrashReportingInterface>()));
  gh.factory<_i682.SubscriptionRemoteDataSource>(
      () => _i682.SubscriptionRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.factory<_i900.ExchangeRateLocalDataSource>(() =>
      _i900.ExchangeRateLocalDataSourceImpl(gh<_i683.PreferenceManager>()));
  gh.lazySingleton<_i410.CategoryRepository>(() => _i324.CategoryRepositoryImpl(
        syncHandler: gh<_i463.CategorySyncHandler>(),
        localDataSource: gh<_i148.CategoryLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i150.CheckAppUpdateUseCase>(() => _i150.CheckAppUpdateUseCase(
        gh<_i1063.AppVersionInfo>(),
        gh<_i854.GetAppUpdateConfigUseCase>(),
        gh<_i683.PreferenceManager>(),
        gh<_i47.InAppUpdateService>(),
        gh<_i493.RemoteUpdateCheck>(),
      ));
  gh.lazySingleton<_i280.PartySyncHandler>(() => _i280.PartySyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i656.PartyRemoteDataSource>(),
      ));
  gh.factory<_i624.WalletRemoteDataSource>(
      () => _i624.WalletRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i705.DriftSyncCrashReportingAdapter>(() =>
      _i705.DriftSyncCrashReportingAdapter(gh<_i538.CrashReportingService>()));
  gh.factory<_i559.AppUpdateCubit>(
      () => _i559.AppUpdateCubit(gh<_i150.CheckAppUpdateUseCase>()));
  gh.factory<_i481.UserContextService>(
      () => _i481.UserContextService(gh<_i538.CrashReportingService>()));
  gh.factory<_i545.DriftSyncCrashReportingService>(() =>
      _i545.DriftSyncCrashReportingService(
          gh<_i705.DriftSyncCrashReportingAdapter>()));
  gh.factory<_i662.TransactionLocalDataSource>(
      () => _i662.TransactionLocalDataSourceImpl(
            gh<_i704.AppDatabase>(),
            gh<_i216.MediaFileLocalDataSource>(),
          ));
  gh.factory<_i587.ConfigRemoteDataSource>(
      () => _i587.ConfigRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i79.TransactionRemoteDataSource>(
      () => _i79.TransactionRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i217.NotificationSyncHandler>(
      () => _i217.NotificationSyncHandler(
            gh<_i704.AppDatabase>(),
            gh<_i513.NotificationRemoteDataSource>(),
          ));
  gh.factory<_i478.GroupRemoteDataSource>(
      () => _i478.GroupRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i961.GetCategoriesUseCase>(
      () => _i961.GetCategoriesUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i986.UpdateCategoryUseCase>(
      () => _i986.UpdateCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i445.AddCategoryUseCase>(
      () => _i445.AddCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i292.DeleteCategoryUseCase>(
      () => _i292.DeleteCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.singleton<_i11.CloudBenefitRepository>(() =>
      _i415.CloudBenefitRepositoryImpl(
          gh<_i61.CloudBenefitRemoteDataSource>()));
  gh.factory<_i237.MediaFileRemoteDataSource>(
      () => _i237.MediaFileRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i480.ConfigSyncHandler>(() => _i480.ConfigSyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i587.ConfigRemoteDataSource>(),
      ));
  gh.factory<_i500.ListenToCategoriesUseCase>(
      () => _i500.ListenToCategoriesUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i849.WalletSyncHandler>(() => _i849.WalletSyncHandler(
        remoteDataSource: gh<_i624.WalletRemoteDataSource>(),
        db: gh<_i704.AppDatabase>(),
      ));
  gh.factory<_i61.FetchBenefits>(
      () => _i61.FetchBenefits(gh<_i11.CloudBenefitRepository>()));
  gh.singleton<_i47.InAppUpdateService>(
    () => _i47.InAppUpdateServiceImpl(gh<_i538.CrashReportingService>()),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i893.TransactionSyncHandler>(
      () => _i893.TransactionSyncHandler(
            gh<_i704.AppDatabase>(),
            gh<_i79.TransactionRemoteDataSource>(),
          ));
  gh.lazySingleton<_i661.PartyRepository>(() => _i168.PartyRepositoryImpl(
        syncHandler: gh<_i280.PartySyncHandler>(),
        localDataSource: gh<_i655.PartyLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.singleton<_i804.SubscriptionRepository>(() =>
      _i1047.SubscriptionRepositoryImpl(
          gh<_i682.SubscriptionRemoteDataSource>()));
  gh.lazySingleton<_i235.GroupSyncHandler>(() => _i235.GroupSyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i478.GroupRemoteDataSource>(),
      ));
  gh.lazySingleton<_i899.ConfigRepository>(() => _i379.ConfigRepositoryImpl(
        syncHandler: gh<_i480.ConfigSyncHandler>(),
        localDataSource: gh<_i514.ConfigLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.singleton<_i800.AuthRepository>(() => _i135.AuthRepositoryImpl(
        remoteDataSource: gh<_i496.AuthRemoteDataSource>(),
        localDataSource: gh<_i276.AuthLocalDataSource>(),
        networkInfo: gh<_i6.NetworkInfo>(),
        tokenManager: gh<_i483.TokenManager>(),
        preferenceManager: gh<_i683.PreferenceManager>(),
        configRemoteDataSource: gh<_i587.ConfigRemoteDataSource>(),
        configSyncHandler: gh<_i480.ConfigSyncHandler>(),
        groupSyncHandler: gh<_i235.GroupSyncHandler>(),
        walletSyncHandler: gh<_i849.WalletSyncHandler>(),
        database: gh<_i704.AppDatabase>(),
      ));
  gh.factory<_i455.CategoryCubit>(() => _i455.CategoryCubit(
        gh<_i445.AddCategoryUseCase>(),
        gh<_i986.UpdateCategoryUseCase>(),
        gh<_i292.DeleteCategoryUseCase>(),
        gh<_i961.GetCategoriesUseCase>(),
        gh<_i500.ListenToCategoriesUseCase>(),
      ));
  gh.factory<_i723.LoginWithPhonePassword>(
      () => _i723.LoginWithPhonePassword(gh<_i800.AuthRepository>()));
  gh.factory<_i2.OnboardingCompleted>(
      () => _i2.OnboardingCompleted(gh<_i800.AuthRepository>()));
  gh.factory<_i498.LoginByPhoneUsecase>(
      () => _i498.LoginByPhoneUsecase(gh<_i800.AuthRepository>()));
  gh.factory<_i880.GetLoggedInUser>(
      () => _i880.GetLoggedInUser(gh<_i800.AuthRepository>()));
  gh.factory<_i768.LoginWithEmailPassword>(
      () => _i768.LoginWithEmailPassword(gh<_i800.AuthRepository>()));
  gh.factory<_i42.LoginByEmailUsecase>(
      () => _i42.LoginByEmailUsecase(gh<_i800.AuthRepository>()));
  gh.factory<_i444.StreamAuthStatus>(
      () => _i444.StreamAuthStatus(gh<_i800.AuthRepository>()));
  gh.factory<_i828.IsOnboardingCompleted>(
      () => _i828.IsOnboardingCompleted(gh<_i800.AuthRepository>()));
  gh.lazySingleton<_i118.TransactionRepository>(() =>
      _i114.TransactionRepositoryImpl(
        syncHandler: gh<_i893.TransactionSyncHandler>(),
        localDataSource: gh<_i662.TransactionLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i56.DeletePartyUseCase>(
      () => _i56.DeletePartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i84.AddPartyUseCase>(
      () => _i84.AddPartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i911.UpdatePartyUseCase>(
      () => _i911.UpdatePartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i12.GetPartiesUseCase>(
      () => _i12.GetPartiesUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i714.ListenToPartiesUseCase>(
      () => _i714.ListenToPartiesUseCase(gh<_i661.PartyRepository>()));
  gh.lazySingleton<_i965.NotificationRepository>(() =>
      _i888.NotificationRepositoryImpl(
        syncHandler: gh<_i217.NotificationSyncHandler>(),
        localDataSource: gh<_i937.NotificationLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i88.BenefitsCubit>(
      () => _i88.BenefitsCubit(gh<_i61.FetchBenefits>()));
  gh.factory<_i640.LogoutUsecase>(
      () => _i640.LogoutUsecase(gh<_i800.AuthRepository>()));
  gh.lazySingleton<_i368.WalletRepository>(() => _i305.WalletRepositoryImpl(
        syncHandler: gh<_i849.WalletSyncHandler>(),
        localDataSource: gh<_i849.WalletLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i163.DeleteTransactionUseCase>(
      () => _i163.DeleteTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i973.ListenToTransactionsUseCase>(() =>
      _i973.ListenToTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i241.UpdateTransactionUseCase>(
      () => _i241.UpdateTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i947.GetAllTransactionsUseCase>(
      () => _i947.GetAllTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i422.GetNotificationsUseCase>(
      () => _i422.GetNotificationsUseCase(gh<_i965.NotificationRepository>()));
  gh.factory<_i837.MarkNotificationAsReadUseCase>(() =>
      _i837.MarkNotificationAsReadUseCase(gh<_i965.NotificationRepository>()));
  gh.lazySingleton<_i957.GroupRepository>(() => _i875.GroupRepositoryImpl(
        syncHandler: gh<_i235.GroupSyncHandler>(),
        localDataSource: gh<_i873.GroupLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i80.AddWalletUseCase>(
      () => _i80.AddWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i418.UpdateWalletUseCase>(
      () => _i418.UpdateWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i62.DeleteWalletUseCase>(
      () => _i62.DeleteWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i713.GetWalletsUseCase>(
      () => _i713.GetWalletsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i314.FetchSubscriptionPlans>(
      () => _i314.FetchSubscriptionPlans(gh<_i804.SubscriptionRepository>()));
  gh.lazySingleton<_i382.MediaSyncHandler>(() => _i382.MediaSyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i237.MediaFileRemoteDataSource>(),
        gh<_i79.TransactionRemoteDataSource>(),
        gh<_i893.TransactionSyncHandler>(),
      ));
  gh.factory<_i132.GetConfigsUseCase>(
      () => _i132.GetConfigsUseCase(gh<_i899.ConfigRepository>()));
  gh.factory<_i608.ListenToConfigsUseCase>(
      () => _i608.ListenToConfigsUseCase(gh<_i899.ConfigRepository>()));
  gh.factory<_i933.GetConfigUseCase>(
      () => _i933.GetConfigUseCase(gh<_i899.ConfigRepository>()));
  gh.factory<_i833.SaveConfigUseCase>(
      () => _i833.SaveConfigUseCase(gh<_i899.ConfigRepository>()));
  gh.factory<_i436.UpdateConfigUseCase>(
      () => _i436.UpdateConfigUseCase(gh<_i899.ConfigRepository>()));
  gh.factory<_i536.DeleteConfigUseCase>(
      () => _i536.DeleteConfigUseCase(gh<_i899.ConfigRepository>()));
  gh.singleton<_i1057.ExchangeRateRepository>(
      () => _i827.ExchangeRateRepositoryImpl(
            remoteDataSource: gh<_i632.ExchangeRateRemoteDataSource>(),
            localDataSource: gh<_i900.ExchangeRateLocalDataSource>(),
            configRepository: gh<_i899.ConfigRepository>(),
          ));
  gh.factory<_i225.EnsureDefaultWalletExistsUseCase>(() =>
      _i225.EnsureDefaultWalletExistsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i82.ListenToWalletsUseCase>(
      () => _i82.ListenToWalletsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i524.LoginWithEmailUseCase>(
      () => _i524.LoginWithEmailUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i705.RegisterUseCase>(
      () => _i705.RegisterUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i402.GetOtpCodeUseCase>(
      () => _i402.GetOtpCodeUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i400.LoginWithPhoneUseCase>(
      () => _i400.LoginWithPhoneUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i542.PasswordResetCodeUseCase>(
      () => _i542.PasswordResetCodeUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i494.PasswordResetUseCase>(
      () => _i494.PasswordResetUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i100.VerifyEmailUseCase>(
      () => _i100.VerifyEmailUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i841.PartyCubit>(() => _i841.PartyCubit(
        getPartiesUseCase: gh<_i12.GetPartiesUseCase>(),
        addPartyUseCase: gh<_i84.AddPartyUseCase>(),
        updatePartyUseCase: gh<_i911.UpdatePartyUseCase>(),
        deletePartyUseCase: gh<_i56.DeletePartyUseCase>(),
        listenToPartiesUseCase: gh<_i714.ListenToPartiesUseCase>(),
      ));
  gh.factory<_i15.LoginCubit>(() => _i15.LoginCubit(
        gh<_i768.LoginWithEmailPassword>(),
        gh<_i723.LoginWithPhonePassword>(),
        gh<_i542.PasswordResetCodeUseCase>(),
        gh<_i494.PasswordResetUseCase>(),
      ));
  gh.factory<_i831.RegisterCubit>(() => _i831.RegisterCubit(
        gh<_i705.RegisterUseCase>(),
        gh<_i402.GetOtpCodeUseCase>(),
        gh<_i100.VerifyEmailUseCase>(),
      ));
  gh.factory<_i320.ListenToNotificationsUseCase>(() =>
      _i320.ListenToNotificationsUseCase(gh<_i965.NotificationRepository>()));
  gh.lazySingleton<_i442.MediaRepository>(() => _i74.MediaRepositoryImpl(
        syncHandler: gh<_i382.MediaSyncHandler>(),
        localDataSource: gh<_i216.MediaFileLocalDataSource>(),
        remoteDataSource: gh<_i237.MediaFileRemoteDataSource>(),
        db: gh<_i704.AppDatabase>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i1068.WalletCubit>(() => _i1068.WalletCubit(
        getWalletsUseCase: gh<_i713.GetWalletsUseCase>(),
        addWalletUseCase: gh<_i80.AddWalletUseCase>(),
        updateWalletUseCase: gh<_i418.UpdateWalletUseCase>(),
        deleteWalletUseCase: gh<_i62.DeleteWalletUseCase>(),
        listenToWalletsUseCase: gh<_i82.ListenToWalletsUseCase>(),
        saveConfigUseCase: gh<_i833.SaveConfigUseCase>(),
        ensureDefaultWalletExistsUseCase:
            gh<_i225.EnsureDefaultWalletExistsUseCase>(),
      ));
  gh.factory<_i872.AuthCubit>(() => _i872.AuthCubit(
        gh<_i444.StreamAuthStatus>(),
        gh<_i880.GetLoggedInUser>(),
        gh<_i640.LogoutUsecase>(),
        gh<_i481.UserContextService>(),
      ));
  gh.factory<_i397.ListenExchangeRate>(
      () => _i397.ListenExchangeRate(gh<_i1057.ExchangeRateRepository>()));
  gh.factory<_i759.DeleteGroupUseCase>(
      () => _i759.DeleteGroupUseCase(gh<_i957.GroupRepository>()));
  gh.factory<_i982.GetGroupsUseCase>(
      () => _i982.GetGroupsUseCase(gh<_i957.GroupRepository>()));
  gh.factory<_i146.ListenToGroupsUseCase>(
      () => _i146.ListenToGroupsUseCase(gh<_i957.GroupRepository>()));
  gh.factory<_i353.AddGroupUseCase>(
      () => _i353.AddGroupUseCase(gh<_i957.GroupRepository>()));
  gh.factory<_i820.UpdateGroupUseCase>(
      () => _i820.UpdateGroupUseCase(gh<_i957.GroupRepository>()));
  gh.lazySingleton<Set<_i877.SyncTypeHandler<dynamic, dynamic, dynamic>>>(
      () => syncModule.provideSyncTypeHandlers(
            gh<_i463.CategorySyncHandler>(),
            gh<_i480.ConfigSyncHandler>(),
            gh<_i849.WalletSyncHandler>(),
            gh<_i280.PartySyncHandler>(),
            gh<_i235.GroupSyncHandler>(),
            gh<_i217.NotificationSyncHandler>(),
            gh<_i893.TransactionSyncHandler>(),
            gh<_i382.MediaSyncHandler>(),
          ));
  gh.factory<_i408.ConfigCubit>(() => _i408.ConfigCubit(
        gh<_i132.GetConfigsUseCase>(),
        gh<_i933.GetConfigUseCase>(),
        gh<_i833.SaveConfigUseCase>(),
        gh<_i436.UpdateConfigUseCase>(),
        gh<_i536.DeleteConfigUseCase>(),
        gh<_i608.ListenToConfigsUseCase>(),
      ));
  gh.factory<_i1056.NotificationCubit>(() => _i1056.NotificationCubit(
        gh<_i422.GetNotificationsUseCase>(),
        gh<_i837.MarkNotificationAsReadUseCase>(),
        gh<_i320.ListenToNotificationsUseCase>(),
      ));
  gh.factory<_i977.PlansCubit>(
      () => _i977.PlansCubit(gh<_i314.FetchSubscriptionPlans>()));
  gh.factory<_i1069.StatisticsFilterCubit>(() => _i1069.StatisticsFilterCubit());
  gh.factory<_i798.UpdateDefaultCurrencyUseCase>(() =>
      _i798.UpdateDefaultCurrencyUseCase(gh<_i1057.ExchangeRateRepository>()));
  gh.factory<_i676.GroupCubit>(() => _i676.GroupCubit(
        gh<_i982.GetGroupsUseCase>(),
        gh<_i353.AddGroupUseCase>(),
        gh<_i820.UpdateGroupUseCase>(),
        gh<_i759.DeleteGroupUseCase>(),
        gh<_i146.ListenToGroupsUseCase>(),
        gh<_i833.SaveConfigUseCase>(),
      ));
  gh.factory<_i669.CreateTransactionUseCase>(
      () => _i669.CreateTransactionUseCase(
            gh<_i118.TransactionRepository>(),
            gh<_i1057.ExchangeRateRepository>(),
          ));
  gh.lazySingleton<_i646.SynchAppDatabase>(() => _i646.SynchAppDatabase(
        appDatabase: gh<_i704.AppDatabase>(),
        typeHandlers:
            gh<Set<_i877.SyncTypeHandler<dynamic, dynamic, dynamic>>>(),
        dependencyManager: gh<_i877.SyncDependencyManagerBase>(),
        dio: gh<_i361.Dio>(),
        networkInfo: gh<_i6.NetworkInfo>(),
        requestAuthorizationService: gh<_i877.RequestAuthorizationService>(),
      ));
  gh.factory<_i150.GetFileContentUseCase>(
      () => _i150.GetFileContentUseCase(gh<_i442.MediaRepository>()));
  gh.factory<_i706.DeleteMediaUseCase>(
      () => _i706.DeleteMediaUseCase(gh<_i442.MediaRepository>()));
  gh.factory<_i1026.GetMediaForTransactionUseCase>(
      () => _i1026.GetMediaForTransactionUseCase(gh<_i442.MediaRepository>()));
  gh.factory<_i843.AddMediaToTransactionUseCase>(
      () => _i843.AddMediaToTransactionUseCase(gh<_i442.MediaRepository>()));
  gh.factory<_i484.CurrencyCubit>(() => _i484.CurrencyCubit(
        gh<_i933.GetConfigUseCase>(),
        gh<_i833.SaveConfigUseCase>(),
        gh<_i608.ListenToConfigsUseCase>(),
        gh<_i798.UpdateDefaultCurrencyUseCase>(),
      ));
  gh.factory<_i311.ExchangeRateCubit>(
      () => _i311.ExchangeRateCubit(gh<_i397.ListenExchangeRate>()));
  gh.factory<_i117.TransactionCubit>(() => _i117.TransactionCubit(
        getAllTransactionsUseCase: gh<_i1022.GetAllTransactionsUseCase>(),
        createTransactionUseCase: gh<_i1022.CreateTransactionUseCase>(),
        addMediaToTransactionUseCase: gh<_i843.AddMediaToTransactionUseCase>(),
        deleteMediaUseCase: gh<_i706.DeleteMediaUseCase>(),
        getMediaForTransactionUseCase:
            gh<_i1026.GetMediaForTransactionUseCase>(),
        getFileContentUseCase: gh<_i150.GetFileContentUseCase>(),
        updateTransactionUseCase: gh<_i1022.UpdateTransactionUseCase>(),
        deleteTransactionUseCase: gh<_i1022.DeleteTransactionUseCase>(),
        listenToTransactionsUseCase: gh<_i1022.ListenToTransactionsUseCase>(),
        getWalletsUseCase: gh<_i713.GetWalletsUseCase>(),
      ));
  return getIt;
}

class _$SyncModule extends _i680.SyncModule {}

class _$InjectHttpClientModule extends _i488.InjectHttpClientModule {}
