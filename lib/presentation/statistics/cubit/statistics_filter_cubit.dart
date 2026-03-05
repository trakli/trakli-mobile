import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'statistics_filter_state.dart';

export 'statistics_filter_state.dart';

@injectable
class StatisticsFilterCubit extends Cubit<StatisticsFilterState> {
  StatisticsFilterCubit() : super(const StatisticsFilterState()) {
    _init();
  }

  void _init() {
    final now = DateTime.now();
    // Default: 4 months including current month (start = first day of month 3 months ago)
    final startDate = DateTime(now.year, now.month - 3, 1);
    emit(state.copyWith(
      startDate: startDate,
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    ));
  }

  void setDateRange(DateTime start, DateTime end) {
    emit(state.copyWith(
      startDate: start,
      endDate: DateTime(end.year, end.month, end.day, 23, 59, 59),
    ));
  }

  void setWallet(String? clientId) {
    emit(state.copyWith(walletClientId: clientId));
  }
}
