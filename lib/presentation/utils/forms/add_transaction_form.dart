import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
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
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_wallet_bottom_sheet.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/dialogs/add_party_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_display_cache.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_view.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_source_row.dart';
import 'package:trakli/providers/chart_data_provider.dart';

class AddTransactionForm extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transactionCompleteEntity;

  const AddTransactionForm({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
    this.transactionCompleteEntity,
  });

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  int? selectedIndex;
  DateFormat dateFormat = DateFormat('dd-MM-yyy');
  DateFormat timeFormat = DateFormat('h:mm:a');
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController walletController = TextEditingController();

  // TextEditingController partyController = TextEditingController();
  Currency? currency;
  WalletEntity? selectedWallet;
  CategoryEntity? selectedCategory;
  PartyEntity? selectedParty;
  List<String> attachedFilePaths = [];
  List<MediaFileEntity> existingMedia = [];
  final pieData = StatisticsProvider().getPieData;
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
    super.dispose();
  }

  setAmountController(Currency? currency) {
    if (widget.transactionCompleteEntity != null) {
      amountController.text =
          widget.transactionCompleteEntity!.transaction.amount.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.transactionCompleteEntity != null) {
      setAmountController(currency);
      descriptionController.text =
          widget.transactionCompleteEntity!.transaction.description;
      date = widget.transactionCompleteEntity!.transaction.datetime.toLocal();
      dateController.text = dateFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());
      timeController.text = timeFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());

      if (widget.transactionCompleteEntity?.wallet != null) {
        selectedWallet = widget.transactionCompleteEntity!.wallet;
        walletController.text = selectedWallet!.name;
        // Set currency from wallet
        currency = selectedWallet!.currency;
      }
    } else {
      date = DateTime.now();
      dateController.text = dateFormat.format(date);
      timeController.text = timeFormat.format(date);

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
          selectedWallet = defaultWallet;
          walletController.text = defaultWallet.name;
          currency = defaultWallet.currency;
        }
      }

      if (widget.transactionCompleteEntity?.party != null) {
        selectedParty = widget.transactionCompleteEntity!.party;
      }
    }
    if (widget.transactionCompleteEntity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final list = widget.transactionCompleteEntity!.files;
        setState(() => existingMedia = list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listenWhen: (previous, current) {
        // Listen when saving completes (isSaving goes from true to false)
        return previous.isSaving && !current.isSaving;
      },
      listener: (context, state) {
        // Only navigate if save was successful (no error)
        if (!state.failure.hasError && mounted) {
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.transactionAmount.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
                              backgroundColor: Colors.white,
                              flagSize: 24.sp,
                              subtitleTextStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).primaryColor,
                              )),
                          onSelect: (Currency currencyValue) {
                            setState(() {
                              currency = currencyValue;
                              setAmountController(currency);
                            });
                          },
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(currency?.code ?? "XAF"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocaleKeys.wallet.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: walletController,
                        onTap: () {
                          showCustomBottomSheet(
                            context,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            widget: BlocBuilder<WalletCubit, WalletState>(
                              builder: (context, state) {
                                return SelectWalletBottomSheet(
                                  wallets: state.wallets,
                                  onSelect: (wallet) {
                                    setState(() {
                                      selectedWallet = wallet;
                                      walletController.text = wallet.name;
                                      // Update currency when wallet changes
                                      currency = wallet.currency;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: LocaleKeys.selectWallet.tr(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: widget.accentColor,
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              Assets.images.arrowDown,
                              colorFilter: ColorFilter.mode(
                                Colors.grey.shade500,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.walletIsRequired.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.push(context, const AddWalletScreen());
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.transactionDate.tr(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                Assets.images.calendar,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.transactionTime.tr(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: timeController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                Assets.images.clock,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                widget.transactionType == TransactionType.expense
                    ? '${LocaleKeys.transactionSentTo.tr()} (${LocaleKeys.party.tr()})'
                    : '${LocaleKeys.transactionReceivedFrom.tr()} (${LocaleKeys.party.tr()})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocBuilder<PartyCubit, PartyState>(
                        builder: (context, state) {
                          return CustomDropdownSearch<PartyEntity>(
                            label: "",
                            accentColor: widget.accentColor,
                            selectedItem: selectedParty,
                            items: (filter, infiniteScrollProps) {
                              return state.parties;
                            },
                            itemAsString: (item) => item.name,
                            onChanged: (value) {
                              setState(() {
                                selectedParty = value;
                              });
                            },
                            compareFn: (i1, i2) => i1.clientId == i2.clientId,
                            filterFn: (el, filter) => el.name
                                .toLowerCase()
                                .contains(filter.toLowerCase()),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return const AddPartyDialog();
                          },
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocaleKeys.transactionCategory.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: categoryController,
                        readOnly: true,
                        onTap: () {
                          showCustomBottomSheet(
                            context,
                            widget: BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                //Category by transaction type
                                final searchCategories = state.categories.where(
                                    (element) =>
                                        element.type == widget.transactionType);

                                return CustomDropdownSearch<CategoryEntity>(
                                  label: "",
                                  accentColor: widget.accentColor,
                                  selectedItem: selectedCategory,
                                  items: (filter, infiniteScrollProps) {
                                    return searchCategories
                                        .map((data) => data)
                                        .toList()
                                        .where((CategoryEntity el) => el.name
                                            .toLowerCase()
                                            .contains(filter.toLowerCase()))
                                        .toList();
                                  },
                                  itemAsString: (item) => item.name,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                      if (value != null) {
                                        categoryController.text = value.name;
                                      }

                                      Navigator.pop(context);
                                    });
                                  },
                                  compareFn: (i1, i2) =>
                                      i1.clientId == i2.clientId,
                                  filterFn: (el, filter) {
                                    return el.name.toLowerCase().contains(
                                          filter.toLowerCase(),
                                        );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: LocaleKeys.selectCategory.tr(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: widget.accentColor,
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              Assets.images.arrowDown,
                              colorFilter: ColorFilter.mode(
                                Colors.grey.shade500,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.categoryIsRequired.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        AppNavigator.push(
                          context,
                          AddCategoryScreen(
                            accentColor: widget.accentColor,
                            type: widget.transactionType,
                          ),
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocaleKeys.transactionDescription.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.transactionTypeHere.tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocaleKeys.transactionAttachment.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 8.h),
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
                height: 54.h,
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(widget.accentColor),
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
                                  categoryIds: selectedCategory != null
                                      ? [selectedCategory!.clientId]
                                      : null,
                                  attachedFilePaths: attachedFilePaths,
                                );
                            // Navigation handled by BlocListener
                          } else {
                            if (selectedWallet == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(LocaleKeys.pleaseSelectWallet),
                                ),
                              );
                              return;
                            }

                            context.read<TransactionCubit>().addTransaction(
                                  amount: amount,
                                  description: description,
                                  type: widget.transactionType,
                                  datetime: date,
                                  walletClientId: selectedWallet!.clientId,
                                  categoryIds: selectedCategory != null
                                      ? [selectedCategory!.clientId]
                                      : [],
                                  partyClientId: selectedParty?.clientId,
                                  attachedFilePaths: attachedFilePaths,
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
                            widget.transactionType == TransactionType.income
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
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
