import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class HistorySheet extends StatefulWidget {
  final AiChatCubit cubit;
  const HistorySheet({super.key, required this.cubit});

  @override
  State<HistorySheet> createState() => HistorySheetState();
}

class HistorySheetState extends State<HistorySheet> {
  late Future<List<ChatSessionDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<List<ChatSessionDto>> _fetch() async {
    final result = await getIt<AiRepository>().listSessions();
    return result.fold((_) => <ChatSessionDto>[], (sessions) => sessions);
  }

  void _reload() => setState(() => _future = _fetch());

  Future<void> _confirmDelete(ChatSessionDto session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final tones = ctx.tones;
        return AlertDialog(
          backgroundColor: tones.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          content: Text(
            LocaleKeys.aiChatDeleteConfirm.tr(),
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                LocaleKeys.cancel.tr(),
                style: TextStyle(color: tones.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                LocaleKeys.delete.tr(),
                style: TextStyle(
                  color: tones.expense.deep,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    await widget.cubit.deleteSession(session.id);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: tones.bgPage,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: tones.borderMedium,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.aiChatHistory.tr(),
                        style: TextStyle(
                          color: tones.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          color: tones.textSecondary, size: 22.sp),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: tones.borderLight),
              Expanded(
                child: FutureBuilder<List<ChatSessionDto>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final sessions = snapshot.data ?? const [];
                    if (sessions.isEmpty) {
                      return _HistoryEmpty();
                    }
                    return BlocBuilder<AiChatCubit, AiChatState>(
                      bloc: widget.cubit,
                      buildWhen: (a, b) => a.session?.id != b.session?.id,
                      builder: (context, state) {
                        return ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount: sessions.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: tones.borderLight),
                          itemBuilder: (context, i) {
                            final s = sessions[i];
                            final isCurrent = state.session?.id == s.id;
                            return _SessionRow(
                              session: s,
                              isCurrent: isCurrent,
                              onTap: () {
                                widget.cubit.openSession(s.id);
                                Navigator.of(context).pop();
                              },
                              onDelete: () => _confirmDelete(s),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: tones.brand.background,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.smart_toy_rounded,
              color: tones.brand.deep,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            LocaleKeys.aiChatNoSessions.tr(),
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            LocaleKeys.aiChatNoSessionsHint.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final ChatSessionDto session;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionRow({
    required this.session,
    required this.isCurrent,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final title = (session.title?.trim().isNotEmpty ?? false)
        ? session.title!.trim()
        : LocaleKeys.aiChatUntitled.tr();

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isCurrent ? tones.brand.background : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isCurrent ? tones.brand.deep : tones.brand.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.smart_toy_rounded,
                color: isCurrent ? Colors.white : tones.brand.deep,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tones.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _relativeTime(session.updatedAt),
                    style: TextStyle(
                      color: tones.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: tones.textMuted,
                size: 20.sp,
              ),
              onPressed: onDelete,
              splashRadius: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}

String _relativeTime(DateTime when) {
  final now = DateTime.now();
  final diff = now.difference(when);
  if (diff.inSeconds < 60) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${months[when.month - 1]} ${when.day}';
}
