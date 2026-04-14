import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/usecases/configs/delete_config_usecase.dart';
import 'package:trakli/domain/usecases/configs/get_config_usecase.dart';
import 'package:trakli/domain/usecases/configs/get_configs_usecase.dart';
import 'package:trakli/domain/usecases/configs/listen_to_configs_usecase.dart';
import 'package:trakli/domain/usecases/configs/save_config_usecase.dart';
import 'package:trakli/domain/usecases/configs/update_config_usecase.dart';

part 'config_cubit.freezed.dart';
part 'config_state.dart';

@injectable
class ConfigCubit extends Cubit<ConfigState> {
  final GetConfigsUseCase _getConfigsUseCase;
  final GetConfigUseCase _getConfigUseCase;
  final SaveConfigUseCase _saveConfigUseCase;
  final UpdateConfigUseCase _updateConfigUseCase;
  final DeleteConfigUseCase _deleteConfigUseCase;
  final ListenToConfigsUseCase _listenToConfigsUseCase;
  StreamSubscription? _subscription;

  ConfigCubit(
    this._getConfigsUseCase,
    this._getConfigUseCase,
    this._saveConfigUseCase,
    this._updateConfigUseCase,
    this._deleteConfigUseCase,
    this._listenToConfigsUseCase,
  ) : super(ConfigState.initial()) {
    _listenToConfigs();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(
      appVersion: "${packageInfo.version}+${packageInfo.buildNumber}",
    ));
  }

  void handleDebugTap() {
    if (state.debugTapCount != null) {
      final newTapCount = state.debugTapCount! + 1;
      if (newTapCount >= 7) {
        emit(state.copyWith(
          showDebug: true,
          debugTapCount: 0,
        ));
      } else {
        emit(state.copyWith(debugTapCount: newTapCount));
      }
    }
  }

  void resetDebugMode() {
    emit(state.copyWith(showDebug: false, debugTapCount: 0));
  }

  void _listenToConfigs() {
    emit(state.copyWith(isLoading: true));

    _subscription?.cancel();
    _subscription = _listenToConfigsUseCase(NoParams()).listen(
      (result) => result.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (configs) => emit(state.copyWith(
          configs: configs,
          failure: const Failure.none(),
          isLoading: false,
        )),
      ),
    );
    _loadAppInfo();
  }

  Future<void> getConfigs() async {
    emit(state.copyWith(isLoading: true));
    final result = await _getConfigsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isLoading: false,
      )),
      (configs) => emit(state.copyWith(
        configs: configs,
        failure: const Failure.none(),
        isLoading: false,
      )),
    );
  }

  Future<void> getConfigByKey(String key) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getConfigUseCase(
      GetConfigUseCaseParams(key: key),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isLoading: false,
      )),
      (config) {
        // Update the config in the list if it exists, or add it
        final configs = List<ConfigEntity>.from(state.configs);
        final index = configs.indexWhere((c) => c.key == key);
        if (index >= 0) {
          configs[index] = config;
        } else {
          configs.add(config);
        }
        emit(state.copyWith(
          configs: configs,
          failure: const Failure.none(),
          isLoading: false,
        ));
      },
    );
  }

  Future<void> saveConfig({
    required String key,
    required ConfigType type,
    required dynamic value,
  }) async {
    emit(state.copyWith(isSaving: true));
    final result = await _saveConfigUseCase(
      SaveConfigUseCaseParams(
        key: key,
        type: type,
        value: value,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isSaving: false,
        isLoading: false,
      )),
      (_) => emit(state.copyWith(
        failure: const Failure.none(),
        isSaving: false,
      )),
    );
  }

  Future<void> updateConfig(
    String key, {
    ConfigType? type,
    dynamic value,
  }) async {
    emit(state.copyWith(isSaving: true));
    final result = await _updateConfigUseCase(
      UpdateConfigUseCaseParams(
        key: key,
        type: type,
        value: value,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isSaving: false,
      )),
      (_) => emit(state.copyWith(
        failure: const Failure.none(),
        isSaving: false,
      )),
    );
  }

  Future<void> deleteConfig(String key) async {
    emit(state.copyWith(isDeleting: true));
    final result = await _deleteConfigUseCase(
      DeleteConfigUseCaseParams(key: key),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isDeleting: false,
      )),
      (_) => emit(state.copyWith(
        failure: const Failure.none(),
        isDeleting: false,
      )),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
