import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AiChatCubit>()..loadMostRecent(),
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _openHistorySheet(BuildContext context) {
    final cubit = context.read<AiChatCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HistorySheet(cubit: cubit),
    );
  }

  void _send([String? overrideText]) {
    final text = (overrideText ?? _composer.text).trim();
    if (text.isEmpty) return;
    context.read<AiChatCubit>().sendMessage(text);
    _composer.clear();
    _focus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.aiChatTitle.tr(),
        showBack: false,
        actions: [
          PageAppBarAction(
            icon: Icons.history_rounded,
            tooltip: LocaleKeys.aiChatHistory.tr(),
            onTap: () => _openHistorySheet(context),
          ),
          BlocBuilder<AiChatCubit, AiChatState>(
            buildWhen: (a, b) => a.hasSession != b.hasSession,
            builder: (context, state) {
              if (!state.hasSession) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: PageAppBarAction(
                  icon: Icons.add_comment_outlined,
                  tooltip: LocaleKeys.aiChatNewChat.tr(),
                  onTap: () => context.read<AiChatCubit>().startNewChat(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          IconBackgroundDecor(iconPath: Assets.images.sparkles),
          BlocConsumer<AiChatCubit, AiChatState>(
            listenWhen: (a, b) =>
                a.messages.length != b.messages.length ||
                (a.isPolling && !b.isPolling),
            listener: (context, state) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToBottom());
            },
            builder: (context, state) {
              if (state.isInitializing) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  if (state.failure != null) _ErrorBanner(state: state),
                  Expanded(
                    child: state.isEmpty
                        ? _EmptyState(onPick: _send)
                        : ListView.builder(
                            controller: _scroll,
                            padding:
                                EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                            itemCount: state.messages.length,
                            itemBuilder: (context, i) {
                              return _MessageRow(message: state.messages[i]);
                            },
                          ),
                  ),
                  _Composer(
                    controller: _composer,
                    focus: _focus,
                    isSending: state.isBusy,
                    onSend: _send,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final AiChatState state;
  const _ErrorBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: tones.expense.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: tones.expense.accent.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: tones.expense.deep, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              LocaleKeys.aiChatError.tr(),
              style: TextStyle(
                color: tones.expense.deep,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  final ChatMessageDto message;
  const _MessageRow({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _AssistantAvatar(),
            SizedBox(width: 8.w),
          ],
          Flexible(child: _Bubble(message: message)),
          if (isUser) ...[
            SizedBox(width: 8.w),
            const _UserAvatar(),
          ],
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
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tones.brand.accent, tones.brand.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: radius,
        ),
        child: SelectableText(
          message.displayText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
      );
    }

    final bg = failed ? tones.expense.background : tones.bgCard;
    final fg = failed ? tones.expense.deep : tones.textPrimary;

    final body = inFlight
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: _ThinkingDots(color: tones.brand.deep.withAlpha(180)),
          )
        : SelectableText(
            failed
                ? (message.error ?? LocaleKeys.aiChatError.tr())
                : message.displayText,
            style: TextStyle(
              color: fg,
              fontSize: 14.sp,
              height: 1.45,
            ),
          );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.all(
          color: failed
              ? tones.expense.accent.withAlpha(60)
              : tones.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: body,
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
      child: HeroIcon(
        HeroIcons.sparkles,
        style: HeroIconStyle.outline,
        color: tones.brand.deep,
        size: 16.sp,
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

class _EmptyState extends StatelessWidget {
  final void Function(String) onPick;
  const _EmptyState({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final suggestions = [
      'How much did I spend this month?',
      'What was my biggest expense category last week?',
      'Show my income vs expenses for the year.',
      'What was my balance on the 15th?',
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      children: [
        SizedBox(height: 24.h),
        Center(
          child: Container(
            width: 76.r,
            height: 76.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tones.brand.accent, tones.brand.deep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tones.brand.deep.withAlpha(60),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.r),
            child: SvgPicture.asset(
              Assets.images.sparkles,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          LocaleKeys.aiChatTitle.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tones.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          LocaleKeys.aiChatEmptyHint.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tones.textSecondary,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
        SizedBox(height: 28.h),
        ...suggestions.map((q) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: InkWell(
              onTap: () => onPick(q),
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: tones.bgCard,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: tones.borderLight),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 16.sp,
                      color: tones.brand.deep,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        q,
                        style: TextStyle(
                          color: tones.textPrimary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 14.sp,
                      color: tones.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Composer extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool isSending;
  final void Function([String? overrideText]) onSend;

  const _Composer({
    required this.controller,
    required this.focus,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final canSend = _hasText && !widget.isSending;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final fabReserve = keyboardOpen ? 0.0 : 30.r;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h + fabReserve),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: tones.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: tones.borderLight),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 120.h),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focus,
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      color: tones.textPrimary,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      hintText: LocaleKeys.aiChatComposerPlaceholder.tr(),
                      hintStyle: TextStyle(
                        color: tones.textMuted,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: _SendButton(
                  canSend: canSend,
                  isSending: widget.isSending,
                  onTap: () => widget.onSend(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool canSend;
  final bool isSending;
  final VoidCallback onTap;
  const _SendButton({
    required this.canSend,
    required this.isSending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final enabled = canSend && !isSending;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: enabled ? tones.brand.deep : tones.borderLight,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Center(
            child: isSending
                ? SizedBox(
                    width: 14.r,
                    height: 14.r,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.arrow_upward_rounded,
                    color: enabled ? Colors.white : tones.textMuted,
                    size: 18.sp,
                  ),
          ),
        ),
      ),
    );
  }
}

class _HistorySheet extends StatefulWidget {
  final AiChatCubit cubit;
  const _HistorySheet({required this.cubit});

  @override
  State<_HistorySheet> createState() => _HistorySheetState();
}

class _HistorySheetState extends State<_HistorySheet> {
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
                      return const Center(
                          child: CircularProgressIndicator());
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
            child: HeroIcon(
              HeroIcons.sparkles,
              style: HeroIconStyle.outline,
              color: tones.brand.deep,
              size: 24,
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
              child: HeroIcon(
                HeroIcons.sparkles,
                style: HeroIconStyle.outline,
                color: isCurrent ? Colors.white : tones.brand.deep,
                size: 18,
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
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w600,
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
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[when.month - 1]} ${when.day}';
}
