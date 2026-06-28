import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_widget.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_legacy_result.dart';
import 'package:trakli/presentation/ai_chat/widgets/proposed_action_card.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class MessageRow extends StatelessWidget {
  final ChatMessageDto message;
  const MessageRow({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: _Bubble(message: message)),
            SizedBox(width: 8.w),
            const _UserAvatar(),
          ],
        ),
      );
    }

    final blocks = message.blocks;
    final legacy = message.legacyResult;
    final hasContent = message.displayText.trim().isNotEmpty;

    final showContentBubble = message.isInFlight ||
        message.isFailed ||
        message.isServiceUnavailable ||
        (hasContent && blocks.isEmpty);

    const structured = ['table', 'list', 'pair_list', 'record'];
    final legacyToShow = (blocks.isEmpty &&
            legacy != null &&
            (!hasContent || structured.contains(legacy.formatType)))
        ? legacy
        : null;

    final showBubble =
        showContentBubble || (blocks.isEmpty && legacyToShow == null);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AssistantAvatar(),
          if (showBubble) ...[
            SizedBox(height: 8.h),
            _Bubble(message: message),
          ],
          for (final block in blocks)
            if (block is ProposedActionBlock)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: ProposedActionCard(
                  key: ValueKey(block.id),
                  block: block,
                ),
              )
            else
              ChatBlockWidget(block: block),
          if (legacyToShow != null) ChatLegacyResult(result: legacyToShow),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessageDto message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final isUser = message.isUser;
    final inFlight = message.isInFlight;
    final failed = message.isFailed;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(isUser ? 18.r : 6.r),
      topRight: Radius.circular(isUser ? 6.r : 18.r),
      bottomLeft: Radius.circular(18.r),
      bottomRight: Radius.circular(18.r),
    );

    if (isUser) {
      return GestureDetector(
        onLongPress: () => _copy(context, message.displayText),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [tones.brand.accent, tones.brand.deep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: radius,
          ),
          child: Text(
            message.displayText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    final bg = failed ? tones.expense.background : tones.bgCard;
    final fg = failed ? tones.expense.deep : tones.textPrimary;
    final isError = failed || message.isServiceUnavailable;

    final String errorText = failed
        ? (message.error ?? LocaleKeys.aiChatError.tr())
        : LocaleKeys.aiServiceUnavailable.tr();
    final copyText = inFlight
        ? ''
        : isError
            ? errorText
            : message.displayText;

    final Widget body;
    if (inFlight) {
      body = Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: _ThinkingDots(color: tones.brand.deep.withAlpha(180)),
      );
    } else if (isError) {
      body = Text(
        errorText,
        style: TextStyle(color: fg, fontSize: 14.sp, height: 1.45),
      );
    } else {
      body = GptMarkdown(
        message.displayText,
        style: TextStyle(color: fg, fontSize: 14.sp, height: 1.45),
      );
    }

    return GestureDetector(
      onLongPress: () => _copy(context, copyText),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(
            color:
                failed ? tones.expense.accent.withAlpha(60) : tones.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
            if (isError) ...[
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.read<AiChatCubit>().retry(message.id),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded,
                            size: 14.sp, color: tones.brand.deep),
                        SizedBox(width: 4.w),
                        Text(
                          LocaleKeys.retry.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: tones.brand.deep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.copiedToClipboard.tr()),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ThinkingDots extends StatefulWidget {
  final Color color;
  const _ThinkingDots({required this.color});

  @override
  State<_ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<_ThinkingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_ctl.value + i * 0.2) % 1.0;
            final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar();

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tones.brandSoft.background, tones.brand.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: tones.brand.deep.withAlpha(30), width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.smart_toy_rounded,
        color: tones.brand.deep,
        size: 18.sp,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final user = context.read<AuthCubit>().state.user;
    final initials = _initialsFor(
      first: user?.firstName,
      last: user?.lastName,
      email: user?.email,
    );

    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tones.brand.accent, tones.brand.deep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

String _initialsFor({String? first, String? last, String? email}) {
  String pick(String? s) =>
      (s != null && s.trim().isNotEmpty) ? s.trim()[0].toUpperCase() : '';
  final a = pick(first);
  final b = pick(last);
  if (a.isNotEmpty || b.isNotEmpty) return '$a$b';
  final e = pick(email);
  return e.isNotEmpty ? e : '·';
}
