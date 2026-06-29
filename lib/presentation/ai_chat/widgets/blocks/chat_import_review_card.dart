import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/import/import_session_status.dart';
import 'package:trakli/domain/usecases/import/get_import_session_usecase.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// An `import_review` block: shows the file's analysis status and, once ready,
/// a "Review import" action. Polls the import session every few seconds.
class ChatImportReviewCard extends StatefulWidget {
  final ImportReviewBlock block;
  const ChatImportReviewCard({super.key, required this.block});

  @override
  State<ChatImportReviewCard> createState() => _ChatImportReviewCardState();
}

class _ChatImportReviewCardState extends State<ChatImportReviewCard> {
  late ImportSessionStatus _status;
  Timer? _timer;
  int _ticks = 0;

  @override
  void initState() {
    super.initState();
    _status = ImportSessionStatus.parse(widget.block.status);
    if (widget.block.importSessionId != null && _status.isInFlight) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    final id = widget.block.importSessionId;
    // Give up after ~2 minutes so a stuck import doesn't poll forever.
    if (id == null || _ticks++ > 40) {
      _timer?.cancel();
      return;
    }
    final result = await getIt<GetImportSessionUseCase>()(
      GetImportSessionParams(sessionId: id),
    );
    if (!mounted) return;
    result.fold((_) {}, (session) {
      setState(() => _status = session.status);
      if (session.status.isTerminal) _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final analyzing = _status.isInFlight;
    final sessionId = widget.block.importSessionId;
    final canReview =
        sessionId != null && _status != ImportSessionStatus.unknown;
    final showReadyIcon = _status == ImportSessionStatus.ready ||
        _status == ImportSessionStatus.confirmed;
    final fileName = widget.block.fileName ?? '';
    final statusLabel = switch (_status) {
      ImportSessionStatus.ready => LocaleKeys.aiImportStatusReady.tr(),
      ImportSessionStatus.confirmed => LocaleKeys.aiImportStatusConfirmed.tr(),
      ImportSessionStatus.failed => LocaleKeys.aiImportStatusFailed.tr(),
      ImportSessionStatus.unknown => prettyKey(widget.block.status),
      _ => LocaleKeys.aiImportStatusAnalyzing.tr(),
    };

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 18.sp, color: tones.brand.deep),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  fileName.isEmpty ? statusLabel : fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: tones.textPrimary),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              if (analyzing) ...[
                SizedBox(
                  width: 12.r,
                  height: 12.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8.w),
              ] else if (_status == ImportSessionStatus.failed) ...[
                Icon(Icons.error_outline_rounded,
                    size: 14.sp, color: tones.expense.deep),
                SizedBox(width: 6.w),
              ] else if (showReadyIcon) ...[
                Icon(Icons.check_circle_rounded,
                    size: 14.sp, color: tones.income.deep),
                SizedBox(width: 6.w),
              ],
              Text(statusLabel,
                  style: TextStyle(fontSize: 12.sp, color: tones.textMuted)),
              const Spacer(),
              if (canReview)
                InkWell(
                  onTap: () => AppNavigator.push(
                    context,
                    SuggestionReviewScreen(sessionId: sessionId),
                  ),
                  child: Text(
                    LocaleKeys.aiReviewImport.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.brand.deep),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
