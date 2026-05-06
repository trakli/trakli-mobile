import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class ImportActivityTile extends StatelessWidget {
  final ImportSessionEntity session;
  const ImportActivityTile({super.key, required this.session});

  bool get _hasNothingToReview =>
      session.suggestions.isEmpty && session.isTerminal;

  String _subtitle() {
    if (_hasNothingToReview) {
      return LocaleKeys.importNoTransactionsFound.tr();
    }
    final count = session.suggestions.length;
    final statusLabel = session.status.wire;
    return count > 0 ? '$statusLabel • $count' : statusLabel;
  }

  void _onTap(BuildContext context) {
    if (_hasNothingToReview) {
      _showEmptySheet(context);
      return;
    }
    AppNavigator.push(
      context,
      SuggestionReviewScreen(sessionId: session.id),
    );
  }

  void _showEmptySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) => _EmptySessionSheet(
        fileName: ImportFilePicker.displayName(session.fileName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      child: ListTile(
        leading: const Icon(Icons.auto_awesome_outlined),
        title: Text(
          ImportFilePicker.displayName(session.fileName),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_subtitle()),
        trailing: !session.isTerminal
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : _relativeTime(context, session.updatedAt ?? session.createdAt),
        onTap: () => _onTap(context),
      ),
    );
  }
}

class _EmptySessionSheet extends StatelessWidget {
  final String fileName;
  const _EmptySessionSheet({required this.fileName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.importNoSuggestionsTitle.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              fileName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.importNoSuggestions.tr(),
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 48.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(LocaleKeys.importNoSuggestionsClose.tr()),
              ),
            ),
          ],
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
