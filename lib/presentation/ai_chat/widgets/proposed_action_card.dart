import 'dart:async';

import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class ProposedActionCard extends StatefulWidget {
  final ProposedActionBlock block;
  const ProposedActionCard({super.key, required this.block});

  @override
  State<ProposedActionCard> createState() => ProposedActionCardState();
}

class ProposedActionCardState extends State<ProposedActionCard> {
  final Map<String, dynamic> _edited = {};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.block.fields) {
      _edited[f.key] = f is CategoriesActionField
          ? (f.initialIds.isEmpty ? const <int>[] : <int>[f.initialIds.first])
          : f.value;
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

  Color _accent(AppTones tones) =>
      widget.block.risk == 'high' ? tones.accentWarm : tones.brand.deep;

  /// Wallet type (bank / cash / credit_card / mobile) as a dropdown.
  Widget _walletTypeInput(AppTones tones, WalletTypeActionField f) {
    final current = _edited[f.key]?.toString();
    return CustomDropdownSearch<WalletType>(
      label: "",
      accentColor: _accent(tones),
      selectedItem:
          WalletType.values.firstWhereOrNull((w) => w.serverKey == current),
      showSearchBox: false,
      items: (filter, infiniteScrollProps) => WalletType.values,
      itemAsString: (w) => w.customName,
      onChanged: (v) => setState(() => _edited[f.key] = v?.serverKey),
      compareFn: (i1, i2) => i1 == i2,
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
        final CategoriesActionField x => _categoryDropdown(tones, x),
        final TextActionField x => _textInput(tones, x),
      };

  Widget _enumDropdown(AppTones tones, EnumActionField f) =>
      CustomDropdownSearch<String>(
        label: "",
        accentColor: _accent(tones),
        selectedItem: f.options.contains(_edited[f.key]?.toString())
            ? _edited[f.key].toString()
            : null,
        showSearchBox: false,
        items: (filter, infiniteScrollProps) => f.options,
        itemAsString: _cap,
        onChanged: (v) => setState(() => _edited[f.key] = v),
        compareFn: (i1, i2) => i1 == i2,
      );

  Widget _walletDropdown(AppTones tones, WalletRefActionField f) {
    final wallets = context
        .watch<WalletCubit>()
        .state
        .wallets
        .where((w) => w.id != null)
        .toList();
    final currentId =
        _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null;
    return CustomDropdownSearch<WalletEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: wallets.firstWhereOrNull((w) => w.id == currentId),
      showSearchBox: false,
      items: (filter, infiniteScrollProps) => wallets,
      itemAsString: (w) => w.name,
      onChanged: (v) => setState(() => _edited[f.key] = v?.id),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
    );
  }

  Widget _partyDropdown(AppTones tones, PartyRefActionField f) {
    final parties = context
        .watch<PartyCubit>()
        .state
        .parties
        .where((p) => p.id != null)
        .toList();
    final currentId =
        _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null;
    return CustomDropdownSearch<PartyEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: parties.firstWhereOrNull((p) => p.id == currentId),
      showClearButton: true,
      items: (filter, infiniteScrollProps) => parties,
      itemAsString: (p) => p.name,
      onChanged: (v) => setState(() => _edited[f.key] = v?.id),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
      filterFn: (p, filter) =>
          p.name.toLowerCase().contains(filter.toLowerCase()),
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

  /// Single category as a dropdown; stored as a one-element list so the
  /// overrides payload shape stays unchanged.
  Widget _categoryDropdown(AppTones tones, CategoriesActionField f) {
    final selected = (_edited[f.key] as List?)?.cast<int>() ?? const <int>[];
    final categories = context
        .watch<CategoryCubit>()
        .state
        .categories
        .where((c) => c.id != null)
        .toList();
    return CustomDropdownSearch<CategoryEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: selected.isEmpty
          ? null
          : categories.firstWhereOrNull((c) => c.id == selected.first),
      showClearButton: true,
      items: (filter, infiniteScrollProps) => categories,
      itemAsString: (c) => c.name,
      onChanged: (v) => setState(() =>
          _edited[f.key] = v?.id == null ? const <int>[] : <int>[v!.id!]),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
      filterFn: (c, filter) =>
          c.name.toLowerCase().contains(filter.toLowerCase()),
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
