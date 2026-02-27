import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/app_update_result.dart';
import 'package:trakli/domain/usecases/app_update/check_app_update_usecase.dart';

class AppUpdateState {
  final bool isLoading;
  final AppUpdateCheckResult? result;

  const AppUpdateState({
    this.isLoading = true,
    this.result,
  });
}

@injectable
class AppUpdateCubit extends Cubit<AppUpdateState> {
  final CheckAppUpdateUseCase _checkAppUpdateUseCase;

  AppUpdateCubit(this._checkAppUpdateUseCase)
      : super(const AppUpdateState(isLoading: true));

  Future<void> check() async {
    emit(const AppUpdateState(isLoading: true));

    final result = await _checkAppUpdateUseCase();
    emit(AppUpdateState(isLoading: false, result: result));
  }
}
