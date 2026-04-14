part of 'config_cubit.dart';

@freezed
class ConfigState with _$ConfigState {
  const factory ConfigState({
    required List<ConfigEntity> configs,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
    String? appVersion,
    int? debugTapCount,
    bool? showDebug,
  }) = _ConfigState;

  factory ConfigState.initial() => const ConfigState(
        configs: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        debugTapCount: 0,
        failure: Failure.none(),
      );

  const ConfigState._();

  ConfigEntity? getConfigByKey(String key) =>
      configs.firstWhereOrNull((config) => config.key == key);

  // Check if a config exists
  bool hasConfig(String key) => getConfigByKey(key) != null;
}
