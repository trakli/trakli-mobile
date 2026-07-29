import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/usecases/configs/get_config_usecase.dart';
import 'package:trakli/domain/usecases/configs/listen_to_configs_usecase.dart';
import 'package:trakli/domain/usecases/configs/save_config_usecase.dart';
import 'package:trakli/domain/usecases/exchange_rate/update_default_currency_usecase.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';

class _MockGetConfig extends Mock implements GetConfigUseCase {}

class _MockSaveConfig extends Mock implements SaveConfigUseCase {}

class _MockListenConfigs extends Mock implements ListenToConfigsUseCase {}

class _MockUpdateDefaultCurrency extends Mock
    implements UpdateDefaultCurrencyUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  late _MockGetConfig getConfig;
  late _MockSaveConfig saveConfig;
  late _MockListenConfigs listenConfigs;
  late _MockUpdateDefaultCurrency updateDefaultCurrency;

  final gbp = CurrencyService().findByCode('GBP')!;

  ConfigEntity currencyConfig(String code) => ConfigEntity(
        id: 1,
        userId: 1,
        key: ConfigConstants.defaultCurrency,
        type: ConfigType.string,
        value: code,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  final rateEntity = ExchangeRateEntity(
    provider: 'trakli',
    baseCode: 'GBP',
    rates: const {'GBP': 1.0},
    timeLastUpdated: DateTime(2026),
    timeNextUpdated: DateTime(2027),
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
        GetConfigUseCaseParams(key: ConfigConstants.defaultCurrency));
    registerFallbackValue(SaveConfigUseCaseParams(
      key: ConfigConstants.defaultCurrency,
      type: ConfigType.string,
      value: 'GBP',
    ));
    registerFallbackValue(
        const UpdateDefaultCurrencyParams(currencyCode: 'GBP'));
  });

  setUp(() {
    getConfig = _MockGetConfig();
    saveConfig = _MockSaveConfig();
    listenConfigs = _MockListenConfigs();
    updateDefaultCurrency = _MockUpdateDefaultCurrency();

    when(() => listenConfigs(any()))
        .thenAnswer((_) => const Stream.empty());
    when(() => saveConfig(any()))
        .thenAnswer((_) async => right(currencyConfig('GBP')));
  });

  CurrencyCubit build() => CurrencyCubit(
        getConfig,
        saveConfig,
        listenConfigs,
        updateDefaultCurrency,
      );

  test('blocks the switch and keeps the currency when no rate is available',
      () async {
    when(() => getConfig(any()))
        .thenAnswer((_) async => right(currencyConfig('XAF')));
    when(() => updateDefaultCurrency(any()))
        .thenAnswer((_) async => left(const Failure.notFound()));

    final cubit = build();
    await cubit.setCurrency(gbp);

    expect(
      cubit.state.whenOrNull(error: (f) => f.customMessage),
      isNotNull,
    );
    verifyNever(() => saveConfig(any()));
  });

  test('switches when a rate is available', () async {
    when(() => getConfig(any()))
        .thenAnswer((_) async => right(currencyConfig('XAF')));
    when(() => updateDefaultCurrency(any()))
        .thenAnswer((_) async => right(rateEntity));

    final cubit = build();
    await cubit.setCurrency(gbp);

    expect(cubit.state, CurrencyState.loaded(gbp));
    verify(() => saveConfig(any())).called(1);
  });

  test('first selection saves even when the rate fetch fails', () async {
    when(() => getConfig(any()))
        .thenAnswer((_) async => left(const Failure.notFound()));
    when(() => updateDefaultCurrency(any()))
        .thenAnswer((_) async => left(const Failure.notFound()));

    final cubit = build();
    await cubit.setCurrency(gbp);

    expect(cubit.state, CurrencyState.loaded(gbp));
    verify(() => saveConfig(any())).called(1);
  });

  test('re-selecting the same currency never gates', () async {
    when(() => getConfig(any()))
        .thenAnswer((_) async => right(currencyConfig('GBP')));
    when(() => updateDefaultCurrency(any()))
        .thenAnswer((_) async => left(const Failure.notFound()));

    final cubit = build();
    await cubit.setCurrency(gbp);

    expect(cubit.state, CurrencyState.loaded(gbp));
    verify(() => saveConfig(any())).called(1);
  });
}
