import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/stats/dto/financial_position_dto.dart';
import 'package:trakli/data/datasources/stats/dto/report_stats_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';

abstract class StatsRemoteDataSource {
  Future<FinancialPositionDto> getFinancialPosition(
      FinancialPositionPreset preset);

  Future<ReportStatsDto> getReportStats({
    required DateTime start,
    required DateTime end,
  });
}

@Injectable(as: StatsRemoteDataSource)
class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final Dio dio;

  StatsRemoteDataSourceImpl({required this.dio});

  @override
  Future<FinancialPositionDto> getFinancialPosition(
      FinancialPositionPreset preset) async {
    final response = await dio.get(
      'stats',
      queryParameters: {
        'section': 'position',
        'preset': preset.serverKey,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    final data = apiResponse.data as Map<String, dynamic>;
    final position = Map<String, dynamic>.from(data['position'] as Map);
    position['currency'] = data['currency'] ?? position['currency'];
    position['partial'] = data['partial'] ?? position['partial'] ?? false;
    return FinancialPositionDto.fromJson(position);
  }

  @override
  Future<ReportStatsDto> getReportStats({
    required DateTime start,
    required DateTime end,
  }) async {
    final response = await dio.get(
      'stats',
      queryParameters: {
        'start_date': _ymd(start),
        'end_date': _ymd(end),
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return ReportStatsDto.fromJson(
        (apiResponse.data as Map).cast<String, dynamic>());
  }

  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
