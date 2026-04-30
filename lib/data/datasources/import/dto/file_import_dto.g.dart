// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_import_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileImportDto _$FileImportDtoFromJson(Map<String, dynamic> json) =>
    FileImportDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      filePath: json['file_path'] as String?,
      fileType: json['file_type'] as String?,
      status: json['status'] as String?,
      totalRows: (json['total_rows'] as num?)?.toInt(),
      successCount: (json['success_count'] as num?)?.toInt(),
      failedCount: (json['failed_count'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FileImportDtoToJson(FileImportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_path': instance.filePath,
      'file_type': instance.fileType,
      'status': instance.status,
      'total_rows': instance.totalRows,
      'success_count': instance.successCount,
      'failed_count': instance.failedCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
