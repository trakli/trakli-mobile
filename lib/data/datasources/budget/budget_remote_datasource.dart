import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetDto>> getAllBudgets({
    DateTime? syncedSince,
    bool? noClientId,
  });

  Future<BudgetDto?> getBudget(int id);

  Future<BudgetDto> insertBudget({
    required String clientId,
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
    DateTime? createdAt,
  });

  Future<BudgetDto> updateBudget({
    required int id,
    required String clientId,
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  });

  Future<void> deleteBudget(int id);

  Future<BudgetProgressDto> getProgress(int id);
}

@Injectable(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final Dio dio;

  BudgetRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BudgetDto>> getAllBudgets({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    final all = <BudgetDto>[];
    int page = 1;
    while (true) {
      final queryParams = <String, dynamic>{'page': page};
      if (syncedSince != null) {
        queryParams['synced_since'] =
            formatServerIsoDateTimeString(syncedSince);
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }
      final response = await dio.get('budgets', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);
      final paginated = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => BudgetDto.fromJson(
          JsonDefaultsHelper.addDefaults(json! as Map<String, dynamic>),
        ),
      );
      all.addAll(paginated.data);
      if (!paginated.hasMore) break;
      page++;
    }
    return all;
  }

  @override
  Future<BudgetDto?> getBudget(int id) async {
    final response = await dio.get('budgets/$id');
    if (response.data == null) return null;
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetDto.fromJson(
      JsonDefaultsHelper.addDefaults(
        apiResponse.data as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<BudgetDto> insertBudget({
    required String clientId,
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
    DateTime? createdAt,
  }) async {
    final data = <String, dynamic>{
      'client_id': clientId,
      'name': name,
      if (description != null) 'description': description,
      'amount': amount,
      'currency': currency,
      'period_type': periodType.serverKey,
      'start_date': formatServerIsoDateTimeString(startDate),
      if (endDate != null) 'end_date': formatServerIsoDateTimeString(endDate),
      'rollover_enabled': rolloverEnabled,
      'threshold_percent': thresholdPercent,
      'forecast_alerts_enabled': forecastAlertsEnabled,
      'is_active': isActive,
      'targets': targets.map((t) => _targetPayload(t)).toList(),
      if (createdAt != null)
        'created_at': formatServerIsoDateTimeString(createdAt),
    };
    final response = await dio.post('budgets', data: data);
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetDto.fromJson(
      JsonDefaultsHelper.addDefaults(
        apiResponse.data as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<BudgetDto> updateBudget({
    required int id,
    required String clientId,
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  }) async {
    final data = <String, dynamic>{
      'client_id': clientId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (periodType != null) 'period_type': periodType.serverKey,
      if (startDate != null)
        'start_date': formatServerIsoDateTimeString(startDate),
      if (endDate != null) 'end_date': formatServerIsoDateTimeString(endDate),
      if (rolloverEnabled != null) 'rollover_enabled': rolloverEnabled,
      if (thresholdPercent != null) 'threshold_percent': thresholdPercent,
      if (forecastAlertsEnabled != null)
        'forecast_alerts_enabled': forecastAlertsEnabled,
      if (isActive != null) 'is_active': isActive,
      if (targets != null)
        'targets': targets.map((t) => _targetPayload(t)).toList(),
    };
    final response = await dio.put('budgets/$id', data: data);
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetDto.fromJson(
      JsonDefaultsHelper.addDefaults(
        apiResponse.data as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<void> deleteBudget(int id) async {
    await dio.delete('budgets/$id');
  }

  @override
  Future<BudgetProgressDto> getProgress(int id) async {
    final response = await dio.get('budgets/$id/progress');
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetProgressDto.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> _targetPayload(BudgetTargetInput target) {
    return {
      'type': target.type.serverKey,
      if (target.targetId != null) 'id': target.targetId,
      if (target.targetClientId.isNotEmpty)
        'client_generated_id': target.targetClientId,
    };
  }
}
