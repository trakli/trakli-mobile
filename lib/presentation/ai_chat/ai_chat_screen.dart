import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_composer.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_history_sheet.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_landing.dart';
import 'package:trakli/presentation/ai_chat/widgets/message_bubble.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiChatCubit _cubit = getIt<AiChatCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.openInitial();
  }

  @override
  void dispose() {
    _cubit.pausePolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
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
      builder: (_) => HistorySheet(cubit: cubit),
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

  void _sendMessage(String text, List<File> files, String? documentType) {
    final trimmed = text.trim();
    if (trimmed.isEmpty && files.isEmpty) return;
    context.read<AiChatCubit>().sendMessage(
          trimmed,
          files: files.isEmpty ? null : files,
          documentType: documentType,
        );
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
        showBack: true,
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
              final hasContent =
                  state.messages.isNotEmpty || state.recentSession != null;
              if (state.isInitializing && !hasContent) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  if (state.isInitializing)
                    LinearProgressIndicator(
                      minHeight: 2.h,
                      backgroundColor: Colors.transparent,
                      color: tones.brand.deep,
                    ),
                  if (state.failure != null) _ErrorBanner(state: state),
                  Expanded(
                    child: state.isEmpty
                        ? ChatLanding(
                            onPick: _send,
                            recentSession: state.recentSession,
                            onContinue: () {
                              final id = state.recentSession?.id;
                              if (id != null) {
                                context.read<AiChatCubit>().openSession(id);
                              }
                            },
                          )
                        : ListView.builder(
                            controller: _scroll,
                            padding:
                                EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                            itemCount: state.messages.length,
                            itemBuilder: (context, i) {
                              final message = state.messages[i];
                              return MessageRow(message: message);
                            },
                          ),
                  ),
                  Composer(
                    controller: _composer,
                    focus: _focus,
                    isSending: state.isBusy,
                    onSend: _sendMessage,
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
              state.failure?.maybeMap(
                    networkError: (f) => f.customMessage,
                    orElse: () => LocaleKeys.aiChatError.tr(),
                  ) ??
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
