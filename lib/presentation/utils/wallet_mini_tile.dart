import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class WalletMiniTile<T> extends StatelessWidget {
  final T value;
  final WalletEntity? wallet;
  final bool isAllWallets;
  final String? walletNameOverride;

  const WalletMiniTile({
    super.key,
    required this.value,
    this.wallet,
    this.isAllWallets = false,
    this.walletNameOverride,
  });

  @override
  Widget build(BuildContext context) {
    String walletName = walletNameOverride ?? LocaleKeys.allWallets.tr();
    if (!isAllWallets && wallet != null) {
      walletName = wallet!.name;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            isAllWallets
                ? Icons.account_balance_wallet
                : Icons.account_balance_wallet_outlined,
            size: 16.w,
            color: appPrimaryColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              walletName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Radio<T>(
            activeColor: appPrimaryColor,
            value: value,
          ),
        ],
      ),
    );
  }
}
