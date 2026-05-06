import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';

class ConfirmSessionResult {
  final int createdCount;
  final List<String> errors;

  const ConfirmSessionResult({
    required this.createdCount,
    required this.errors,
  });
}

/// Pairs an accepted suggestion with its position in `session.suggestions`.
/// The backend reads `index` to look up the original AI-extracted record.
typedef AcceptedSuggestion = ({
  int index,
  TransactionSuggestionEntity suggestion,
});

abstract class ImportRepository {
  Future<Either<Failure, ImportSessionEntity>> analyzeDocument(
    File file,
    DocumentType documentType,
  );

  Future<Either<Failure, ConfirmSessionResult>> confirmSession({
    required int sessionId,
    required List<AcceptedSuggestion> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  });

  Future<Either<Failure, List<ImportSessionEntity>>> getSessions();

  Future<Either<Failure, ImportSessionEntity>> getSession(int sessionId);
}
