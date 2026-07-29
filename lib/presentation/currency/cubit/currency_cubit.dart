import 'dart:async';
import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/domain/usecases/configs/get_config_usecase.dart';
import 'package:trakli/domain/usecases/configs/listen_to_configs_usecase.dart';
import 'package:trakli/domain/usecases/configs/save_config_usecase.dart';
import 'package:trakli/domain/usecases/exchange_rate/update_default_currency_usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';

part 'currency_state.dart';
part 'currency_cubit.freezed.dart';

@injectable
class CurrencyCubit extends Cubit<CurrencyState> {
  final GetConfigUseCase _getConfigUseCase;
  final SaveConfigUseCase _saveConfigUseCase;
  final ListenToConfigsUseCase _listenToConfigsUseCase;
  final UpdateDefaultCurrencyUseCase _updateDefaultCurrencyUseCase;
  StreamSubscription? _subscription;

  CurrencyCubit(
    this._getConfigUseCase,
    this._saveConfigUseCase,
    this._listenToConfigsUseCase,
    this._updateDefaultCurrencyUseCase,
  ) : super(const CurrencyState.initial()) {
    _listenToCurrency();
  }

  void _listenToCurrency() {
    _subscription?.cancel();
    _subscription = _listenToConfigsUseCase(NoParams()).listen(
      (result) => result.fold(
        (failure) => emit(CurrencyState.error(failure)),
        (configs) {
          final currencyConfig = configs.firstWhereOrNull(
            (config) => config.key == ConfigConstants.defaultCurrency,
          );
          if (currencyConfig != null && currencyConfig.value != null) {
            final currencyCode = currencyConfig.value as String;
            final currency = _getCurrencyFromCode(currencyCode);
            if (currency != null) {
              emit(CurrencyState.loaded(currency));
            } else {
              emit(const CurrencyState.initial());
            }
          } else {
            emit(const CurrencyState.initial());
          }
        },
      ),
    );
  }

  Currency? _getCurrencyFromCode(String code) {
    try {
      final allCurrencies = CurrencyService().getAll();
      return allCurrencies.firstWhereOrNull(
        (c) => c.code == code,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> loadCurrency() async {
    emit(const CurrencyState.loading());
    final result = await _getConfigUseCase(
      GetConfigUseCaseParams(key: ConfigConstants.defaultCurrency),
    );
    result.fold(
      (failure) => emit(CurrencyState.error(failure)),
      (config) {
        if (config.value != null) {
          final currencyCode = config.value as String;
          final currency = _getCurrencyFromCode(currencyCode);
          if (currency != null) {
            emit(CurrencyState.loaded(currency));
          } else {
            emit(const CurrencyState.initial());
          }
        } else {
          emit(const CurrencyState.initial());
        }
      },
    );
  }

  Future<void> setCurrency(Currency currency) async {
    emit(const CurrencyState.loading());

    final existingResult = await _getConfigUseCase(
      GetConfigUseCaseParams(key: ConfigConstants.defaultCurrency),
    );
    final existingCode = existingResult.fold(
      (_) => null,
      (config) => config.value as String?,
    );
    final isFirstSelection = existingCode == null || existingCode.isEmpty;
    final isSameCurrency = existingCode == currency.code;

    // Switching requires rates for the new base; on failure nothing
    // changes. First selection is exempt so onboarding never blocks.
    if (!isFirstSelection && !isSameCurrency) {
      final targetRate = await _updateDefaultCurrencyUseCase(
        UpdateDefaultCurrencyParams(currencyCode: currency.code),
      );
      if (targetRate.isLeft()) {
        emit(CurrencyState.error(Failure.validationError(
          LocaleKeys.currencySwitchRatesUnavailable.tr(),
          errors: const [],
        )));
        return;
      }
    }

    final saveResult = await _saveConfigUseCase(
      SaveConfigUseCaseParams(
        key: ConfigConstants.defaultCurrency,
        type: ConfigType.string,
        value: currency.code,
      ),
    );
    await saveResult.fold(
      (failure) async => emit(CurrencyState.error(failure)),
      (_) async {
        if (isFirstSelection || isSameCurrency) {
          // Best-effort refresh only.
          final updateResult = await _updateDefaultCurrencyUseCase(
            UpdateDefaultCurrencyParams(currencyCode: currency.code),
          );
          updateResult.fold(
            (failure) => logger.w(
                '[currency] rate refresh failed after currency change: '
                '${failure.customMessage}'),
            (_) {},
          );
        }
        emit(CurrencyState.loaded(currency));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
