import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/config/remote_feature_config.dart';
import 'package:trakli/domain/usecases/remote_config/get_remote_feature_config_usecase.dart';

part 'remote_config_state.dart';

@injectable
class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  RemoteConfigCubit(this._getRemoteFeatureConfig)
      : super(RemoteConfigState(_getRemoteFeatureConfig()));

  final GetRemoteFeatureConfigUseCase _getRemoteFeatureConfig;

  void refresh() {
    emit(RemoteConfigState(_getRemoteFeatureConfig()));
  }
}
