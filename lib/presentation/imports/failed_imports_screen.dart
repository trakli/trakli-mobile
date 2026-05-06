import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/widgets/picker_with_hint.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_auto_complete_search.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class FailedImportsScreen extends StatefulWidget {
  final int importId;
  const FailedImportsScreen({super.key, required this.importId});

  @override
  State<FailedImportsScreen> createState() => _FailedImportsScreenState();
}

class _FailedImportsScreenState extends State<FailedImportsScreen> {
  final Map<int, FailedImportEntity> _edits = {};

  /// Tracks which row id sets we've already auto-matched against, so we only
  /// pre-fill IDs once even as the underlying cubits emit.
  final Set<String> _autoMatchedKeys = {};

  bool _autoCreateWallets = false;
  bool _autoCreateParties = false;
  bool _autoCreateCategories = false;

  @override
  void initState() {
    super.initState();
    context.read<ImportCubit>().loadFailedImports(widget.importId);
    context.read<WalletCubit>().loadWallets();
    context.read<PartyCubit>().getParties();
    context.read<CategoryCubit>().loadCategories();
  }

  void _maybeAutoMatch(List<FailedImportEntity> rows) {
    final wallets = context.read<WalletCubit>().state.wallets;
    final parties = context.read<PartyCubit>().state.parties;
    final categories = context.read<CategoryCubit>().state.categories;
    if (wallets.isEmpty && parties.isEmpty && categories.isEmpty) return;

    final key = '${rows.map((r) => r.id).join(',')}'
        '|w${wallets.length}|p${parties.length}|c${categories.length}';
    if (_autoMatchedKeys.contains(key)) return;
    _autoMatchedKeys.add(key);

    final newEdits = <int, FailedImportEntity>{};
    for (final base in rows) {
      var entity = _edits[base.id] ?? base;
      var changed = false;

      final walletMatch = _findByName<WalletEntity>(
        wallets,
        entity.wallet,
        (w) => w.name,
      );
      if (entity.walletId == null && walletMatch?.id != null) {
        entity = entity.withWalletId(walletMatch!.id);
        changed = true;
      }

      final partyMatch = _findByName<PartyEntity>(
        parties,
        entity.party,
        (p) => p.name,
      );
      if (entity.partyId == null && partyMatch?.id != null) {
        entity = entity.withPartyId(partyMatch!.id);
        changed = true;
      }

      final categoryMatch = _findByName<CategoryEntity>(
        categories,
        entity.category,
        (c) => c.name,
      );
      if (entity.categoryId == null && categoryMatch?.id != null) {
        entity = entity.withCategoryId(categoryMatch!.id);
        changed = true;
      }

      if (changed) newEdits[base.id] = entity;
    }

    if (newEdits.isEmpty) return;
    setState(() => _edits.addAll(newEdits));
  }

  T? _findByName<T>(List<T> items, String? name, String Function(T) nameOf) {
    final needle = _normalize(name);
    if (needle == null) return null;
    for (final item in items) {
      if (_normalize(nameOf(item)) == needle) return item;
    }
    return null;
  }

  String? _normalize(String? s) {
    final v = s?.trim().toLowerCase();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  Future<void> _onRetryTap() async {
    final cubit = context.read<ImportCubit>();
    final source = cubit.state.failedImports;
    final rows = source.map((r) => _edits[r.id] ?? r).toList();

    final missingWallets = rows.where((r) => r.walletId == null).length;
    final missingParties = rows.where((r) => r.partyId == null).length;
    final missingCategories = rows.where((r) => r.categoryId == null).length;

    final shouldRun = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetCtx) {
        return _ConfirmSheet(
          rowCount: rows.length,
          missingWallets: missingWallets,
          missingParties: missingParties,
          missingCategories: missingCategories,
          initialAutoCreateWallets: _autoCreateWallets,
          initialAutoCreateParties: _autoCreateParties,
          initialAutoCreateCategories: _autoCreateCategories,
          onSubmit: (w, p, c) {
            setState(() {
              _autoCreateWallets = w;
              _autoCreateParties = p;
              _autoCreateCategories = c;
            });
            Navigator.of(sheetCtx).pop(true);
          },
        );
      },
    );

