import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/stats/dto/financial_position_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';

abstract class StatsRemoteDataSource {
  Future<FinancialPositionDto> getFinancialPosition(
      FinancialPositionPreset preset);
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
}
