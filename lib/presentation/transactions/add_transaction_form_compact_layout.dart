import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/transaction_extras_section.dart';
import 'package:trakli/presentation/transactions/transaction_intent_selector.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_auto_complete_search.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_display_cache.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_view.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_source_row.dart';
import 'package:trakli/providers/chart_data_provider.dart';

class AddTransactionFormCompactLayout extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transactionCompleteEntity;

  const AddTransactionFormCompactLayout({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
    this.transactionCompleteEntity,
  });

  @override
  State<AddTransactionFormCompactLayout> createState() =>
      _AddTransactionFormCompactLayoutState();
}

class _AddTransactionFormCompactLayoutState
    extends State<AddTransactionFormCompactLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? selectedIndex;
  DateFormat dateFormat = DateFormat('dd-MM-yyy');
  DateFormat timeFormat = DateFormat('h:mm:a');
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoryEntity? _selectedCategory;
  WalletEntity? _selectedWallet;
  PartyEntity? _selectedParty;
  TransactionIntent _selectedIntent = TransactionIntent.regular;
  final _extras = TransactionExtrasController();
  List<String> attachedFilePaths = [];
  List<MediaFileEntity> existingMedia = [];
  final _formKey = GlobalKey<FormState>();

  List<AttachmentListItem> get _allAttachments => [
        ...existingMedia.map((m) => ExistingAttachment(m)),
        ...attachedFilePaths.map((p) => NewLocalAttachment(p)),
      ];

  void _addAttachmentPath(String? path) {
    if (path == null || !mounted) return;
    try {
      setState(() => attachedFilePaths = [...attachedFilePaths, path]);
    } catch (_) {
      if (mounted) {
        showSnackBar(message: LocaleKeys.unknownErrorDesc.tr());
      }
    }
  }

  Currency? currentCurrency;
  final pieData = StatisticsProvider().getPieData;

  setCurrencyFromWallet(WalletEntity? wallet) {
    setState(() {
      currentCurrency = wallet?.currency ?? currentCurrency;
    });
  }

  setCurrency(Currency currency) {
    setState(() {
      _selectedWallet = null;
      currentCurrency = currency;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.transactionCompleteEntity != null) {
      final wallet = widget.transactionCompleteEntity?.wallet;
      setCurrencyFromWallet(wallet);

      final existingIntent =
          widget.transactionCompleteEntity!.transaction.intent;
      _selectedIntent = existingIntent.availableFor(widget.transactionType)
          ? existingIntent
          : TransactionIntent.regular;
      _extras.populateFrom(
        widget.transactionCompleteEntity!.transaction,
        widget.transactionType,
      );

      amountController.text =
          widget.transactionCompleteEntity!.transaction.amount.toString();

      descriptionController.text =
          widget.transactionCompleteEntity!.transaction.description;
      date = widget.transactionCompleteEntity!.transaction.datetime.toLocal();
      dateController.text = dateFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());
      timeController.text = timeFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());
      if (widget.transactionCompleteEntity?.categories != null &&
          widget.transactionCompleteEntity!.categories.isNotEmpty) {
        _selectedCategory = widget.transactionCompleteEntity!.categories.first;
      }

      if (widget.transactionCompleteEntity?.wallet != null) {
        _selectedWallet = widget.transactionCompleteEntity!.wallet;
      }

      if (widget.transactionCompleteEntity?.party != null) {
        _selectedParty = widget.transactionCompleteEntity!.party;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final list = widget.transactionCompleteEntity!.files;
        setState(() => existingMedia = list);
      });
    } else {
      date = DateTime.now();
      dateController.text = dateFormat.format(date);
      timeController.text = timeFormat.format(date);

      final currencyState = context.read<CurrencyCubit>().state;
      currentCurrency = currencyState.currency ?? currentCurrency;

      // Always use default wallet from config
      final configState = context.read<ConfigCubit>().state;
      final defaultWalletConfig =
          configState.getConfigByKey(ConfigConstants.defaultWallet);
      final defaultWalletId = defaultWalletConfig?.value as String?;

      if (defaultWalletId != null) {
        final walletState = context.read<WalletCubit>().state;
        final defaultWallet = walletState.wallets.firstWhereOrNull(
          (wallet) => wallet.clientId == defaultWalletId,
        );

        if (defaultWallet != null) {
          _selectedWallet = defaultWallet;
          setCurrencyFromWallet(defaultWallet);
        }
      }
    }
  }

  void _handleRemove(AttachmentListItem item) {
    switch (item) {
      case ExistingAttachment(media: final m):
        context.read<TransactionCubit>().deleteMedia(m.path);
        setState(
            () => existingMedia = existingMedia.where((e) => e != m).toList());
        break;
      case NewLocalAttachment(path: final p):
        setState(() => attachedFilePaths =
            attachedFilePaths.where((path) => path != p).toList());
        break;
    }
  }

  @override
  void dispose() {
    AttachmentDisplayCache.clear();
    _extras.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tones = context.tones;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                spacing: 16.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.exampleAmount.tr(),
                        labelText: LocaleKeys.transactionAmount.tr(),
                        fillColor: tones.bgSurface,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md.r),
                          borderSide: BorderSide(
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.amountIsRequired.tr();
                        }
                        final number = double.tryParse(value);
                        if (number == null) {
                          return LocaleKeys.mustBeNumber.tr();
                        }
                        if (number == 0) {
                          return LocaleKeys.amountMustNotBeZero.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCurrencyPicker(
                        context: context,
                        theme: CurrencyPickerThemeData(
                          bottomSheetHeight: 0.7.sh,
                          backgroundColor: tones.bgSurface,
                          flagSize: 24.sp,
                          titleTextStyle: TextStyle(
                            color: tones.textPrimary,
                            fontSize: 16.sp,
                          ),
                          subtitleTextStyle: TextStyle(
                            fontSize: 12.sp,
                            color: tones.textSecondary,
                          ),
                        ),
                        onSelect: (Currency currencyValue) {
                          setCurrency(currencyValue);
                        },
                      );
                    },
                    child: Container(
                      width: 60.w,
                      constraints: BoxConstraints(
                        maxHeight: 50.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadii.md.r),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          currentCurrency?.code ?? "XAF",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.h),
            TransactionIntentSelector(
              type: widget.transactionType,
              selected: _selectedIntent,
              accentColor: widget.accentColor,
              onChanged: (intent) => setState(() => _selectedIntent = intent),
            ),
            SizedBox(height: 16.h),
            TransactionExtrasSection(
              controller: _extras,
              transactionType: widget.transactionType,
              accentColor: widget.accentColor,
            ),
            IntrinsicHeight(
              child: Row(
                spacing: 16.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        return CustomAutoCompleteSearch<WalletEntity>(
                          key: ValueKey(
                              'wallet_${currentCurrency?.code ?? 'none'}'),
                          label: LocaleKeys.wallet.tr(),
                          accentColor: widget.accentColor,
                          initialValue: _selectedWallet,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            Iterable<WalletEntity> filteredWallets =
                                state.wallets;
                            if (currentCurrency != null) {
                              filteredWallets = filteredWallets.where((wallet) {
                                return wallet.currencyCode ==
                                    currentCurrency!.code;
                              });
                            }

                            if (textEditingValue.text.isNotEmpty) {
                              filteredWallets = filteredWallets.where((wallet) {
                                return wallet.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            }
                            return filteredWallets;
                          },
                          displayStringForOption: (WalletEntity option) {
                            return option.name.capitalizeFirst();
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedWallet = value;
                              setCurrencyFromWallet(value);
                            });
                          },
                          validator: (value) {
                            if (_selectedWallet == null) {
                              return LocaleKeys.walletIsRequired.tr();
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  _AddBesideField(
                    onTap: () async {
                      AppNavigator.push(context, const AddWalletScreen());
                    },
                    accent: widget.accentColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.date.tr(),
                      fillColor: tones.bgSurface,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Assets.images.calendar,
                          colorFilter: ColorFilter.mode(
                            tones.textMuted,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md.r),
                        borderSide: BorderSide(
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final selectDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1000),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 1000),
                        ),
                      );
                      if (selectDate != null) {
                        setState(() {
                          date = selectDate;
                          dateController.text = dateFormat.format(date);
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.time.tr(),
                      fillColor: tones.bgSurface,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Assets.images.clock,
                          colorFilter: ColorFilter.mode(
                            tones.textMuted,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md.r),
                        borderSide: BorderSide(
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final selectTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectTime != null) {
                        setState(() {
                          time = selectTime;
                          date = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            selectTime.hour,
                            selectTime.minute,
                          );
                          timeController.text = timeFormat.format(date);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            IntrinsicHeight(
              child: Row(
                spacing: 16.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<PartyCubit, PartyState>(
                      builder: (context, state) {
                        return CustomAutoCompleteSearch<PartyEntity>(
                          label: LocaleKeys.party.tr(),
                          accentColor: widget.accentColor,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return state.parties;
                            }
                            return state.parties.where((category) {
                              return category.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          displayStringForOption: (PartyEntity option) {
                            return option.name.capitalizeFirst();
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedParty = value;
                            });
                          },
                          initialValue: _selectedParty,
                        );
                      },
                    ),
                  ),
                  _AddBesideField(
                    onTap: () async {
                      AppNavigator.push(context, const AddPartyScreen());
                    },
                    accent: widget.accentColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            IntrinsicHeight(
              child: Row(
                spacing: 16.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        //Category by transaction type
                        final searchCategories = state.categories.where(
                            (element) =>
                                element.type == widget.transactionType);

                        return CustomAutoCompleteSearch<CategoryEntity>(
                          label: LocaleKeys.category.tr(),
                          accentColor: widget.accentColor,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return searchCategories;
                            }
                            return searchCategories.where((category) {
                              return category.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          displayStringForOption: (CategoryEntity option) {
                            return option.name.capitalizeFirst();
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          initialValue: _selectedCategory,
                        );
                      },
                    ),
                  ),
                  _AddBesideField(
                    onTap: () async {
                      AppNavigator.push(
                        context,
                        AddCategoryScreen(
                          accentColor: widget.accentColor,
                          type: widget.transactionType,
                        ),
                      );
                    },
                    accent: widget.accentColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: LocaleKeys.transactionDescription.tr(),
                hintText: LocaleKeys.transactionTypeHere.tr(),
                fillColor: tones.bgSurface,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md.r),
                  borderSide: BorderSide(
                    color: widget.accentColor,
                  ),
                ),
              ),
              onTap: () async {},
            ),
            SizedBox(height: 16.h),
            AttachmentSourceRow(
              accentColor: widget.accentColor,
              onFileAdded: _addAttachmentPath,
            ),
            if (_allAttachments.isNotEmpty) ...[
              SizedBox(height: 12.h),
              SizedBox(
                height: 72.h,
                child: AttachmentListView(
                  items: _allAttachments,
                  showRemoveButton: true,
                  accentColor: widget.accentColor,
                  onRemove: _handleRemove,
                ),
              ),
            ],
            SizedBox(height: 20.h),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.accentColor,
                          Color.alphaBlend(
                            Colors.black.withValues(alpha: 0.08),
                            widget.accentColor,
                          ),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        elevation: const WidgetStatePropertyAll(0),
                        shadowColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        overlayColor: WidgetStatePropertyAll(
                            Colors.white.withValues(alpha: 0.16)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        textStyle: WidgetStatePropertyAll(
                          TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(amountController.text);
                          final description = descriptionController.text;

                          if (widget.transactionCompleteEntity != null) {
                            context.read<TransactionCubit>().updateTransaction(
                                  id: widget.transactionCompleteEntity!
                                      .transaction.clientId,
                                  amount: amount,
                                  description: description,
                                  datetime: date,
                                  intent: _selectedIntent,
                                  categoryIds: _selectedCategory != null
                                      ? [_selectedCategory!.clientId]
                                      : [],
                                  walletClientId: _selectedWallet?.clientId,
                                  partyClientId: _selectedParty?.clientId,
                                  attachedFilePaths: attachedFilePaths,
                                  recurrence: _extras.recurrence,
                                  clearRecurrence: _extras.clearRecurrence,
                                  isRefund: _extras.refundUpdate,
                                  refundOfClientId: _extras.refundOfClientId,
                                );
                            // Navigation handled by BlocListener
                          } else {
                            context.read<TransactionCubit>().addTransaction(
                                  amount: amount,
                                  description: description,
                                  categoryIds: _selectedCategory != null
                                      ? [_selectedCategory!.clientId]
                                      : [],
                                  type: widget.transactionType,
                                  intent: _selectedIntent,
                                  datetime: date,
                                  walletClientId:
                                      _selectedWallet?.clientId ?? '',
                                  partyClientId: _selectedParty?.clientId,
                                  attachedFilePaths: attachedFilePaths,
                                  recurrence: _extras.recurrence,
                                  isRefund: _extras.isRefund,
                                  refundOfClientId: _extras.refundOfClientId,
                                );
                            // Navigation handled by BlocListener
                          }
                        }
                      },
                      child: Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.transactionCompleteEntity != null
                                ? (widget.transactionType ==
                                        TransactionType.income
                                    ? LocaleKeys.updateIncome.tr()
                                    : LocaleKeys.updateExpenses.tr())
                                : widget.transactionType ==
                                        TransactionType.income
                                    ? LocaleKeys.transactionRecordIncome.tr()
                                    : LocaleKeys.transactionRecordExpenses.tr(),
                          ),
                          SvgPicture.asset(
                            Assets.images.add,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _AddBesideField extends StatelessWidget {
  final VoidCallback onTap;
  final Color accent;

  const _AddBesideField({required this.onTap, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: accent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: accent,
          size: 22.sp,
        ),
      ),
    );
  }
}
