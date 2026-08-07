import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/exports/cubit/export_cubit.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/popovers/category_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/date_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/wallet_list_popover.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showSearch = false;
  List<dynamic> selectedItems = [];
  PickerDateRange? dateRange;

  @override
  void initState() {
    final cubit = context.read<TransactionCubit>();
    cubit.loadWallets();
    super.initState();
  }

  List<TransactionCompleteEntity> filterTransactions({
    required List<TransactionCompleteEntity> transactions,
  }) {
    final filteredTransactions = selectedItems.isEmpty && dateRange == null
        ? transactions
        : (() {
            final selectedCategories =
                selectedItems.whereType<CategoryEntity>().toList();
            final selectedWallets =
                selectedItems.whereType<WalletEntity>().toList();

            final hasCategoryFilter = selectedCategories.isNotEmpty;
            final hasWalletFilter = selectedWallets.isNotEmpty;

            return transactions.where((transaction) {
              final categoryMatch = hasCategoryFilter &&
                  transaction.categories.any((cat) => selectedCategories
                      .any((selected) => selected.clientId == cat.clientId));
              final walletMatch = hasWalletFilter &&
                  selectedWallets.any((wallet) =>
                      wallet.clientId == transaction.wallet.clientId);

              final dateMatch = matchTransactionDate(
                dateRange,
                transaction.transaction,
              );

              if (hasCategoryFilter && hasWalletFilter) {
                return categoryMatch && walletMatch && dateMatch;
              } else if (hasCategoryFilter) {
                return categoryMatch && dateMatch;
              } else if (hasWalletFilter) {
                return walletMatch && dateMatch;
              } else {
                return dateMatch;
              }
            }).toList();
          })();
    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocProvider(
      create: (_) => getIt<ExportCubit>(),
      child: BlocListener<ExportCubit, ExportState>(
        listenWhen: (previous, current) =>
            previous.file != current.file ||
            previous.failure != current.failure ||
            previous.blocker != current.blocker,
        listener: _onExportStateChanged,
        child: _buildScaffold(tones),
      ),
    );
  }

  void _onExportStateChanged(BuildContext context, ExportState state) {
    if (state.file != null) {
      final file = state.file!;
      context.read<ExportCubit>().clearFile();
      _showExportActions(file);
      return;
    }

    if (state.failure.hasError) {
      showSnackBar(message: state.failure);
      return;
    }

    switch (state.blocker) {
      case ExportBlocker.signedOut:
        showSnackBar(message: LocaleKeys.exportRequiresAccount.tr());
      case ExportBlocker.pendingSync:
        showSnackBar(message: LocaleKeys.exportAwaitingSync.tr());
      case ExportBlocker.none:
        break;
    }
  }

  /// The file is ready; let the user decide whether it should be kept on the
  /// device or handed to another app.
  void _showExportActions(ExportedFile file) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                file.name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(LocaleKeys.save.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _saveFile(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(LocaleKeys.share.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _shareFile(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareFile(ExportedFile file) {
    Share.shareXFiles([
      XFile.fromData(
        file.bytes,
        name: file.name,
        mimeType: file.mimeType,
      ),
    ], fileNameOverrides: [file.name]);
  }

  /// Writes the export through the system file picker, so the user chooses
  /// where it lands and ends up with a copy they can find again.
  Future<void> _saveFile(ExportedFile file) async {
    try {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: LocaleKeys.export.tr(),
        fileName: file.name,
        bytes: file.bytes,
      );
      if (path == null) return;
      showSnackBar(
        message: LocaleKeys.exportSaved.tr(namedArgs: {'name': file.name}),
        isSuccess: true,
      );
    } catch (_) {
      showSnackBar(message: LocaleKeys.exportSaveFailed.tr());
    }
  }

  /// Server-side exports only cover synced records, so a filter pinned to a
  /// wallet or category that has not reached the server yet cannot be honoured.
  void _export(BuildContext context, ExportFormat format) {
    final wallets = selectedItems.whereType<WalletEntity>().toList();
    final categories = selectedItems.whereType<CategoryEntity>().toList();

    if (wallets.any((wallet) => wallet.id == null) ||
        categories.any((category) => category.id == null)) {
      showSnackBar(message: LocaleKeys.exportAwaitingSync.tr());
      return;
    }

    final start = dateRange?.startDate;

    showSnackBar(
      message: LocaleKeys.exportPreparing.tr(),
      isSuccess: true,
    );

    context.read<ExportCubit>().exportTransactions(
          format: format,
          from: start,
          to: start == null ? null : (dateRange?.endDate ?? start),
          walletIds: wallets.map((wallet) => wallet.id!).toList(),
          categoryIds: categories.map((category) => category.id!).toList(),
        );
  }

  Widget _buildScaffold(AppTones tones) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final exchangeRateEntity =
            context.read<ExchangeRateCubit>().state.entity;

        final transactions =
            filterTransactions(transactions: state.transactions);

        final totals = calculateIncomeExpense(
          transactions,
          exchangeRateEntity: exchangeRateEntity,
        );
        final totalIncome = totals.totalIncome;
        final totalExpense = totals.totalExpense;

        final totalBalance = totalIncome - totalExpense;

        return Scaffold(
          backgroundColor: tones.bgPage,
          appBar: PageAppBar(
            title: LocaleKeys.transactionHistory.tr(),
            actions: [
              PageAppBarAction(
                icon: Icons.add,
                onTap: () => AppNavigator.push(
                  context,
                  const AddTransactionScreen(),
                ),
                primary: true,
              ),
            ],
          ),
          body: (state.isLoading)
              ? Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(appPrimaryColor),
                  ),
                )
              : (state.transactions.isEmpty)
                  ? InfoInterface(
                      action: () {
                        AppNavigator.push(
                          context,
                          const AddTransactionScreen(),
                        );
                      },
                      data: emptyTransactionData,
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 12.h),
                      child: Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              if (showSearch)
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: LocaleKeys.searchHint.tr(),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: SvgPicture.asset(
                                          Assets.images.filter,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Expanded(
                                  child: Row(
                                    spacing: 6.w,
                                    children: [
                                      _filterType(
                                        iconPath: Assets.images.calendar,
                                        filterType: FilterType.date,
                                        tone: AppTone.brand,
                                      ),
                                      _filterType(
                                        iconPath: Assets.images.tag2,
                                        filterType: FilterType.category,
                                        tone: AppTone.warm,
                                      ),
                                      _filterType(
                                        iconPath: Assets.images.wallet,
                                        filterType: FilterType.wallet,
                                        tone: AppTone.income,
                                      ),
                                    ],
                                  ),
                                ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                style: IconButton.styleFrom(
                                  backgroundColor: neutralN600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showSearch = !showSearch;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  showSearch == true
                                      ? Assets.images.close
                                      : Assets.images.searchNormal,
                                  width: 16.w,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appPrimaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                  ),
                                ),
                                position: PopupMenuPosition.under,
                                icon: Row(
                                  spacing: 4.w,
                                  children: [
                                    Text(
                                      LocaleKeys.export.tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      Assets.images.export,
                                    ),
                                  ],
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () =>
                                          _export(context, ExportFormat.pdf),
                                      child: Row(
                                        spacing: 8.w,
                                        children: [
                                          SvgPicture.asset(
                                            height: 16.h,
                                            width: 16.w,
                                            Assets.images.pdfType,
                                          ),
                                          Text(LocaleKeys.toPdf.tr()),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () =>
                                          _export(context, ExportFormat.xlsx),
                                      child: Row(
                                        spacing: 8.w,
                                        children: [
                                          SvgPicture.asset(
                                            height: 16.h,
                                            width: 16.w,
                                            Assets.images.excelType,
                                          ),
                                          Text(LocaleKeys.toExcel.tr()),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          if (selectedItems.isNotEmpty)
                            SizedBox(
                              height: 30.h,
                              child: ListView.separated(
                                itemCount: selectedItems.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String itemName = '';
                                  final item = selectedItems[index];
                                  if (item is WalletEntity) {
                                    itemName = item.name;
                                  } else if (item is CategoryEntity) {
                                    itemName = item.name;
                                  } else if (item is DateFilterOption) {
                                    if (item == DateFilterOption.custom) {
                                      itemName = formatRange(dateRange) ?? "";
                                    } else {
                                      itemName = item.name.tr();
                                    }
                                  }

                                  return _selectedItem(
                                      iconPath: getIconPath(item),
                                      name: itemName,
                                      onTap: () {
                                        setState(() {
                                          selectedItems.removeAt(index);
                                          if (item is DateFilterOption) {
                                            dateRange = null;
                                          }
                                        });
                                      });
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 6.w);
                                },
                              ),
                            ),
                          SizedBox(height: 16.h),
                          transactions.isEmpty
                              ? SizedBox(
                                  height: 0.25.sh,
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.noTransactionsFound.tr(),
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.grey),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: transactions.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 8.h);
                                  },
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return TransactionTile(
                                      transaction: transaction,
                                      accentColor:
                                          transaction.transaction.type ==
                                                  TransactionType.income
                                              ? Theme.of(context).primaryColor
                                              : const Color(0xFFEB5757),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
          bottomNavigationBar: (state.transactions.isEmpty)
              ? const SizedBox.shrink()
              : IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _bottomTile(
                          context,
                          accentColor: appPrimaryColor,
                          mainText: LocaleKeys.totalIncome.tr(),
                          amount: totalIncome,
                        ),
                      ),
                      Expanded(
                        child: _bottomTile(
                          context,
                          accentColor: appDangerColor,
                          mainText: LocaleKeys.totalExpenses.tr(),
                          amount: totalExpense,
                        ),
                      ),
                      Expanded(
                        child: _bottomTile(
                          context,
                          accentColor: appBlue,
                          mainText: LocaleKeys.totalBalance.tr(),
                          amount: totalBalance,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _bottomTile(
    BuildContext context, {
    required Color accentColor,
    required String mainText,
    required double amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(40),
      ),
      child: Column(
        children: [
          Text(
            mainText,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              currentDecimalDigits: 0,
              amount,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterType({
    required String iconPath,
    required FilterType filterType,
    required AppTone tone,
  }) {
    final GlobalKey key = GlobalKey();

    final tones = context.tones;
    final palette = tones.tone(tone);
    return Expanded(
      child: Builder(
        builder: (context) {
          return Material(
            key: key,
            color: palette.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              side: BorderSide(
                color: palette.accent.withValues(alpha: 0.45),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              onTap: () {
                showCustomPopOver(
                  context,
                  maxWidth: 0.45.sw,
                  widget: filterType == FilterType.wallet
                      ? WalletListPopover(
                          label: filterType.filterName.tr(),
                          onSelect: (wallet) {
                            setState(() {
                              if (!selectedItems.any((item) =>
                                  (item is WalletEntity &&
                                      item.clientId == wallet.clientId))) {
                                selectedItems.add(wallet);
                              }
                            });
                          },
                        )
                      : filterType == FilterType.category
                          ? CategoryListPopover(
                              label: filterType.filterName.tr(),
                              onSelect: (category) {
                                setState(() {
                                  if (!selectedItems.any((item) => (item
                                          is CategoryEntity &&
                                      item.clientId == category.clientId))) {
                                    selectedItems.add(category);
                                  }
                                });
                              },
                            )
                          : DateListPopover(
                              label: filterType.filterName.tr(),
                              onSelect: (range) {
                                setState(() {
                                  dateRange = range;
                                });
                              },
                              onSelectString: (dateFilterOption) {
                                setState(() {
                                  selectedItems.removeWhere(
                                      (item) => item is DateFilterOption);
                                  selectedItems.add(dateFilterOption);
                                });
                              },
                            ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 14.w,
                      height: 14.h,
                      colorFilter: ColorFilter.mode(
                        palette.deep,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        filterType.filterName.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: palette.deep,
                          letterSpacing: -0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.expand_more,
                      size: 14.sp,
                      color: palette.deep,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectedItem({
    String? iconPath,
    required String name,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              width: 16.w,
              height: 16.h,
              iconPath,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          Text(
            name,
            style: TextStyle(
              fontSize: 10.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset(
              Assets.images.close,
              colorFilter: const ColorFilter.mode(
                Colors.redAccent,
                BlendMode.srcIn,
              ),
            ),
          )
        ],
      ),
    );
  }
}
