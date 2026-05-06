import 'package:equatable/equatable.dart';
import 'package:trakli/domain/entities/import/import_session_status.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';

class ImportSessionEntity extends Equatable {
  final int id;
  final String fileName;
  final String fileType;
  final String? documentType;
  final String? processor;
  final ImportSessionStatus status;
  final List<TransactionSuggestionEntity> suggestions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ImportSessionEntity({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.status,
    this.documentType,
    this.processor,
    this.suggestions = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Convenience that mirrors [ImportSessionStatus.isTerminal] so existing
  /// `session.isTerminal` call sites keep working.
  bool get isTerminal => status.isTerminal;

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileType,
        documentType,
        processor,
        status,
        suggestions,
        createdAt,
        updatedAt,
      ];
}
