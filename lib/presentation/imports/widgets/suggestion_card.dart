import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class SuggestionCard extends StatefulWidget {
  final int position;
  final TransactionSuggestionEntity suggestion;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final ValueChanged<TransactionSuggestionEntity> onChanged;

  const SuggestionCard({
    super.key,
    required this.position,
    required this.suggestion,
    required this.accepted,
    required this.onAcceptedChanged,
    required this.onChanged,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  late TextEditingController _amountCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TransactionType _type;
  bool _expanded = false;

  static const _expandDuration = Duration(milliseconds: 180);

  @override
  void initState() {
    super.initState();
    final s = widget.suggestion;
    _amountCtrl = TextEditingController(text: s.amount?.toString() ?? '');
    _descCtrl = TextEditingController(text: s.description ?? '');
    _dateCtrl = TextEditingController(text: s.date ?? '');
    _type = s.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _emitTextUpdate() {
    widget.onChanged(widget.suggestion.copyWith(
      amount: parseAmount(_amountCtrl.text),
      description: _descCtrl.text,
      date: _dateCtrl.text,
      type: _type,
    ));
  }

  String _primaryText() {
    final party = widget.suggestion.party;
    if (party != null && party.isNotEmpty) return party;
    final desc = widget.suggestion.description;
    if (desc != null && desc.isNotEmpty) return desc;
    return '—';
  }

  String _amountText() {
    final amount = widget.suggestion.amount;
    if (amount == null) return '—';
    return amount.toStringAsFixed(2);
  }

  String _metaText() {
    final typeText = switch (widget.suggestion.type) {
      TransactionType.income => LocaleKeys.transactionIncome.tr(),
      TransactionType.expense => LocaleKeys.transactionExpense.tr(),
      null => '—',
    };
    return '#${widget.position + 1} · $typeText';
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            primary: _primaryText(),
            amount: _amountText(),
            meta: _metaText(),
            accepted: widget.accepted,
            confidence: widget.suggestion.confidence,
            duplicate: widget.suggestion.duplicate,
            expanded: _expanded,
            onAcceptedChanged: widget.onAcceptedChanged,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          AnimatedCrossFade(
            duration: _expandDuration,
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              child: _editableBody(accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableBody(Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: LocaleKeys.importAmount.tr(),
                  isDense: true,
                ),
                onChanged: (_) => _emitTextUpdate(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _PickerWithHint(
                label: LocaleKeys.importType.tr(),
                suggestionText: null,
                picker: CustomDropdownSearch<TransactionType>(
                  label: '',
                  accentColor: accent,
                  selectedItem: _type,
                  showSearchBox: false,
                  items: (filter, _) => const [
                    TransactionType.expense,
                    TransactionType.income,
                  ],
                  itemAsString: (t) => switch (t) {
                    TransactionType.expense =>
                      LocaleKeys.transactionExpense.tr(),
                    TransactionType.income =>
                      LocaleKeys.transactionIncome.tr(),
                  },
                  compareFn: (a, b) => a == b,
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _type = v);
                    _emitTextUpdate();
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _descCtrl,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDescription.tr(),
            isDense: true,
          ),
          onChanged: (_) => _emitTextUpdate(),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final wallets = state.wallets.where((w) => w.id != null).toList();
            final selected = _findById<WalletEntity>(
              wallets,
              widget.suggestion.walletId,
              (w) => w.id,
            );
            return _PickerWithHint(
              label: LocaleKeys.importWallet.tr(),
              suggestionText: widget.suggestion.wallet,
              picker: CustomDropdownSearch<WalletEntity>(
                label: '',
                accentColor: accent,
                selectedItem: selected,
                items: (filter, _) => wallets
                    .where((w) =>
                        w.name.toLowerCase().contains(filter.toLowerCase()))
                    .toList(),
                itemAsString: (w) => w.name,
                compareFn: (a, b) => a.id == b.id,
                onChanged: (w) =>
                    widget.onChanged(widget.suggestion.withWalletId(w?.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<PartyCubit, PartyState>(
          builder: (context, state) {
            final parties = state.parties.where((p) => p.id != null).toList();
            final selected = _findById<PartyEntity>(
              parties,
              widget.suggestion.partyId,
              (p) => p.id,
            );
            return _PickerWithHint(
              label: LocaleKeys.importParty.tr(),
              suggestionText: widget.suggestion.party,
              picker: CustomDropdownSearch<PartyEntity>(
                label: '',
                accentColor: accent,
                selectedItem: selected,
                items: (filter, _) => parties
                    .where((p) =>
                        p.name.toLowerCase().contains(filter.toLowerCase()))
                    .toList(),
                itemAsString: (p) => p.name,
                compareFn: (a, b) => a.id == b.id,
                onChanged: (p) =>
                    widget.onChanged(widget.suggestion.withPartyId(p?.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final categories = state.categories
                .where((c) => c.id != null && c.type == _type)
                .toList();
            final selected = _findById<CategoryEntity>(
              categories,
              widget.suggestion.categoryId,
              (c) => c.id,
            );
            return _PickerWithHint(
              label: LocaleKeys.importCategory.tr(),
              suggestionText: widget.suggestion.category,
              picker: CustomDropdownSearch<CategoryEntity>(
                label: '',
                accentColor: accent,
                selectedItem: selected,
                items: (filter, _) => categories
                    .where((c) =>
                        c.name.toLowerCase().contains(filter.toLowerCase()))
                    .toList(),
                itemAsString: (c) => c.name,
                compareFn: (a, b) => a.id == b.id,
                onChanged: (c) =>
                    widget.onChanged(widget.suggestion.withCategoryId(c?.id)),
              ),
            );
          },
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _dateCtrl,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDate.tr(),
            hintText: 'YYYY-MM-DD',
            isDense: true,
          ),
          onChanged: (_) => _emitTextUpdate(),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String primary;
  final String amount;
  final String meta;
  final bool accepted;
  final double? confidence;
  final bool? duplicate;
  final bool expanded;
  final ValueChanged<bool> onAcceptedChanged;
  final VoidCallback onTap;

  const _Header({
    required this.primary,
    required this.amount,
    required this.meta,
    required this.accepted,
    required this.confidence,
    required this.duplicate,
    required this.expanded,
    required this.onAcceptedChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 4.h, 12.w, 4.h),
        child: Row(
          children: [
            Checkbox(
              value: accepted,
              onChanged: (v) => onAcceptedChanged(v ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          primary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        amount,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (duplicate == true) ...[
                        Icon(Icons.warning_amber_rounded,
                            size: 14.sp, color: Colors.orange),
                        SizedBox(width: 4.w),
                      ],
                      if (confidence != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _confidenceColor(confidence!)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(confidence! * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: _confidenceColor(confidence!),
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: _SuggestionCardState._expandDuration,
                        child: Icon(Icons.keyboard_arrow_down, size: 18.sp),
                      ),
                    ],
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

Color _confidenceColor(double c) {
  if (c >= 0.8) return Colors.green;
  if (c >= 0.5) return Colors.orange;
  return Colors.red;
}

T? _findById<T>(List<T> items, int? id, int? Function(T) idOf) {
  if (id == null) return null;
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}

class _PickerWithHint extends StatelessWidget {
  final String label;
  final String? suggestionText;
  final Widget picker;

  const _PickerWithHint({
    required this.label,
    required this.suggestionText,
    required this.picker,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 4.h),
        picker,
        if (suggestionText != null && suggestionText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              LocaleKeys.importAiSuggested.tr(args: [suggestionText!]),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}