    if (shouldRun != true || !mounted) return;
    await _runRetry(rows);
  }

  Future<void> _runRetry(List<FailedImportEntity> rows) async {
    final cubit = context.read<ImportCubit>();
    final result = await cubit.fixFailedImports(
      widget.importId,
      rows,
      autoCreateWallets: _autoCreateWallets,
      autoCreateParties: _autoCreateParties,
      autoCreateCategories: _autoCreateCategories,
    );
    if (!mounted) return;
    if (result == null) {
      showSnackBar(
        message: cubit.state.failure,
        borderRadius: 8.r,
        backgroundColor: appDangerColor,
        isFloating: false,
      );
      return;
    }
    if (result.allFixed) {
      showSnackBar(
        message: LocaleKeys.importAllRowsFixed.tr(),
        borderRadius: 8.r,
        backgroundColor: Colors.green,
        isFloating: false,
      );
      Navigator.of(context).pop();
    } else {
      showSnackBar(
        message: LocaleKeys.importSomeRowsStillFailed.tr(),
        borderRadius: 8.r,
        backgroundColor: Colors.orange,
        isFloating: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importFailedRows.tr())),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            if (state.isLoading && state.failedImports.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.failedImports.isEmpty) {
              return Center(child: Text(LocaleKeys.importNoFailedRows.tr()));
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _maybeAutoMatch(state.failedImports);
            });

            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: state.failedImports.length,
              itemBuilder: (context, i) {
                final row = state.failedImports[i];
                final edited = _edits[row.id] ?? row;
                return _FailedRowCard(
                  key: ValueKey(row.id),
                  position: i,
                  row: edited,
                  onChanged: (updated) {
                    setState(() => _edits[row.id] = updated);
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: BlocBuilder<ImportCubit, ImportState>(
            builder: (context, state) {
              return SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: state.isConfirming || state.failedImports.isEmpty
                      ? null
                      : _onRetryTap,
                  label: state.isConfirming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(LocaleKeys.importRetryAll.tr()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FailedRowCard extends StatefulWidget {
  final int position;
  final FailedImportEntity row;
  final ValueChanged<FailedImportEntity> onChanged;

  const _FailedRowCard({
    super.key,
    required this.position,
    required this.row,
    required this.onChanged,
  });

  @override
  State<_FailedRowCard> createState() => _FailedRowCardState();
}

class _FailedRowCardState extends State<_FailedRowCard> {
  static const _expandDuration = Duration(milliseconds: 180);
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  late TextEditingController _amount;
  late TextEditingController _desc;
  late TextEditingController _date;
  late TransactionType _type;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    final r = widget.row;
    _amount = TextEditingController(text: r.amount ?? '');
    _desc = TextEditingController(text: r.description ?? '');
    _date = TextEditingController(text: r.date ?? '');
    _type = _parseType(r.type);
  }

  TransactionType _parseType(String? raw) {
    final v = raw?.toLowerCase().trim();
    return v == 'income' ? TransactionType.income : TransactionType.expense;
  }

  String _serializeType(TransactionType t) =>
      t == TransactionType.income ? 'income' : 'expense';

  @override
  void dispose() {
    _amount.dispose();
    _desc.dispose();
    _date.dispose();
    super.dispose();
  }

  void _emitText() {
    widget.onChanged(widget.row.copyWith(
      amount: _amount.text,
      description: _desc.text,
      date: _date.text,
      type: _serializeType(_type),
    ));
  }

  Future<void> _pickDate() async {
    DateTime? initial;
    try {
      if ((widget.row.date ?? '').isNotEmpty) {
        initial = _dateFormat.parseStrict(widget.row.date!);
      }
    } catch (_) {
      initial = null;
    }
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now.subtract(const Duration(days: 3650)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    final formatted = _dateFormat.format(picked);
    _date.text = formatted;
    _emitText();
  }

  String _primaryText() {
    final party = widget.row.party;
    if (party != null && party.isNotEmpty) return party;
    final desc = widget.row.description;
    if (desc != null && desc.isNotEmpty) return desc;
    return '${LocaleKeys.importFailedRows.tr()} #${widget.position + 1}';
  }

  String _amountText() {
    final amount = widget.row.amount;
    if (amount == null || amount.isEmpty) return '—';
    return amount;
  }

  String _metaText() {
    final typeText = switch (_type) {
      TransactionType.income => LocaleKeys.transactionIncome.tr(),
      TransactionType.expense => LocaleKeys.transactionExpense.tr(),
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
            reason: widget.row.reason,
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          AnimatedCrossFade(
            duration: _expandDuration,
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
              child: _editableBody(accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableBody(Color accent) {
    final flagged = _fieldsForReason(widget.row.reason);
    final reason = widget.row.reason;
    // Only show the standalone red banner for catch-all reasons (no specific
    // field flagged). When a field IS flagged, its inline errorText already
    // surfaces the same message — no need for a banner on top.
    final showBanner = reason != null && flagged.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBanner) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: appDangerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: appDangerColor),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(
                      color: appDangerColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: LocaleKeys.importAmount.tr(),
                  isDense: true,
                  errorText: flagged.contains(FailedField.amount) ? reason : null,
                ),
                onChanged: (_) => _emitText(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: DropdownButtonFormField<TransactionType>(
                initialValue: _type,
                isDense: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.importType.tr(),
                  isDense: true,
                  errorText: flagged.contains(FailedField.type) ? reason : null,
                ),
                items: [
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text(LocaleKeys.transactionExpense.tr()),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text(LocaleKeys.transactionIncome.tr()),
                  ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _type = v);
                  _emitText();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: _desc,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDescription.tr(),
            isDense: true,
          ),
          onChanged: (_) => _emitText(),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final wallets =
                state.wallets.where((w) => w.id != null).toList();
            final selected = _findById<WalletEntity>(
              wallets,
              widget.row.walletId,
              (w) => w.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importWallet.tr(),
              suggestionText: widget.row.wallet,
              errorText: flagged.contains(FailedField.wallet) ? reason : null,
              picker: CustomAutoCompleteSearch<WalletEntity>(
                key: ValueKey('wallet_${widget.row.walletId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return wallets;
                  return wallets
                      .where((w) => w.name.toLowerCase().contains(query));
                },
                displayStringForOption: (w) => w.name,
                onSelected: (w) =>
                    widget.onChanged(widget.row.withWalletId(w.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<PartyCubit, PartyState>(
          builder: (context, state) {
            final parties =
                state.parties.where((p) => p.id != null).toList();
            final selected = _findById<PartyEntity>(
              parties,
              widget.row.partyId,
              (p) => p.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importParty.tr(),
              suggestionText: widget.row.party,
              picker: CustomAutoCompleteSearch<PartyEntity>(
                key: ValueKey('party_${widget.row.partyId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return parties;
                  return parties
                      .where((p) => p.name.toLowerCase().contains(query));
                },
                displayStringForOption: (p) => p.name,
                onSelected: (p) =>
                    widget.onChanged(widget.row.withPartyId(p.id)),
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
              widget.row.categoryId,
              (c) => c.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importCategory.tr(),
              suggestionText: widget.row.category,
              picker: CustomAutoCompleteSearch<CategoryEntity>(
                key: ValueKey(
                    'category_${_type.name}_${widget.row.categoryId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return categories;
                  return categories
                      .where((c) => c.name.toLowerCase().contains(query));
                },
                displayStringForOption: (c) => c.name,
                onSelected: (c) =>
                    widget.onChanged(widget.row.withCategoryId(c.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: _date,
          readOnly: true,
          onTap: _pickDate,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDate.tr(),
            hintText: 'YYYY-MM-DD',
            isDense: true,
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            errorText: flagged.contains(FailedField.date) ? reason : null,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String primary;
  final String amount;
  final String meta;
  final String? reason;
  final bool expanded;
  final VoidCallback onTap;

  const _Header({
    required this.primary,
    required this.amount,
    required this.meta,
    required this.reason,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: appDangerColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.error_outline,
                color: appDangerColor,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 10.w),
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
                          reason ?? meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: reason != null
                                ? appDangerColor
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration:
                            _FailedRowCardState._expandDuration,
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

T? _findById<T>(List<T> items, int? id, int? Function(T) idOf) {
  if (id == null) return null;
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}

enum FailedField { amount, type, wallet, date }

/// Maps a server-emitted reason string to the field(s) it implicates. Strings
/// come from `FileImportService.processImports` / `importTransfer`. Substring
/// matching (lowercased) so minor punctuation/translation tweaks don't break
/// the mapping. An empty result means "catch-all" — render the reason as a
/// banner instead of inline.
Set<FailedField> _fieldsForReason(String? reason) {
  if (reason == null || reason.isEmpty) return const {};
  final r = reason.toLowerCase();
  if (r.contains('date must be')) return const {FailedField.date};
  if (r.contains('invalid transaction type')) {
    return const {FailedField.type};
  }
  if (r.contains('-transfer transaction not found')) {
    return const {FailedField.type};
  }
  if (r.contains('no wallets found')) return const {FailedField.wallet};
  if (r.contains('zero send amount')) return const {FailedField.amount};
  return const {};
}

class _ConfirmSheet extends StatefulWidget {
  final int rowCount;
  final int missingWallets;
  final int missingParties;
  final int missingCategories;
  final bool initialAutoCreateWallets;
  final bool initialAutoCreateParties;
  final bool initialAutoCreateCategories;
  final void Function(bool wallets, bool parties, bool categories) onSubmit;

  const _ConfirmSheet({
    required this.rowCount,
    required this.missingWallets,
    required this.missingParties,
    required this.missingCategories,
    required this.initialAutoCreateWallets,
    required this.initialAutoCreateParties,
    required this.initialAutoCreateCategories,
    required this.onSubmit,
  });

  @override
  State<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends State<_ConfirmSheet> {
  late bool _autoCreateWallets = widget.initialAutoCreateWallets;
  late bool _autoCreateParties = widget.initialAutoCreateParties;
  late bool _autoCreateCategories = widget.initialAutoCreateCategories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.importRetryAll.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              '${widget.rowCount} ${LocaleKeys.importFailedRows.tr().toLowerCase()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 16.h),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateWallets.tr(),
              missingCount: widget.missingWallets,
              value: _autoCreateWallets,
              onChanged: (v) => setState(() => _autoCreateWallets = v),
            ),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateParties.tr(),
              missingCount: widget.missingParties,
              value: _autoCreateParties,
              onChanged: (v) => setState(() => _autoCreateParties = v),
            ),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateCategories.tr(),
              missingCount: widget.missingCategories,
              value: _autoCreateCategories,
              onChanged: (v) => setState(() => _autoCreateCategories = v),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () => widget.onSubmit(
                  _autoCreateWallets,
                  _autoCreateParties,
                  _autoCreateCategories,
                ),
                label: Text(LocaleKeys.importRetryAll.tr()),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neutralN40,
                  foregroundColor: neutralN900,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocaleKeys.cancel.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingSwitch extends StatelessWidget {
  final String label;
  final int missingCount;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MissingSwitch({
    required this.label,
    required this.missingCount,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hint = missingCount == 0
        ? LocaleKeys.importAutoCreateNoneNeeded.tr()
        : LocaleKeys.importAutoCreateMissingHint
            .tr(args: [missingCount.toString()]);
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(hint),
      value: value,
      onChanged: missingCount == 0 ? null : onChanged,
    );
  }
}
