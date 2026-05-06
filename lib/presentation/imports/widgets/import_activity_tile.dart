import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/failed_imports_screen.dart';
import 'package:trakli/presentation/imports/import_detail_screen.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

/// Sealed type so hub variants can build a unified, sortable list of
/// spreadsheet imports and AI scan sessions without leaking entity knowledge
/// into every screen.
sealed class ImportActivity {
  const ImportActivity();
  DateTime get sortDate;
}

class SpreadsheetActivity extends ImportActivity {
  final FileImportEntity imp;
  const SpreadsheetActivity(this.imp);
  @override
  DateTime get sortDate =>
      imp.updatedAt ?? imp.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
}

class ScanActivity extends ImportActivity {
  final ImportSessionEntity session;
  const ScanActivity(this.session);
  @override
  DateTime get sortDate =>
      session.updatedAt ??
      session.createdAt ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

/// Merges imports and sessions into a single list sorted newest-first.
List<ImportActivity> mergeActivity(
  List<FileImportEntity> imports,
  List<ImportSessionEntity> sessions,
) {
  final merged = <ImportActivity>[
    ...imports.map(SpreadsheetActivity.new),
    ...sessions.map(ScanActivity.new),
  ];
  merged.sort((a, b) => b.sortDate.compareTo(a.sortDate));
  return merged;
}

class ImportActivityTile extends StatelessWidget {
  final ImportActivity activity;
  const ImportActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return switch (activity) {
      SpreadsheetActivity(imp: final imp) => _SpreadsheetTile(imp: imp),
      ScanActivity(session: final s) => _ScanTile(session: s),
    };
  }
}

class _SpreadsheetTile extends StatelessWidget {
  final FileImportEntity imp;
  const _SpreadsheetTile({required this.imp});

  @override
  Widget build(BuildContext context) {
    final failedCount = imp.failedCount ?? 0;
    final subtitle = failedCount > 0
        ? '${imp.status} • ${LocaleKeys.importFailedCount.tr()}: $failedCount'
        : imp.status;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      child: ListTile(
        leading: const Icon(Icons.table_view),
        title: Text(imp.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle),
        trailing: !imp.isTerminal
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : failedCount > 0
                ? TextButton(
                    onPressed: () => AppNavigator.push(
                      context,
                      FailedImportsScreen(importId: imp.id),
                    ),
                    child: Text(LocaleKeys.importFixFailedRows.tr()),
                  )
                : _relativeTime(context, imp.updatedAt ?? imp.createdAt),
        onTap: () => AppNavigator.push(
          context,
          ImportDetailScreen(importId: imp.id),
        ),
      ),
    );
  }
}

class _ScanTile extends StatelessWidget {
  final ImportSessionEntity session;
  const _ScanTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final count = session.suggestions.length;
    final statusLabel = session.status.wire;
    final subtitle = count > 0 ? '$statusLabel • $count' : statusLabel;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      child: ListTile(
        leading: const Icon(Icons.auto_awesome_outlined),
        title: Text(ImportFilePicker.displayName(session.fileName),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle),
        trailing: !session.isTerminal
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : _relativeTime(context, session.updatedAt ?? session.createdAt),
        onTap: () => AppNavigator.push(
          context,
          SuggestionReviewScreen(sessionId: session.id),
        ),
      ),
    );
  }
}

Widget _relativeTime(BuildContext context, DateTime? dt) {
  if (dt == null) return const SizedBox.shrink();
  final diff = DateTime.now().difference(dt);
  final String text;
  if (diff.inMinutes < 1) {
    text = 'now';
  } else if (diff.inHours < 1) {
    text = '${diff.inMinutes}m';
  } else if (diff.inDays < 1) {
    text = '${diff.inHours}h';
  } else if (diff.inDays < 7) {
    text = '${diff.inDays}d';
  } else {
    text = '${(diff.inDays / 7).floor()}w';
  }
  return Text(
    text,
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
  );
}
