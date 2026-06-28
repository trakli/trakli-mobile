import 'dart:async';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
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
