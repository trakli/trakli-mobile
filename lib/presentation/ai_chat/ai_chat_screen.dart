import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_widget.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_legacy_result.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/imports/widgets/import_source_button.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

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
                        ? _EmptyState(
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
                              return _MessageRow(message: message);
                            },
                          ),
                  ),
                  _Composer(
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
                child: _ProposedActionCard(
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

class _ProposedActionCard extends StatefulWidget {
  final ProposedActionBlock block;
  const _ProposedActionCard({super.key, required this.block});

  @override
  State<_ProposedActionCard> createState() => _ProposedActionCardState();
}

class _ProposedActionCardState extends State<_ProposedActionCard> {
  final Map<String, dynamic> _edited = {};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.block.fields) {
      _edited[f.key] = f is CategoriesActionField ? f.initialIds : f.value;
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _isoLocal(DateTime d) =>
      '${d.year}-${_two(d.month)}-${_two(d.day)}T${_two(d.hour)}:${_two(d.minute)}';
  String _fmt(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year} ${_two(d.hour)}:${_two(d.minute)}';

  Map<String, dynamic> _overrides() {
    final o = <String, dynamic>{};
    for (final f in widget.block.fields) {
      final v = _edited[f.key];
      if (v == null) continue;
      if (v is String && v.trim().isEmpty) continue;
      if (v is List && v.isEmpty) continue;
      o[f.key] = v;
    }
    return o;
  }

  Future<void> _confirm() async {
    setState(() => _busy = true);
    await context.read<AiChatCubit>().confirmAction(
          actionId: widget.block.id,
          overrides: _overrides(),
        );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _reject() async {
    setState(() => _busy = true);
    await context.read<AiChatCubit>().rejectAction(actionId: widget.block.id);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final block = widget.block;
    final pending = block.isPending;
    final accent = block.risk == 'high' ? tones.accentWarm : tones.brand.deep;

    return Container(
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
              Icon(
                block.risk == 'high'
                    ? Icons.warning_amber_rounded
                    : Icons.shopping_cart_outlined,
                size: 16.sp,
                color: accent,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  block.summary,
                  style: TextStyle(
                    color: tones.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (pending)
            for (final f in block.fields)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _field(tones, f),
              )
          else
            for (final f in block.fields) _readonlyField(tones, f),
          SizedBox(height: 4.h),
          if (pending)
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    tones,
                    label: LocaleKeys.confirm.tr(),
                    filled: true,
                    busy: _busy,
                    onTap: _busy ? null : _confirm,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _actionButton(
                    tones,
                    label: LocaleKeys.dismiss.tr(),
                    filled: false,
                    busy: false,
                    onTap: _busy ? null : _reject,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(
                  block.isExecuted
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 15.sp,
                  color: block.isExecuted ? tones.income.deep : tones.textMuted,
                ),
                SizedBox(width: 6.w),
                Text(
                  block.isExecuted
                      ? LocaleKeys.done.tr()
                      : LocaleKeys.dismissed.tr(),
                  style: TextStyle(
                    color:
                        block.isExecuted ? tones.income.deep : tones.textMuted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _field(AppTones tones, ActionField f) {
    if (f is CategoriesActionField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.label,
              style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
          SizedBox(height: 6.h),
          _categoryChips(tones, f),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(f.label,
              style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
        ),
        SizedBox(width: 8.w),
        Expanded(flex: 3, child: _input(tones, f)),
      ],
    );
  }

  /// Searchable currency picker (reuses the app's currency_picker).
  Widget _currencyInput(AppTones tones, CurrencyActionField f) {
    final code = (_edited[f.key]?.toString() ?? '').toUpperCase();
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () => showCurrencyPicker(
        context: context,
        theme: CurrencyPickerThemeData(
          bottomSheetHeight: 0.7.sh,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flagSize: 24.sp,
        ),
        onSelect: (Currency c) => setState(() => _edited[f.key] = c.code),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                code.isEmpty ? '—' : code,
                style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
              ),
            ),
            Icon(Icons.expand_more_rounded,
                size: 16.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  /// Wallet type (bank / cash / credit_card / mobile) as a dropdown.
  Widget _walletTypeInput(AppTones tones, WalletTypeActionField f) {
    final current = _edited[f.key]?.toString();
    return _dropdown<String>(
      value:
          WalletType.values.any((w) => w.serverKey == current) ? current : null,
      items: WalletType.values
          .map((w) => DropdownMenuItem(
                value: w.serverKey,
                child: Text(w.customName, style: TextStyle(fontSize: 12.sp)),
              ))
          .toList(),
      onChanged: (v) => setState(() => _edited[f.key] = v),
    );
  }

  Widget _input(AppTones tones, ActionField f) => switch (f) {
        final CurrencyActionField x => _currencyInput(tones, x),
        final WalletTypeActionField x => _walletTypeInput(tones, x),
        final EnumActionField x => _enumDropdown(tones, x),
        final WalletRefActionField x => _walletDropdown(tones, x),
        final PartyRefActionField x => _partyDropdown(tones, x),
        final NumberActionField x => _numberInput(tones, x),
        final DateTimeActionField x => _datetimeField(tones, x),
        final CategoriesActionField x => _categoryChips(tones, x),
        final TextActionField x => _textInput(tones, x),
      };

  Widget _enumDropdown(AppTones tones, EnumActionField f) => _dropdown<String>(
        value: _edited[f.key]?.toString(),
        items: f.options
            .map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(_cap(o), style: TextStyle(fontSize: 12.sp)),
                ))
            .toList(),
        onChanged: (v) => setState(() => _edited[f.key] = v),
      );

  Widget _walletDropdown(AppTones tones, WalletRefActionField f) {
    final wallets =
        context.watch<WalletCubit>().state.wallets.where((w) => w.id != null);
    return _dropdown<int>(
      value: _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null,
      items: wallets
          .map((w) => DropdownMenuItem(
                value: w.id!,
                child: Text(w.name,
                    style: TextStyle(fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: (v) => setState(() => _edited[f.key] = v),
    );
  }

  Widget _partyDropdown(AppTones tones, PartyRefActionField f) {
    final parties =
        context.watch<PartyCubit>().state.parties.where((p) => p.id != null);
    return _dropdown<int?>(
      value: _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null,
      items: [
        DropdownMenuItem<int?>(
          value: null,
          child: Text(LocaleKeys.none.tr(), style: TextStyle(fontSize: 12.sp)),
        ),
        ...parties.map((p) => DropdownMenuItem<int?>(
              value: p.id!,
              child: Text(p.name,
                  style: TextStyle(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis),
            )),
      ],
      onChanged: (v) => setState(() => _edited[f.key] = v),
    );
  }

  Widget _numberInput(AppTones tones, NumberActionField f) => TextFormField(
        initialValue: _edited[f.key]?.toString() ?? '',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
        decoration: _inputDecoration(tones),
        onChanged: (v) => _edited[f.key] = num.tryParse(v) ?? v,
      );

  Widget _textInput(AppTones tones, TextActionField f) => TextFormField(
        initialValue: _edited[f.key]?.toString() ?? '',
        style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
        decoration: _inputDecoration(tones),
        onChanged: (v) => _edited[f.key] = v,
      );

  Widget _categoryChips(AppTones tones, CategoriesActionField f) {
    final selected = (_edited[f.key] as List?)?.cast<int>() ?? <int>[];
    final categories = context
        .watch<CategoryCubit>()
        .state
        .categories
        .where((c) => c.id != null)
        .toList();
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: categories.map((c) {
        final isSel = selected.contains(c.id);
        return FilterChip(
          label: Text(c.name, style: TextStyle(fontSize: 11.sp)),
          selected: isSel,
          onSelected: (v) {
            setState(() {
              final list = List<int>.from(selected);
              if (v) {
                list.add(c.id!);
              } else {
                list.remove(c.id);
              }
              _edited[f.key] = list;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _datetimeField(AppTones tones, DateTimeActionField f) {
    final raw = _edited[f.key]?.toString() ?? '';
    final dt = DateTime.tryParse(raw);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final base = dt ?? now;
        final date = await showDatePicker(
          context: context,
          initialDate: base,
          firstDate: DateTime(2000),
          lastDate: DateTime(now.year + 1),
        );
        if (date == null || !mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(base),
        );
        final picked = DateTime(date.year, date.month, date.day,
            time?.hour ?? base.hour, time?.minute ?? base.minute);
        setState(() => _edited[f.key] = _isoLocal(picked));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dt != null ? _fmt(dt) : '—',
                style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 14.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final tones = context.tones;
    final safeValue = items.any((it) => it.value == value) ? value : null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: DropdownButton<T>(
        value: safeValue,
        isExpanded: true,
        isDense: true,
        underline: const SizedBox.shrink(),
        style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDecoration(AppTones tones) => InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
      );

  Widget _readonlyField(AppTones tones, ActionField f) {
    final display = (f.display != null && f.display!.isNotEmpty)
        ? f.display!
        : '${f.value ?? ''}';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(f.label,
                style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Text(
              display,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: tones.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    AppTones tones, {
    required String label,
    required bool filled,
    required bool busy,
    required VoidCallback? onTap,
  }) {
    final fg = filled ? Colors.white : tones.textPrimary;
    return Material(
      color: filled ? tones.brand.deep : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 38.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: filled ? null : Border.all(color: tones.borderLight),
          ),
          child: busy
              ? SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
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

class _EmptyState extends StatefulWidget {
  final void Function(String) onPick;
  final ChatSessionDto? recentSession;
  final VoidCallback onContinue;
  const _EmptyState({
    required this.onPick,
    required this.onContinue,
    this.recentSession,
  });

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _resumeDismissed = false;
  int _statIndex = 0;

  int _spotlightIndex = 0;
  Timer? _spotlightTimer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _spotlightTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _spotlightIndex++);
    });
  }

  @override
  void dispose() {
    _spotlightTimer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return LocaleKeys.aiGreetingMorning.tr();
    if (hour < 17) return LocaleKeys.aiGreetingAfternoon.tr();
    return LocaleKeys.aiGreetingEvening.tr();
  }

  /// Staggered fade + rise entrance animation for landing sections.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.07).clamp(0.0, 0.5);
    final anim = CurvedAnimation(
      parent: _anim,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 14.h * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final firstName =
        context.watch<AuthCubit>().state.user?.firstName.trim() ?? '';
    final greeting =
        firstName.isEmpty ? _greeting() : '${_greeting()}, $firstName';

    final suggestions = <String>[
      LocaleKeys.aiSuggestSpendMonth.tr(),
      LocaleKeys.aiSuggestTopCategory.tr(),
      LocaleKeys.aiSuggestIncomeVsExpense.tr(),
      LocaleKeys.aiSuggestBalance.tr(),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      children: [
        SizedBox(height: 8.h),
        _stagger(0, _hero(tones)),
        SizedBox(height: 20.h),
        _stagger(
          1,
          Text(
            greeting,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _stagger(
          2,
          Text(
            LocaleKeys.aiChatEmptyHint.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        _stagger(3, _statsCard(context)),
        if (widget.recentSession != null && !_resumeDismissed) ...[
          SizedBox(height: 20.h),
          _stagger(4, _resumeOptions(tones)),
        ],
        SizedBox(height: 24.h),
        ...suggestions.asMap().entries.map(
              (e) => _stagger(
                5 + e.key,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _suggestionChip(tones, e.value),
                ),
              ),
            ),
      ],
    );
  }

  Widget _hero(AppTones tones) {
    return Center(
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
        child: Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 34.r,
        ),
      ),
    );
  }

  /// Compact, vertically-stacked resume options shown under the stats slider.
  Widget _resumeOptions(AppTones tones) {
    final rawTitle = widget.recentSession?.title?.trim() ?? '';
    final title = rawTitle.isEmpty ? LocaleKeys.aiChatUntitled.tr() : rawTitle;
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: tones.textMuted, fontSize: 11.sp),
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiContinueSession.tr(),
          icon: Icons.history_rounded,
          filled: true,
          onTap: widget.onContinue,
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiStartNewSession.tr(),
          icon: Icons.add_rounded,
          filled: false,
          onTap: () => setState(() => _resumeDismissed = true),
        ),
      ],
    );
  }

  Widget _pillButton(
    AppTones tones, {
    required String label,
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    final fg = filled ? Colors.white : tones.textPrimary;
    return Center(
      child: Material(
        color: filled ? tones.brand.deep : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: filled ? null : Border.all(color: tones.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.sp, color: fg),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _suggestionChip(AppTones tones, String q) {
    return InkWell(
      onTap: () => widget.onPick(q),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: tones.bgCard,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, size: 16.sp, color: tones.brand.deep),
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
            Icon(Icons.arrow_outward_rounded,
                size: 14.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  /// An auto-playing carousel of "this month" insights, computed client-side
  /// from the existing transaction data (same source the dashboard uses).
  Widget _statsCard(BuildContext context) {
    final tones = context.tones;
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (a, b) => a.transactions != b.transactions,
      builder: (context, txState) {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1);
        final monthTx = txState.transactions.where((tx) {
          final d = tx.transaction.datetime;
          return !d.isBefore(monthStart) && d.isBefore(monthEnd);
        }).toList();

        final exchangeRate = context.watch<ExchangeRateCubit>().state.entity;
        final currencySymbol =
            context.watch<CurrencyCubit>().state.currency?.symbol ?? '';
        final totals =
            calculateIncomeExpense(monthTx, exchangeRateEntity: exchangeRate);
        final income = totals.totalIncome;
        final expense = totals.totalExpense;
        final net = income - expense;
        final savingsRate =
            income > 0 ? ((income - expense) / income * 100) : 0.0;
        final expenseCount = monthTx
            .where((t) => t.transaction.type == TransactionType.expense)
            .length;
        final avgExpense = expenseCount > 0 ? expense / expenseCount : 0.0;
        final hasData = income != 0 || expense != 0;

        String money(double v) =>
            '$currencySymbol ${CurrencyFormater.formatAmount(context, v, compact: true)}';

        if (!hasData) {
          return _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statHeader(tones),
                SizedBox(height: 12.h),
                Text(
                  LocaleKeys.aiLandingNoData.tr(),
                  style: TextStyle(
                    color: tones.textSecondary,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }

        final panels = <Widget>[
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statHeader(tones),
                SizedBox(height: 4.h),
                Expanded(
                  child: DashboardExpenses(
                    totalIncome: income,
                    totalExpense: expense,
                    currencySymbol: currencySymbol,
                  ),
                ),
              ],
            ),
          ),
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statHeader(tones),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatNetFlow.tr(), money(net),
                    net >= 0 ? tones.income.deep : tones.expense.deep),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatSaved.tr(),
                    '${savingsRate.toStringAsFixed(0)}%', tones.brand.deep),
              ],
            ),
          ),
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statHeader(tones),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatTransactions.tr(),
                    '${monthTx.length}', tones.brand.deep),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatAvgExpense.tr(),
                    money(avgExpense), tones.expense.deep),
              ],
            ),
          ),
        ];

        final spotlights = _buildSpotlights(
          savingsRate: savingsRate,
          expense: expense,
          net: net,
          txCount: monthTx.length,
          avgExpense: avgExpense,
          money: money,
        );

        return Column(
          children: [
            CarouselSlider(
              items: panels,
              options: CarouselOptions(
                height: 270.h,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                autoPlayCurve: Curves.easeInOutCubic,
                onPageChanged: (i, _) => setState(() => _statIndex = i),
              ),
            ),
            SizedBox(height: 12.h),
            AnimatedSmoothIndicator(
              activeIndex: _statIndex,
              count: panels.length,
              effect: ExpandingDotsEffect(
                activeDotColor: tones.brand.deep,
                dotColor: tones.borderLight,
                dotWidth: 7.w,
                dotHeight: 7.w,
                expansionFactor: 3,
                spacing: 5.w,
              ),
            ),
            if (spotlights.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _spotlightTicker(tones, spotlights),
            ],
          ],
        );
      },
    );
  }

  List<({String text, String prompt})> _buildSpotlights({
    required double savingsRate,
    required double expense,
    required double net,
    required int txCount,
    required double avgExpense,
    required String Function(double) money,
  }) {
    return <({String text, String prompt})>[
      if (savingsRate > 0)
        (
          text: LocaleKeys.aiSpotlightSaved
              .tr(namedArgs: {'rate': savingsRate.toStringAsFixed(0)}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        ),
      if (expense > 0)
        (
          text: LocaleKeys.aiSpotlightSpent
              .tr(namedArgs: {'amount': money(expense)}),
          prompt: LocaleKeys.aiSuggestSpendMonth.tr(),
        ),
      if (net > 0)
        (
          text: LocaleKeys.aiSpotlightNetPositive
              .tr(namedArgs: {'amount': money(net)}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        )
      else if (net < 0)
        (
          text: LocaleKeys.aiSpotlightNetNegative
              .tr(namedArgs: {'amount': money(net.abs())}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        ),
      if (txCount > 0)
        (
          text: LocaleKeys.aiSpotlightTransactions
              .tr(namedArgs: {'count': '$txCount'}),
          prompt: LocaleKeys.aiSuggestSpendMonth.tr(),
        ),
      if (avgExpense > 0)
        (
          text: LocaleKeys.aiSpotlightAvgExpense
              .tr(namedArgs: {'amount': money(avgExpense)}),
          prompt: LocaleKeys.aiSuggestTopCategory.tr(),
        ),
    ];
  }

  Widget _spotlightTicker(
    AppTones tones,
    List<({String text, String prompt})> items,
  ) {
    final current = items[_spotlightIndex % items.length];
    return GestureDetector(
      onTap: () => widget.onPick(current.prompt),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: tones.brand.deep.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                size: 16.sp, color: tones.brand.deep),
            SizedBox(width: 10.w),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: Text(
                  current.text,
                  key: ValueKey(_spotlightIndex % items.length),
                  style: TextStyle(
                    color: tones.textSecondary,
                    fontSize: 13.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPanel(AppTones tones, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: child,
    );
  }

  Widget _statHeader(AppTones tones) {
    return Row(
      children: [
        Icon(Icons.insights_rounded, size: 16.sp, color: tones.brand.deep),
        SizedBox(width: 8.w),
        Text(
          LocaleKeys.thisMonth.tr(),
          style: TextStyle(
            color: tones.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _bigStat(AppTones tones, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: tones.textMuted,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Composer extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool isSending;
  final void Function(String text, List<File> files, String? documentType)
      onSend;

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
  final List<File> _files = [];
  String? _documentType;

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

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isEmpty && _files.isEmpty) return;
    widget.onSend(text, List.of(_files), _documentType);
    setState(() {
      _files.clear();
      _documentType = null;
    });
  }

  Future<void> _openAttachSheet() async {
    final tones = context.tones;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tones.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        Future<void> pick(
          Future<File?> Function() picker,
          String? documentType,
        ) async {
          final file = await picker();
          if (file == null) return;
          if (sheetContext.mounted) Navigator.pop(sheetContext);
          if (!mounted) return;
          setState(() {
            _files.add(file);
            if (documentType != null) _documentType = documentType;
          });
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: tones.borderLight,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.importScanDocument.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ImportSourceButton(
                  icon: Icons.account_balance_outlined,
                  label: LocaleKeys.importDocBankStatement.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () =>
                      pick(ImportFilePicker.pickDocument, 'bank_statement'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.receipt_long_outlined,
                  label: LocaleKeys.importDocReceipt.tr(),
                  subtitle: LocaleKeys.importSourceCameraDesc.tr(),
                  onTap: () =>
                      pick(ImportFilePicker.captureFromCamera, 'receipt'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.description_outlined,
                  label: LocaleKeys.importDocInvoice.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickDocument, 'invoice'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.photo_library_outlined,
                  label: LocaleKeys.importSourceGallery.tr(),
                  subtitle: LocaleKeys.importSourceGalleryDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickFromGallery, null),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.folder_outlined,
                  label: LocaleKeys.importSourceFile.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickDocument, null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final canSend = (_hasText || _files.isNotEmpty) && !widget.isSending;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_files.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: List.generate(_files.length, (i) {
                    return _AttachmentPreview(
                      file: _files[i],
                      onRemove: () => setState(() {
                        _files.removeAt(i);
                        if (_files.isEmpty) _documentType = null;
                      }),
                    );
                  }),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: tones.bgSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: tones.borderLight),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: _AttachButton(onTap: _openAttachSheet),
                  ),
                  SizedBox(width: 1.w),
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
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
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
                      onTap: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A square preview tile for a pending attachment: an image thumbnail or a
/// document card (file-type icon + extension), with an overlaid remove button
/// and a filename caption.
class _AttachmentPreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  const _AttachmentPreview({required this.file, required this.onRemove});

  static const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'bmp'};

  String get _name =>
      file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : 'file';

  String get _ext {
    final dot = _name.lastIndexOf('.');
    return dot == -1 ? '' : _name.substring(dot + 1).toLowerCase();
  }

  IconData get _docIcon => switch (_ext) {
        'pdf' => Icons.picture_as_pdf_rounded,
        'csv' || 'xls' || 'xlsx' => Icons.table_chart_rounded,
        'doc' || 'docx' || 'txt' || 'rtf' => Icons.description_rounded,
        _ => Icons.insert_drive_file_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final size = 60.r;
    final isImage = _imageExts.contains(_ext);

    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: isImage
                      ? Image.file(
                          file,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _docTile(tones),
                        )
                      : _docTile(tones),
                ),
              ),
              Positioned(
                top: 3.r,
                right: 3.r,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 12.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            _name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9.sp, color: tones.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _docTile(AppTones tones) {
    return Container(
      color: tones.bgCard,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_docIcon, size: 22.sp, color: tones.brand.deep),
          if (_ext.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              _ext.toUpperCase(),
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                color: tones.textMuted,
              ),
            ),
          ],
        ],
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
                    Icons.send_rounded,
                    color: enabled ? Colors.white : tones.textMuted,
                    size: 16.sp,
                  ),
          ),
        ),
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AttachButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: tones.bgCard,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20.sp,
            color: tones.textSecondary,
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
