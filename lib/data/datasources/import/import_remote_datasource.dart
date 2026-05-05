import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/import/dto/confirm_accepted_item_dto.dart';
import 'package:trakli/data/datasources/import/dto/failed_import_dto.dart';
import 'package:trakli/data/datasources/import/dto/file_import_dto.dart';
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

class FixFailedImportsResponse {
  final List<FailedImportDto> stillFailed;

  const FixFailedImportsResponse({required this.stillFailed});
}

abstract class ImportRemoteDataSource {
  Future<FileImportDto> uploadImport(File file);

  Future<List<FileImportDto>> getImports();

  Future<List<FailedImportDto>> getFailedImports(
    int importId, {
    int perPage = 50,
  });

  Future<FixFailedImportsResponse> fixFailedImports(
    int importId,
    List<FailedImportDto> rows, {
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  });

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
  Future<FileImportDto> uploadImport(File file) {
    return ErrorHandler.handleApiCall(() async {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post('import', data: formData);
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      return FileImportDto.fromJson(apiResponse.data as Map<String, dynamic>);
    });
  }

  @override
  Future<List<FileImportDto>> getImports() {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.get('imports');
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      final list = apiResponse.data as List;
      return list
          .map((e) => FileImportDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<FailedImportDto>> getFailedImports(
    int importId, {
    int perPage = 10,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final allRows = <FailedImportDto>[];
      int currentPage = 1;

      while (true) {
        final response = await dio.get(
          'imports/$importId/failed',
          queryParameters: {'page': currentPage, 'perPage': perPage},
        );
        final apiResponse =
            ApiResponse.fromJson(response.data as Map<String, dynamic>);
        final paginated = PaginationResponse.fromJson(
          apiResponse.data as Map<String, dynamic>,
          (json) => FailedImportDto.fromJson(json! as Map<String, dynamic>),
        );

        allRows.addAll(paginated.data);
        if (!paginated.hasMore) break;
        currentPage++;
      }

      return allRows;
    });
  }

  @override
  Future<FixFailedImportsResponse> fixFailedImports(
    int importId,
    List<FailedImportDto> rows, {
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.put(
        'imports/$importId/fix',
        data: {
          'rows': rows.map((r) => r.toJson()).toList(),
          'auto_create_wallets': autoCreateWallets,
          'auto_create_parties': autoCreateParties,
          'auto_create_categories': autoCreateCategories,
        },
      );

      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);

      final data = apiResponse.data;
      if (data is List) {
        return FixFailedImportsResponse(
          stillFailed: data
              .map((e) => FailedImportDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return const FixFailedImportsResponse(stillFailed: []);
    });
  }

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
