import 'dart:async';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/info_sheet.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AddHoldingScreen extends StatefulWidget {
  final HoldingEntity? holding;

  const AddHoldingScreen({super.key, this.holding});

  @override
  State<AddHoldingScreen> createState() => _AddHoldingScreenState();
}

class _AddHoldingScreenState extends State<AddHoldingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _coinSearchController = TextEditingController();

  HoldingPriceSource _priceSource = HoldingPriceSource.manual;
  String _currencyCode = 'USD';
  String? _externalRef;
  String? _provider;
  Timer? _debounce;

  bool get _isEditing => widget.holding != null;

  @override
  void initState() {
    super.initState();
    final h = widget.holding;
    if (h != null) {
      _nameController.text = h.name;
      _symbolController.text = h.symbol ?? '';
      _quantityController.text = h.quantity.toString();
      _unitPriceController.text = h.unitPrice.toString();
      _priceSource = h.priceSource;
      _currencyCode = h.currency;
      _externalRef = h.externalRef;
      _provider = h.provider;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _coinSearchController.dispose();
    super.dispose();
  }

  void _onCoinSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<HoldingCubit>().searchCoins(query);
    });
  }

  void _selectCoin(coin) {
    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = coin.name;
      }
      _symbolController.text = coin.symbol;
      _externalRef = coin.id;
      _provider = 'coingecko';
      _coinSearchController.text = '${coin.name} (${coin.symbol.toUpperCase()})';
    });
    context.read<HoldingCubit>().clearCoinResults();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_priceSource.isAuto && (_externalRef == null || _externalRef!.isEmpty)) {
      showSnackBar(message: LocaleKeys.holdingSelectCoinRequired.tr());
      return;
    }

    final draft = HoldingDraft(
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim().isEmpty
          ? null
          : _symbolController.text.trim(),
      quantity: double.tryParse(_quantityController.text.trim()) ?? 0,
      currency: _currencyCode,
      unitPrice: _priceSource.isAuto
          ? null
          : double.tryParse(_unitPriceController.text.trim()),
      priceSource: _priceSource,
      provider: _priceSource.isAuto ? _provider : null,
      externalRef: _priceSource.isAuto ? _externalRef : null,
    );

    final cubit = context.read<HoldingCubit>();
    final ok = _isEditing
        ? await cubit.editHolding(widget.holding!.id, draft)
        : await cubit.addHolding(draft);

    if (ok && mounted) {
      showSnackBar(message: LocaleKeys.holdingSaved.tr(), isSuccess: true);
      Navigator.of(context).maybePop();
    }
  }

  void _pickCurrency() {
    showCurrencyPicker(
      context: context,
      onSelect: (Currency currency) {
        setState(() => _currencyCode = currency.code);
      },
    );
  }

  void _showHelp() {
    showInfoSheet(
      context,
      title: LocaleKeys.holdingHelpTitle.tr(),
      sections: [
        InfoSection(
          heading: LocaleKeys.holdingHelpWhatTitle.tr(),
          body: LocaleKeys.holdingHelpWhatBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.holdingHelpAutoTitle.tr(),
          body: LocaleKeys.holdingHelpAutoBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.holdingHelpManualTitle.tr(),
          body: LocaleKeys.holdingHelpManualBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.holdingHelpFieldsTitle.tr(),
          body: LocaleKeys.holdingHelpFieldsBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.holdingHelpValueTitle.tr(),
          body: LocaleKeys.holdingHelpValueBody.tr(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: _isEditing
            ? LocaleKeys.holdingsEditTitle.tr()
            : LocaleKeys.holdingsAdd.tr(),
        actions: [
          PageAppBarAction(
            icon: Icons.help_outline,
            tooltip: LocaleKeys.holdingHelpTitle.tr(),
            onTap: _showHelp,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PriceSourceToggle(
                value: _priceSource,
                onChanged: (v) => setState(() => _priceSource = v),
              ),
              SizedBox(height: 16.h),
              if (_priceSource.isAuto) ...[
                _Label(LocaleKeys.holdingPriceSourceAuto.tr()),
                SizedBox(height: 8.h),
                _CoinSearchField(
                  controller: _coinSearchController,
                  onChanged: _onCoinSearchChanged,
                  onSelect: _selectCoin,
                ),
                SizedBox(height: 16.h),
              ],
              _Label(LocaleKeys.holdingName.tr()),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.holdingNameHint.tr(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? LocaleKeys.holdingNameRequired.tr()
                    : null,
              ),
              SizedBox(height: 16.h),
              _Label(LocaleKeys.holdingSymbol.tr()),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _symbolController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: LocaleKeys.holdingSymbolHint.tr(),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label(LocaleKeys.holdingQuantity.tr()),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) {
                            final n = double.tryParse(v?.trim() ?? '');
                            if (n == null || n <= 0) {
                              return LocaleKeys.holdingQuantityRequired.tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(LocaleKeys.holdingCurrency.tr()),
                      SizedBox(height: 8.h),
                      InkWell(
                        onTap: _pickCurrency,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          height: 56.h,
                          width: 90.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: tones.bgSurface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: tones.borderMedium),
                          ),
                          child: Text(
                            _currencyCode,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: tones.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!_priceSource.isAuto) ...[
                SizedBox(height: 16.h),
                _Label(LocaleKeys.holdingUnitPrice.tr()),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _unitPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (_priceSource.isAuto) return null;
                    final n = double.tryParse(v?.trim() ?? '');
                    if (n == null || n < 0) {
                      return LocaleKeys.holdingUnitPriceRequired.tr();
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 28.h),
              BlocBuilder<HoldingCubit, HoldingState>(
                buildWhen: (a, b) => a.isSaving != b.isSaving,
                builder: (context, state) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSaving ? null : _save,
                    child: state.isSaving
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(LocaleKeys.holdingSave.tr()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class _PriceSourceToggle extends StatelessWidget {
  final HoldingPriceSource value;
  final ValueChanged<HoldingPriceSource> onChanged;

  const _PriceSourceToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    Widget option(HoldingPriceSource source, String label) {
      final selected = value == source;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(source),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? tones.brand.deep : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : tones.textMuted,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Row(
        children: [
          option(HoldingPriceSource.auto,
              LocaleKeys.holdingPriceSourceAuto.tr()),
          option(HoldingPriceSource.manual,
              LocaleKeys.holdingPriceSourceManual.tr()),
        ],
      ),
    );
  }
}

class _CoinSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<dynamic> onSelect;

  const _CoinSearchField({
    required this.controller,
    required this.onChanged,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: LocaleKeys.holdingSearchCoinHint.tr(),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        BlocBuilder<HoldingCubit, HoldingState>(
          buildWhen: (a, b) =>
              a.coinResults != b.coinResults || a.isSearching != b.isSearching,
          builder: (context, state) {
            if (state.isSearching) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const LinearProgressIndicator(),
              );
            }
            if (state.coinResults.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                color: tones.bgCard,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: tones.borderLight),
              ),
              child: Column(
                children: state.coinResults
                    .take(8)
                    .map(
                      (coin) => ListTile(
                        dense: true,
                        title: Text(coin.name),
                        trailing: Text(
                          coin.symbol.toUpperCase(),
                          style: TextStyle(
                            color: tones.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => onSelect(coin),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
