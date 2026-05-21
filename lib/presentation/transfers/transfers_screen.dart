import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/locale_keys.g.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/transfer_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class TransfersScreen extends StatelessWidget {
  const TransfersScreen({super.key});

  // Find wallet information (prefer server id, fall back to clientId)
  WalletEntity? _findWallet({
    required List<WalletEntity> wallets,
    int? id,
    String? clientId,
  }) {
    if (id != null) {
      final byId = wallets.firstWhereOrNull((w) => w.id == id);
      if (byId != null) return byId;
    }

    if (clientId == null) return null;
    return wallets.firstWhereOrNull((w) => w.clientId == clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.transfers.tr(),
      ),
      body: SafeArea(
        child: BlocBuilder<TransferCubit, TransferState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
        
            if (state.transfers.isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.noTransfersFound.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              );
            }
        
            final transfers = List<TransferEntity>.from(state.transfers)
              ..sort(
                (a, b) => b.datetime.compareTo(a.datetime),
              );
        
            return BlocBuilder<WalletCubit, WalletState>(
              builder: (context, walletState) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: transfers.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final transfer = transfers[index];
        
                    final fromWallet = _findWallet(
                      wallets: walletState.wallets,
                      id: transfer.fromWalletId,
                      clientId: transfer.fromWalletClientId,
                    );
                    final toWallet = _findWallet(
                      wallets: walletState.wallets,
                      id: transfer.toWalletId,
                      clientId: transfer.toWalletClientId,
                    );
        
                    return TransferTile(
                      transfer: transfer,
                      fromWalletName: fromWallet?.name,
                      toWalletName: toWallet?.name,
                      fromWalletCurrency: fromWallet?.currencyCode,
                      toWalletCurrency: toWallet?.currencyCode,
                      onTap: () {
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

