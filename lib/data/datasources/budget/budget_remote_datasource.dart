import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_period_state_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_transactions_response.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetCompleteDto>> getAllBudgets({
    DateTime? syncedSince,
    bool? noClientId,
    bool? active,
  });
  Future<BudgetCompleteDto?> getBudget(int id);
  Future<BudgetCompleteDto> insertBudget(BudgetCompleteDto dto);
  Future<BudgetCompleteDto> updateBudget(BudgetCompleteDto dto);
  Future<void> deleteBudget(int id);
  Future<BudgetProgressDto?> getBudgetProgress(int id);
  Future<BudgetTransactionsResponse?> getBudgetTransactions(
    int id, {
    int limit = 50,
  });
  Future<BudgetCompleteDto?> closeBudgetPeriod(int id);
  Future<List<BudgetPeriodStateDto>> getAllPeriodStates({
    DateTime? syncedSince,
    bool? noClientId,
  });
}

@Injectable(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final Dio dio;

  BudgetRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BudgetCompleteDto>> getAllBudgets({
    DateTime? syncedSince,
    bool? noClientId,
    bool? active,
  }) async {
    final allItems = <BudgetCompleteDto>[];
    int currentPage = 1;

    while (true) {
      final queryParams = <String, dynamic>{'page': currentPage};
      if (syncedSince != null) {
        queryParams['synced_since'] =
            formatServerIsoDateTimeString(syncedSince);
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }
      if (active != null) {
        queryParams['active'] = active;
      }

      final response = await dio.get('budgets', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginated = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) =>
            BudgetCompleteDto.fromServerJson(json! as Map<String, dynamic>),
      );

      allItems.addAll(paginated.data);

      if (!paginated.hasMore) break;
      currentPage++;
    }

    return allItems;
  }

  @override
  Future<BudgetCompleteDto?> getBudget(int id) async {
    final response = await dio.get('budgets/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<BudgetCompleteDto> insertBudget(BudgetCompleteDto dto) async {
    final response = await dio.post('budgets', data: dto.toServerJson());
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<BudgetCompleteDto> updateBudget(BudgetCompleteDto dto) async {
    final response = await dio.put(
      'budgets/${dto.budget.id}',
      data: dto.toServerJson(),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteBudget(int id) async {
    await dio.delete('budgets/$id');
  }

  @override
  Future<BudgetProgressDto?> getBudgetProgress(int id) async {
    final response = await dio.get('budgets/$id/progress');
    if (response.data == null) return null;
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetProgressDto.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<BudgetTransactionsResponse?> getBudgetTransactions(
    int id, {
    int limit = 50,
  }) async {
    final response = await dio.get(
      'budgets/$id/transactions',
      queryParameters: {'limit': limit},
    );
    if (response.data == null) return null;
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetTransactionsResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<BudgetCompleteDto?> closeBudgetPeriod(int id) async {
    final response = await dio.post('budgets/$id/close-period');
    if (response.data == null) return null;
    final apiResponse = ApiResponse.fromJson(response.data);
    return BudgetCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<BudgetPeriodStateDto>> getAllPeriodStates({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    final allItems = <BudgetPeriodStateDto>[];
    int currentPage = 1;

    while (true) {
      final queryParams = <String, dynamic>{'page': currentPage};
      if (syncedSince != null) {
        queryParams['synced_since'] =
            formatServerIsoDateTimeString(syncedSince);
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }

      final response = await dio.get(
        'budget-period-states',
        queryParameters: queryParams,
      );
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginated = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => BudgetPeriodStateDto.fromJson(
          JsonDefaultsHelper.addDefaults(json! as Map<String, dynamic>),
        ),
      );

      allItems.addAll(paginated.data);
      if (!paginated.hasMore) break;
      currentPage++;
    }

    return allItems;
  }
}
