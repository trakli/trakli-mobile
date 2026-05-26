import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showSnackBar;
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class AddBudgetScreen extends StatefulWidget {
  final BudgetEntity? budget;
  const AddBudgetScreen({super.key, this.budget});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _currency;
  late final TextEditingController _description;

  late BudgetPeriodType _periodType;
  late DateTime _startDate;
  DateTime? _endDate;
  late int _threshold;
  late bool _rolloverEnabled;
  late bool _forecastAlertsEnabled;
  late bool _isActive;
  late List<BudgetTargetSelection> _targets;

  bool get _isEdit => widget.budget != null;

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    _name = TextEditingController(text: b?.name ?? '');
    _amount = TextEditingController(text: b?.amount.toStringAsFixed(2) ?? '');
    _currency = TextEditingController(text: b?.currency ?? 'USD');
    _description = TextEditingController(text: b?.description ?? '');
    _periodType = b?.periodType ?? BudgetPeriodType.monthly;
    _startDate = b?.startDate ?? DateTime.now();
    _endDate = b?.endDate;
    _threshold = b?.thresholdPercent ?? 80;
    _rolloverEnabled = b?.rolloverEnabled ?? false;
    _forecastAlertsEnabled = b?.forecastAlertsEnabled ?? false;
    _isActive = b?.isActive ?? true;
    _targets = b?.targets
            .where((t) => t.clientId != null)
            .map((t) =>
                BudgetTargetSelection(type: t.type, clientId: t.clientId!))
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _currency.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : (_endDate ?? _startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickTargets() async {
    final result = await showModalBottomSheet<List<BudgetTargetSelection>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TargetPickerSheet(initial: _targets),
    );
    if (result != null) {
      setState(() => _targets = result);
    }
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showSnackBar(message: LocaleKeys.budgetNameRequired.tr());
      return;
    }
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      showSnackBar(message: LocaleKeys.budgetAmountRequired.tr());
      return;
    }
    final currency = _currency.text.trim().toUpperCase();
    if (currency.length != 3) {
      showSnackBar(message: LocaleKeys.budgetCurrencyRequired.tr());
      return;
    }

    final cubit = context.read<BudgetCubit>();
    if (_isEdit) {
      await cubit.updateBudget(
        widget.budget!.clientId,
        name: name,
        amount: amount,
        currency: currency,
        periodType: _periodType,
        startDate: _startDate,
        endDate: _endDate,
        description:
            _description.text.trim().isEmpty ? null : _description.text.trim(),
        rolloverEnabled: _rolloverEnabled,
        thresholdPercent: _threshold,
        forecastAlertsEnabled: _forecastAlertsEnabled,
        isActive: _isActive,
        targets: _targets,
      );
    } else {
      await cubit.addBudget(
        name: name,
        amount: amount,
        currency: currency,
        periodType: _periodType,
        startDate: _startDate,
        endDate: _endDate,
        description:
            _description.text.trim().isEmpty ? null : _description.text.trim(),
        rolloverEnabled: _rolloverEnabled,
        thresholdPercent: _threshold,
        forecastAlertsEnabled: _forecastAlertsEnabled,
        isActive: _isActive,
        targets: _targets,
      );
    }
    if (!mounted) return;
    AppNavigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: AppBar(
        title: Text(_isEdit ? LocaleKeys.editBudget.tr() : LocaleKeys.newBudget.tr()),
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(text: LocaleKeys.name.tr()),
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.nameHint.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _SectionLabel(text: LocaleKeys.amount.tr()),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _amount,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: LocaleKeys.amountHint.tr(),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: _currency,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 3,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _SectionLabel(text: LocaleKeys.period.tr()),
                    _PeriodChips(
                      selected: _periodType,
                      onChange: (p) => setState(() => _periodType = p),
                    ),
                    SizedBox(height: 14.h),
                    _SectionLabel(text: LocaleKeys.startDate.tr()),
                    _DateRow(
                      date: _startDate,
                      onTap: () => _pickDate(isStart: true),
                    ),
                    if (_periodType == BudgetPeriodType.custom) ...[
                      SizedBox(height: 14.h),
                      _SectionLabel(text: LocaleKeys.endDate.tr()),
                      _DateRow(
                        date: _endDate,
                        onTap: () => _pickDate(isStart: false),
                        placeholder: LocaleKeys.selectEndDate.tr(),
                      ),
                    ],
                    SizedBox(height: 14.h),
                    _SectionLabel(text: LocaleKeys.targets.tr()),
                    InkWell(
                      onTap: _pickTargets,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: tones.borderLight),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _targets.isEmpty
                                    ? LocaleKeys.budgetTargetsApplyAll.tr()
                                    : '${_targets.length} ${_targets.length == 1 ? LocaleKeys.target.tr() : LocaleKeys.targets.tr()} ${LocaleKeys.selected.tr()}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: _targets.isEmpty
                                      ? tones.textMuted
                                      : tones.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 20.sp,
                              color: tones.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _SectionLabel(
                      text: LocaleKeys.alertAtThreshold.tr().replaceFirst('{0}', '$_threshold'),
                    ),
                    Slider(
                      value: _threshold.toDouble(),
                      min: 50,
                      max: 100,
                      divisions: 10,
                      label: '$_threshold%',
                      onChanged: (v) => setState(() => _threshold = v.toInt()),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(LocaleKeys.budgetRollover.tr()),
                      subtitle: Text(LocaleKeys.budgetRolloverDescription.tr()),
                      value: _rolloverEnabled,
                      onChanged: (v) => setState(() => _rolloverEnabled = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(LocaleKeys.budgetForecastAlerts.tr()),
                      subtitle: Text(LocaleKeys.budgetForecastAlertsDescription.tr()),
                      value: _forecastAlertsEnabled,
                      onChanged: (v) =>
                          setState(() => _forecastAlertsEnabled = v),
                    ),
                    if (_isEdit)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(LocaleKeys.active.tr()),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                    SizedBox(height: 14.h),
                    _SectionLabel(text: LocaleKeys.description.tr()),
                    TextField(
                      controller: _description,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
                  decoration: BoxDecoration(
                    color: tones.bgPage,
                    border: Border(
                      top: BorderSide(color: tones.borderLight),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: FilledButton(
                      onPressed: state.isSaving ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, 48.h),
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEdit ? LocaleKeys.saveChanges.tr() : LocaleKeys.createBudget.tr()),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: context.tones.textSecondary,
        ),
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  final BudgetPeriodType selected;
  final ValueChanged<BudgetPeriodType> onChange;
  const _PeriodChips({required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    Widget chip(BudgetPeriodType type, String label) {
      final active = type == selected;
      return GestureDetector(
        onTap: () => onChange(type),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            color: active ? tones.brand.accent : tones.bgSurface,
            border: Border.all(
              color: active ? tones.brand.accent : tones.borderLight,
            ),
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : tones.textSecondary,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(BudgetPeriodType.weekly, LocaleKeys.periodWeekly.tr()),
          chip(BudgetPeriodType.monthly, LocaleKeys.periodMonthly.tr()),
          chip(BudgetPeriodType.yearly, LocaleKeys.periodYearly.tr()),
          chip(BudgetPeriodType.custom, LocaleKeys.periodCustom.tr()),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  final String placeholder;
  const _DateRow({
    required this.date,
    required this.onTap,
    this.placeholder = 'Select date',
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final displayPlaceholder = placeholder == 'Select date'
        ? LocaleKeys.selectDate.tr()
        : placeholder;
    final label = date == null
        ? displayPlaceholder
        : '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: tones.borderLight),
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18.sp,
              color: tones.textMuted,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: date == null ? tones.textMuted : tones.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetPickerSheet extends StatefulWidget {
  final List<BudgetTargetSelection> initial;
  const _TargetPickerSheet({required this.initial});

  @override
  State<_TargetPickerSheet> createState() => _TargetPickerSheetState();
}

class _TargetPickerSheetState extends State<_TargetPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late Set<String> _selectedKeys;

  String _key(BudgetTargetType t, String clientId) => '${t.name}::$clientId';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _selectedKeys = widget.initial.map((t) => _key(t.type, t.clientId)).toSet();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _toggle(BudgetTargetType type, String clientId) {
    final key = _key(type, clientId);
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
      } else {
        _selectedKeys.add(key);
      }
    });
  }

  void _confirm() {
    final selections = _selectedKeys.map((k) {
      final parts = k.split('::');
      final type =
          BudgetTargetType.tryParse(parts[0]) ?? BudgetTargetType.category;
      return BudgetTargetSelection(type: type, clientId: parts[1]);
    }).toList();
    Navigator.of(context).pop(selections);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.selectTargets.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(onPressed: _confirm, child: Text(LocaleKeys.done.tr())),
                ],
              ),
            ),
            TabBar(
              controller: _tabs,
              tabs: [
                Tab(text: LocaleKeys.categories.tr()),
                Tab(text: LocaleKeys.wallets.tr()),
                Tab(text: LocaleKeys.groups.tr()),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _CategoryList(
                    selectedKeys: _selectedKeys,
                    onToggle: (id) => _toggle(BudgetTargetType.category, id),
                    scrollController: scrollController,
                  ),
                  _WalletList(
                    selectedKeys: _selectedKeys,
                    onToggle: (id) => _toggle(BudgetTargetType.wallet, id),
                    scrollController: scrollController,
                  ),
                  _GroupList(
                    selectedKeys: _selectedKeys,
                    onToggle: (id) => _toggle(BudgetTargetType.group, id),
                    scrollController: scrollController,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  final Set<String> selectedKeys;
  final ValueChanged<String> onToggle;
  final ScrollController scrollController;
  const _CategoryList({
    required this.selectedKeys,
    required this.onToggle,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final items = state.categories;
        if (items.isEmpty) {
          return Center(child: Text(LocaleKeys.noCategoriesYet.tr()));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (_, i) => _TargetTile<CategoryEntity>(
            label: items[i].name,
            selected: selectedKeys.contains('category::${items[i].clientId}'),
            onToggle: () => onToggle(items[i].clientId),
          ),
        );
      },
    );
  }
}

class _WalletList extends StatelessWidget {
  final Set<String> selectedKeys;
  final ValueChanged<String> onToggle;
  final ScrollController scrollController;
  const _WalletList({
    required this.selectedKeys,
    required this.onToggle,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final items = state.wallets;
        if (items.isEmpty) {
          return Center(child: Text(LocaleKeys.noWalletsYet.tr()));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (_, i) => _TargetTile<WalletEntity>(
            label: items[i].name,
            selected: selectedKeys.contains('wallet::${items[i].clientId}'),
            onToggle: () => onToggle(items[i].clientId),
          ),
        );
      },
    );
  }
}

class _GroupList extends StatelessWidget {
  final Set<String> selectedKeys;
  final ValueChanged<String> onToggle;
  final ScrollController scrollController;
  const _GroupList({
    required this.selectedKeys,
    required this.onToggle,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        final items = state.groups;
        if (items.isEmpty) {
          return Center(child: Text(LocaleKeys.noGroupsYet.tr()));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (_, i) => _TargetTile<GroupEntity>(
            label: items[i].name,
            selected: selectedKeys.contains('group::${items[i].clientId}'),
            onToggle: () => onToggle(items[i].clientId),
          ),
        );
      },
    );
  }
}

class _TargetTile<T> extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onToggle;
  const _TargetTile({
    required this.label,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      onChanged: (_) => onToggle(),
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
