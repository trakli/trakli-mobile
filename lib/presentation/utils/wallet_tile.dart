import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletTile extends StatelessWidget {
  final WalletEntity wallet;
  final bool canDelete;
  final bool showDefaultWallet;

  const WalletTile({
    super.key,
    required this.wallet,
    this.canDelete = true,
    this.showDefaultWallet = false,
  });

  @override
  Widget build(BuildContext context) {
    // Check if this wallet is the default wallet
    String? defaultWalletId;
    if (showDefaultWallet) {
      final configState = context.watch<ConfigCubit>().state;
      defaultWalletId = configState
          .getConfigByKey(ConfigConstants.defaultWallet)
          ?.value as String?;
    }

    final isDefaultWallet =
        showDefaultWallet && wallet.clientId == defaultWalletId;

    // Calculate income/expense from transactions instead of using wallet.stats
    final transactions = context.watch<TransactionCubit>().state.transactions;
    final totals = calculateIncomeExpense(
      transactions,
      walletClientId: wallet.clientId,
    );
    final totalIncome = totals.totalIncome;
    final totalExpense = totals.totalExpense;
    
    // Calculate balance from transactions (income - expense)
    final walletBalance = totalIncome - totalExpense;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              Assets.images.bottomLeftCircle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
              top: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              wallet.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isDefaultWallet) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                LocaleKeys.defaultWallet.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: walletGrey,
                      ),
                      child: PopupMenuButton(
                        icon: SvgPicture.asset(
                          height: 20.h,
                          width: 20.w,
                          Assets.images.more,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                AppNavigator.push(
                                  context,
                                  AddWalletScreen(wallet: wallet),
                                );
                              },
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(50),
                                    ),
                                    child: SvgPicture.asset(
                                      height: 16.h,
                                      width: 16.w,
                                      Assets.images.edit2,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Text(LocaleKeys.edit.tr()),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              height: 40.h,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueAccent.withAlpha(50),
                                    ),
                                    child: SvgPicture.asset(
                                      height: 16.h,
                                      width: 16.w,
                                      Assets.images.arrowUpDown,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.blueAccent,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Text(LocaleKeys.walletTransfer.tr()),
                                ],
                              ),
                            ),
                            if (canDelete)
                              PopupMenuItem(
                                onTap: () {
                                  showCustomDialog(
                                    widget: PopUpDialog(
                                      dialogType: DialogType.negative,
                                      title: LocaleKeys.deleteWallet.tr(),
                                      subTitle: LocaleKeys.deleteWalletConfirm
                                          .tr(namedArgs: {'name': wallet.name}),
                                      mainAction: () {
                                        context
                                            .read<WalletCubit>()
                                            .deleteWallet(wallet.clientId);
                                        AppNavigator.pop(context);
                                      },
                                      mainActionText: LocaleKeys.delete.tr(),
                                      secondaryActionText:
                                          LocaleKeys.cancel.tr(),
                                    ),
                                  );
                                },
                                height: 40.h,
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent.withAlpha(50),
                                      ),
                                      child: SvgPicture.asset(
                                        height: 16.h,
                                        width: 16.w,
                                        Assets.images.trash,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.redAccent,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Text(LocaleKeys.delete.tr()),
                                  ],
                                ),
                              ),
                            PopupMenuItem(
                              onTap: () {},
                              height: 40.h,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withAlpha(50),
                                    ),
                                    child: SvgPicture.asset(
                                      height: 16.h,
                                      width: 16.w,
                                      Assets.images.documentCopy,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Text(LocaleKeys.duplicate.tr()),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.totalBalance.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          height: 16.h,
                          width: 16.w,
                          Assets.images.arrowDown,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      LocaleKeys.balanceAmountWithCurrency.tr(
                        args: [
                          CurrencyFormater.formatAmountWithSymbol(
                            context,
                            walletBalance,
                            currency: wallet.currency,
                          )
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: incomeGreen,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Column(
                        spacing: 2.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              SvgPicture.asset(
                                width: 16.w,
                                Assets.images.arrowSwapDown,
                                colorFilter: ColorFilter.mode(
                                  incomeGreenText,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Text(
                                LocaleKeys.transactionIncome.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: incomeGreenText,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            LocaleKeys.balanceAmountWithCurrency.tr(
                              args: [
                                CurrencyFormater.formatAmountWithSymbol(
                                  context,
                                  totalIncome,
                                  currency: wallet.currency,
                                )
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: expenseRed,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Column(
                        spacing: 2.h,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                LocaleKeys.transactionExpense.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: expenseRedText,
                                ),
                              ),
                              SvgPicture.asset(
                                width: 16.w,
                                Assets.images.arrowSwapUp,
                                colorFilter: ColorFilter.mode(
                                  expenseRedText,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            LocaleKeys.balanceAmountWithCurrency.tr(
                              args: [
                                CurrencyFormater.formatAmountWithSymbol(
                                  context,
                                  totalExpense,
                                  currency: wallet.currency,
                                )
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
