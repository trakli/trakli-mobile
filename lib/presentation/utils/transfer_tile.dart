import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class TransferTile extends StatelessWidget {
  final TransferEntity transfer;
  final String? fromWalletName;
  final String? toWalletName;
  final String? fromWalletCurrency;
  final String? toWalletCurrency;
  final VoidCallback? onTap;

  const TransferTile({
    super.key,
    required this.transfer,
    this.fromWalletName,
    this.toWalletName,
    this.fromWalletCurrency,
    this.toWalletCurrency,
    this.onTap,
  });

  Currency? _getCurrencyFromCode(String? currencyCode) {
    if (currencyCode == null) return null;
    try {
      return CurrencyService().findByCode(currencyCode);
    } catch (e) {
      return null;
    }
  }

  void _showDetailBottomSheet(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    final isCrossCurrency =
        fromWalletCurrency != null &&
        toWalletCurrency != null &&
        fromWalletCurrency != toWalletCurrency;
    final hasExchangeRate = isCrossCurrency &&
        transfer.exchangeRate != null &&
        transfer.exchangeRate != 1.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.r,
              right: 20.r,
              top: 20.r,
              bottom: MediaQuery.of(sheetContext).padding.bottom + 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Theme.of(sheetContext).colorScheme.outline.withAlpha(102),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withAlpha(51),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: SvgPicture.asset(
                        Assets.images.arrowUpDown,
                        width: 24.r,
                        height: 24.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.blueAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.walletTransfer.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(sheetContext).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${dateFormat.format(transfer.datetime)} • ${timeFormat.format(transfer.datetime)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(sheetContext)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormater.formatAmountWithSymbol(
                        context,
                        transfer.amount,
                        currency: _getCurrencyFromCode(fromWalletCurrency),
                      ),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  LocaleKeys.from.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(sheetContext)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: expenseRed.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: expenseRed.withAlpha(76),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.images.arrowSwapUp,
                        width: 20.r,
                        height: 20.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.redAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fromWalletName ?? LocaleKeys.unknown.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(sheetContext).colorScheme.onSurface,
                              ),
                            ),
                            if (fromWalletCurrency != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                fromWalletCurrency!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(sheetContext)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(153),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.to.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(sheetContext)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: incomeGreen.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: incomeGreen.withAlpha(76),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.images.arrowSwapDown,
                        width: 20.r,
                        height: 20.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.green,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              toWalletName ?? LocaleKeys.unknown.tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(sheetContext).colorScheme.onSurface,
                              ),
                            ),
                            if (toWalletCurrency != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                toWalletCurrency!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(sheetContext)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(153),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (hasExchangeRate && toWalletCurrency != null)
                        Text(
                          '≈ ${CurrencyFormater.formatAmountWithSymbol(
                            sheetContext,
                            transfer.amount * transfer.exchangeRate!,
                            currency: _getCurrencyFromCode(toWalletCurrency),
                          )}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(sheetContext).colorScheme.onSurface, 
                          ),
                        ),
                    ],
                  ),
                ),
                if (isCrossCurrency) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.r),
                    decoration: BoxDecoration(
                      color: Theme.of(sheetContext)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(102),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          size: 20.sp,
                          color: Theme.of(sheetContext).colorScheme.onSecondaryContainer,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            '${LocaleKeys.exchangeRate.tr()}: ${transfer.exchangeRate != null ? transfer.exchangeRate!.toStringAsFixed(4) : "—"}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(sheetContext).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final hasExchangeRate = transfer.exchangeRate != null &&
        transfer.exchangeRate != 1.0 &&
        fromWalletCurrency != toWalletCurrency;

    final fromLabel = fromWalletName ?? LocaleKeys.unknown.tr();
    final toLabel = toWalletName ?? LocaleKeys.unknown.tr();
    final fromShort = fromLabel.length > 12 ? '${fromLabel.substring(0, 12)}…' : fromLabel;
    final toShort = toLabel.length > 12 ? '${toLabel.substring(0, 12)}…' : toLabel;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: InkWell(
        onTap: () => _showDetailBottomSheet(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withAlpha(51),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: SvgPicture.asset(
                  Assets.images.arrowUpDown,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.blueAccent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$fromShort → $toShort',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dateFormat.format(transfer.datetime),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CurrencyFormater.formatAmountWithSymbol(
                      context,
                      transfer.amount,
                      currency: _getCurrencyFromCode(fromWalletCurrency),
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueAccent,
                    ),
                  ),
                  if (hasExchangeRate) ...[
                    SizedBox(height: 2.h),
                    Text(
                      '≈ ${transfer.exchangeRate!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
