import 'dart:ui' as ui;

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/exchange_rate_formatter.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/locale_keys.g.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/remote_config/cubit/remote_config_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletTransferScreen extends StatefulWidget {
  const WalletTransferScreen({
    super.key,
    this.initialFromWalletClientId,
    this.embedded = false,
    this.onSavedSuccessfully,
  });

  final String? initialFromWalletClientId;

  /// When true, omits the Scaffold + AppBar so this can be embedded inside
  /// another screen (e.g. as a tab inside [AddTransactionScreen]).
  final bool embedded;

  /// Called after a successful save. Defaults to `Navigator.pop()` when null.
  final VoidCallback? onSavedSuccessfully;

  @override
  State<WalletTransferScreen> createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  Currency? currency;
  WalletEntity? selectedFromWallet;
  WalletEntity? selectedToWallet;
  DateTime _selectedTransferDate = DateTime.now();
  TimeOfDay _selectedTransferTime = TimeOfDay.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _transferDateController = TextEditingController();
  final TextEditingController _transferTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double _minimumTransferAmount(BuildContext context) =>
      context.read<RemoteConfigCubit>().state.config.minimumTransferAmount;

  String _minimumTransferAmountForLocale(BuildContext context) {
    final value = _minimumTransferAmount(context);
    final fixed = value.toStringAsFixed(6);
    return fixed.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  final DateFormat _transferDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _transferTimeFormat = DateFormat('h:mm a');

  void _syncTransferDateTimeControllers() {
    final combinedDateTime = DateTime(
      _selectedTransferDate.year,
      _selectedTransferDate.month,
      _selectedTransferDate.day,
      _selectedTransferTime.hour,
      _selectedTransferTime.minute,
    );
    _transferDateController.text = _transferDateFormat.format(combinedDateTime);
    _transferTimeController.text = _transferTimeFormat.format(combinedDateTime);
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _exchangeRateController.addListener(() => setState(() {}));
    _syncTransferDateTimeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallets = context.read<WalletCubit>().state.wallets;
      if (wallets.isNotEmpty) {
        setState(() {
          // If an initial wallet is provided, use it as the source wallet
          selectedFromWallet = widget.initialFromWalletClientId == null
              ? wallets.first
              : wallets.firstWhere(
                  (w) => w.clientId == widget.initialFromWalletClientId,
                  orElse: () => wallets.first,
                );

          // Default destination wallet: first wallet with a different clientId
          selectedToWallet = wallets.firstWhere(
            (w) => w.clientId != selectedFromWallet!.clientId,
            orElse: () => wallets.length > 1 ? wallets[1] : selectedFromWallet!,
          );

          _prefillExchangeRate();
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _exchangeRateController.dispose();
    _transferDateController.dispose();
    _transferTimeController.dispose();
    super.dispose();
  }

  /// Null when no rate is known — the field stays empty, never a silent 1:1.
  double? _defaultRateFor(WalletEntity? from, WalletEntity? to) {
    if (from == null || to == null) return null;
    if (from.currencyCode == to.currencyCode) return 1.0;
    final entity = context.read<ExchangeRateCubit>().state.entity;
    final fromRate = entity?.rates[from.currencyCode];
    final toRate = entity?.rates[to.currencyCode];
    if (fromRate == null || toRate == null) return null;
    return toRate / fromRate;
  }

  void _prefillExchangeRate() {
    final rate = _defaultRateFor(selectedFromWallet, selectedToWallet);
    _exchangeRateController.text =
        rate == null ? '' : formatExchangeRateForDisplay(rate);
  }

  void _showWalletSelector({
    required bool isFromWallet,
    required List<WalletEntity> availableWallets,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.r,
              right: 16.r,
              top: 16.r,
              bottom: MediaQuery.of(context).padding.bottom + 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFromWallet
                      ? LocaleKeys.selectSourceWallet.tr()
                      : LocaleKeys.selectDestinationWallet.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                ...availableWallets.map((wallet) {
                  final isSelected = isFromWallet
                      ? wallet.clientId == selectedFromWallet?.clientId
                      : wallet.clientId == selectedToWallet?.clientId;

                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(51),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Theme.of(context).primaryColor,
                        size: 20.sp,
                      ),
                    ),
                    title: Text(
                      wallet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    subtitle: Text(
                      '${wallet.balance.toStringAsFixed(2)} ${wallet.currencyCode}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        if (isFromWallet) {
                          selectedFromWallet = wallet;
                        } else {
                          selectedToWallet = wallet;
                        }

                        // Recompute default exchange rate when wallets change
                        _prefillExchangeRate();
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateForm() {
    final wallets = context.read<WalletCubit>().state.wallets;
    final minTransferAmount = _minimumTransferAmount(context);

    if (wallets.isEmpty) {
      return LocaleKeys.noWalletsAvailable.tr();
    }

    if (selectedFromWallet == null) {
      return LocaleKeys.selectSourceWallet.tr();
    }

    if (selectedToWallet == null) {
      return LocaleKeys.selectDestinationWallet.tr();
    }

    if (selectedFromWallet?.clientId == selectedToWallet?.clientId) {
      return LocaleKeys.cannotTransferToSameWallet.tr();
    }

    if (_amountController.text.isEmpty) {
      return LocaleKeys.amountRequired.tr();
    }

    final amount = parseAmount(_amountController.text.trim());
    if (amount < minTransferAmount) {
      return LocaleKeys.amountNotZero.tr(
        namedArgs: {'minAmount': _minimumTransferAmountForLocale(context)},
      );
    }

    // Validate destination/received amount too (for cross-currency transfers).
    double exchangeRate = 1.0;
    if (selectedFromWallet != null &&
        selectedToWallet != null &&
        selectedFromWallet!.currencyCode != selectedToWallet!.currencyCode) {
      final parsedRate = parseAmount(_exchangeRateController.text.trim());
      if (parsedRate <= 0) {
        return LocaleKeys.exchangeRateRequired.tr();
      }
      exchangeRate = parsedRate;
    }
    final receiveAmount = (selectedFromWallet != null &&
            selectedToWallet != null &&
            selectedFromWallet!.currencyCode == selectedToWallet!.currencyCode)
        ? amount
        : amount * exchangeRate;

    if (receiveAmount < minTransferAmount) {
      return LocaleKeys.amountNotZero.tr(
        namedArgs: {'minAmount': _minimumTransferAmountForLocale(context)},
      );
    }

    if (selectedFromWallet != null && amount > selectedFromWallet!.balance) {
      return LocaleKeys.insufficientBalance.tr();
    }

    return null;
  }

  void _performTransfer() {
    hideKeyBoard();

    final validationError = _validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final amount = parseAmount(_amountController.text.trim());

      double exchangeRate = 1.0;
      if (selectedFromWallet != null &&
          selectedToWallet != null &&
          selectedFromWallet!.currencyCode != selectedToWallet!.currencyCode) {
        final parsedRate = parseAmount(_exchangeRateController.text.trim());
        if (parsedRate <= 0) return;
        exchangeRate = parsedRate;
      }

      final receiveAmount = (selectedFromWallet != null &&
              selectedToWallet != null &&
              selectedFromWallet!.currencyCode ==
                  selectedToWallet!.currencyCode)
          ? amount
          : amount * exchangeRate;

      final minTransferAmount = _minimumTransferAmount(context);
      if (amount < minTransferAmount || receiveAmount < minTransferAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.amountNotZero.tr(
                namedArgs: {
                  'minAmount': _minimumTransferAmountForLocale(context)
                },
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final now = getNewFormattedUtcDateTime();
      final selectedDateTime = DateTime(
        _selectedTransferDate.year,
        _selectedTransferDate.month,
        _selectedTransferDate.day,
        _selectedTransferTime.hour,
        _selectedTransferTime.minute,
      );
      final transferDateTime =
          getFormattedUtcDateTimeFromUtc(selectedDateTime.toUtc());

      final transfer = TransferEntity(
        clientId: '',
        amount: amount,
        datetime: transferDateTime,
        createdAt: now,
        updatedAt: now,
        exchangeRate: exchangeRate,
        fromWalletClientId: selectedFromWallet!.clientId,
        toWalletClientId: selectedToWallet!.clientId,
      );

      final transactionDescription =
          LocaleKeys.walletTransferDefaultDescription.tr(
        namedArgs: {
          'fromCurrency': selectedFromWallet!.currencyCode,
          'toCurrency': selectedToWallet!.currencyCode,
        },
      );

      context.read<TransferCubit>().addTransfer(
            transfer,
            transactionDescription: transactionDescription,
          );
    }
  }

  Widget _buildDestinationReceives(BuildContext context) {
    if (selectedFromWallet == null ||
        selectedToWallet == null ||
        selectedFromWallet!.currencyCode == selectedToWallet!.currencyCode) {
      return const SizedBox.shrink();
    }

    final amount = parseAmount(_amountController.text.trim());

    final parsedRate = parseAmount(_exchangeRateController.text.trim());
    final formatted = parsedRate > 0
        ? CurrencyFormater.formatAmountWithSymbol(
            context,
            amount * parsedRate,
            currency: selectedToWallet!.currency,
          )
        : '—';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withAlpha(102),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward,
            size: 18.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              LocaleKeys.destinationWalletWillReceive
                  .tr(namedArgs: {'amount': formatted}),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSelector({
    required String title,
    required WalletEntity? selectedWallet,
    required bool isFromWallet,
  }) {
    final wallets = context.watch<WalletCubit>().state.wallets;
    final availableWallets = isFromWallet
        ? wallets
        : wallets
            .where((w) => w.clientId != selectedFromWallet?.clientId)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: availableWallets.isNotEmpty
              ? () => _showWalletSelector(
                    isFromWallet: isFromWallet,
                    availableWallets: availableWallets,
                  )
              : null,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: selectedWallet == null
                  ? Border.all(color: Colors.red.withAlpha(102), width: 1)
                  : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                    ),
                    child: SvgPicture.asset(
                      Assets.images.bottomLeftCircle,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  title: Text(
                    selectedWallet?.name ?? LocaleKeys.selectWallet.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: selectedWallet == null ? Colors.red : null,
                    ),
                  ),
                  subtitle: selectedWallet != null
                      ? Text(
                          '${selectedWallet.balance.toStringAsFixed(2)} ${selectedWallet.currencyCode}',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                  trailing: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(
                      Assets.images.arrowDown,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<TransferCubit, TransferState>(
          builder: (context, transferState) {
            final minTransferAmount = context
                .read<RemoteConfigCubit>()
                .state
                .config
                .minimumTransferAmount;
            final minTransferAmountForLocale = minTransferAmount
                .toStringAsFixed(6)
                .replaceAll(RegExp(r'0+$'), '')
                .replaceAll(RegExp(r'\.$'), '');
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWalletSelector(
                                title: LocaleKeys.sourceWallet.tr(),
                                selectedWallet: selectedFromWallet,
                                isFromWallet: true,
                              ),
                              SizedBox(height: 16.h),
                              _buildWalletSelector(
                                title: LocaleKeys.destinationWallet.tr(),
                                selectedWallet: selectedToWallet,
                                isFromWallet: false,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0.1.sw,
                            top: 0.14.sh,
                            child: GestureDetector(
                              onTap: () {
                                if (selectedFromWallet != null &&
                                    selectedToWallet != null) {
                                  setState(() {
                                    final temp = selectedFromWallet;
                                    selectedFromWallet = selectedToWallet;
                                    selectedToWallet = temp;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9500),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.swap_vert,
                                  size: 30.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        LocaleKeys.amount.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.amountHint.tr(),
                          suffixText: selectedFromWallet?.currencyCode,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.amountRequired.tr();
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return LocaleKeys.mustBeNumber.tr();
                          }
                          if (number < minTransferAmount) {
                            return LocaleKeys.amountNotZero.tr(
                              namedArgs: {
                                'minAmount': minTransferAmountForLocale,
                              },
                            );
                          }
                          if (selectedFromWallet != null &&
                              number > selectedFromWallet!.balance) {
                            return LocaleKeys.amountMustNotBeZero
                                .tr(); // fallback until locale keys update
                          }
                          return null;
                        },
                      ),
                      if (selectedFromWallet != null &&
                          selectedToWallet != null &&
                          selectedFromWallet!.currencyCode !=
                              selectedToWallet!.currencyCode) ...[
                        SizedBox(height: 12.h),
                        Text(
                          LocaleKeys.exchangeRate.tr(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        SizedBox(height: 6.h),
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: _exchangeRateController,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.exchangeRate.tr(),
                            suffixText: selectedToWallet?.currencyCode,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withAlpha(102),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.currency_exchange,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  '${LocaleKeys.convertingFrom.tr()} ${selectedFromWallet!.currencyCode} ${LocaleKeys.to.tr()} ${selectedToWallet!.currencyCode}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (selectedFromWallet != null &&
                          selectedToWallet != null &&
                          selectedFromWallet!.currencyCode !=
                              selectedToWallet!.currencyCode) ...[
                        SizedBox(height: 20.h),
                        _buildDestinationReceives(context),
                      ],
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.transactionDate.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(height: 8.h),
                                TextFormField(
                                  readOnly: true,
                                  controller: _transferDateController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20.sp,
                                    ),
                                  ),
                                  onTap: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedTransferDate,
                                      firstDate: DateTime.now().subtract(
                                        const Duration(days: 3650),
                                      ),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 3650),
                                      ),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        _selectedTransferDate = selectedDate;
                                        _syncTransferDateTimeControllers();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.transactionTime.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(height: 8.h),
                                TextFormField(
                                  readOnly: true,
                                  controller: _transferTimeController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.access_time_outlined,
                                      size: 20.sp,
                                    ),
                                  ),
                                  onTap: () async {
                                    final selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime: _selectedTransferTime,
                                    );
                                    if (selectedTime != null) {
                                      setState(() {
                                        _selectedTransferTime = selectedTime;
                                        _syncTransferDateTimeControllers();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        height: 54.h,
                        width: double.infinity,
                        child: PrimaryButton(
                          onPress:
                              transferState.isSaving ? null : _performTransfer,
                          buttonText: transferState.isSaving
                              ? LocaleKeys.processing.tr()
                              : LocaleKeys.transferMoney.tr(),
                          backgroundColor: Theme.of(context).primaryColor,
                          iconPath: Assets.images.arrowSwapHorizontal,
                          iconColor: Colors.white,
                          textDirection: ui.TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

    final listener = BlocListener<TransferCubit, TransferState>(
      listenWhen: (previous, current) =>
          previous.isSaving != current.isSaving ||
          previous.saveSuccess != current.saveSuccess ||
          previous.failure != current.failure,
      listener: (context, state) {
        if (state.failure.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.transferFailedWithMessage
                  .tr(namedArgs: {'message': state.failure.customMessage})),
              backgroundColor: Colors.red,
            ),
          );
          context.read<TransferCubit>().resetSaveState();
        } else if (state.saveSuccess) {
          context.read<TransferCubit>().resetSaveState();
          if (widget.onSavedSuccessfully != null) {
            widget.onSavedSuccessfully!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: body,
    );

    if (widget.embedded) {
      return listener;
    }

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.walletTransfer.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [SizedBox(width: 16.w)],
      ),
      body: listener,
    );
  }
}
