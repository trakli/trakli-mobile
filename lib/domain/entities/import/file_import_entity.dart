import 'package:equatable/equatable.dart';

class FileImportEntity extends Equatable {
  final int id;
  final String name;
  final String filePath;
  final String fileType;
  final String status;
  final int? totalRows;
  final int? successCount;
  final int? failedCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FileImportEntity({
    required this.id,
    required this.name,
    required this.filePath,
    required this.fileType,
    required this.status,
    this.totalRows,
    this.successCount,
    this.failedCount,
    this.createdAt,
    this.updatedAt,
  });

  bool get isTerminal =>
      status == 'completed' || status == 'failed' || status == 'partial';

  @override
  List<Object?> get props => [
        id,
        name,
        filePath,
        fileType,
        status,
        totalRows,
        successCount,
        failedCount,
        createdAt,
        updatedAt,
      ];
}
