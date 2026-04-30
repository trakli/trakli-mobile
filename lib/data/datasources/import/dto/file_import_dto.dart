import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';

part 'file_import_dto.g.dart';

@JsonSerializable()
class FileImportDto {
  final int id;
  final String name;
  @JsonKey(name: 'file_path')
  final String? filePath;
  @JsonKey(name: 'file_type')
  final String? fileType;
  final String? status;
  @JsonKey(name: 'total_rows')
  final int? totalRows;
  @JsonKey(name: 'success_count')
  final int? successCount;
  @JsonKey(name: 'failed_count')
  final int? failedCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const FileImportDto({
    required this.id,
    required this.name,
    this.filePath,
    this.fileType,
    this.status,
    this.totalRows,
    this.successCount,
    this.failedCount,
    this.createdAt,
    this.updatedAt,
  });

  factory FileImportDto.fromJson(Map<String, dynamic> json) =>
      _$FileImportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileImportDtoToJson(this);

  FileImportEntity toEntity() => FileImportEntity(
        id: id,
        name: name,
        filePath: filePath ?? '',
        fileType: fileType ?? '',
        status: status ?? 'pending',
        totalRows: totalRows,
        successCount: successCount,
        failedCount: failedCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
