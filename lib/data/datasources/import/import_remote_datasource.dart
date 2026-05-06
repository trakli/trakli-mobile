import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/import/dto/confirm_accepted_item_dto.dart';
import 'package:trakli/data/datasources/import/dto/import_session_dto.dart';
import 'package:trakli/domain/entities/import/document_type.dart';

class ConfirmSessionResponse {
  final int createdCount;
  final List<String> errors;

  const ConfirmSessionResponse({
    required this.createdCount,
    required this.errors,
  });

  factory ConfirmSessionResponse.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    return ConfirmSessionResponse(
      createdCount: (json['created_count'] as num?)?.toInt() ?? 0,
      errors: rawErrors is List
          ? rawErrors.map((e) => e.toString()).toList()
          : const [],
    );
  }
}

abstract class ImportRemoteDataSource {
  Future<ImportSessionDto> analyzeDocument(
    File file,
    DocumentType documentType,
  );

  Future<ConfirmSessionResponse> confirmSession({
    required int sessionId,
    required List<ConfirmAcceptedItemDto> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  });

  Future<List<ImportSessionDto>> getSessions();

  Future<ImportSessionDto> getSession(int sessionId);
}

@Injectable(as: ImportRemoteDataSource)
class ImportRemoteDataSourceImpl implements ImportRemoteDataSource {
  final Dio dio;

  ImportRemoteDataSourceImpl({required this.dio});

  @override
  Future<ImportSessionDto> analyzeDocument(
    File file,
    DocumentType documentType,
  ) {
    return ErrorHandler.handleApiCall(() async {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'document_type': documentType.serverKey,
      });

      final response = await dio.post('import/analyze', data: formData);
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      return ImportSessionDto.fromJson(
          apiResponse.data as Map<String, dynamic>);
    });
  }

  @override
  Future<ConfirmSessionResponse> confirmSession({
    required int sessionId,
    required List<ConfirmAcceptedItemDto> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.post(
        'import/confirm',
        data: {
          'session_id': sessionId,
          'accepted': accepted.map((s) => s.toJson()).toList(),
          'auto_create_wallets': autoCreateWallets,
          'auto_create_parties': autoCreateParties,
          'auto_create_categories': autoCreateCategories,
        },
      );

      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      return ConfirmSessionResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<List<ImportSessionDto>> getSessions() {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.get('import/sessions');
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      final list = apiResponse.data as List;
      return list
          .map((e) => ImportSessionDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<ImportSessionDto> getSession(int sessionId) {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.get('import/sessions/$sessionId');
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      return ImportSessionDto.fromJson(
          apiResponse.data as Map<String, dynamic>);
    });
  }
}
