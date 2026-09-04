import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<WalletEntity> onSelect;
  final bool showCurrency;

  const WalletListPopover({
    super.key,
    required this.label,
    required this.onSelect,
    this.showCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: tones.expense.accent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(tones.brand.deep),
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: tones.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              state.wallets.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.noWalletsYet.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: tones.textMuted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final wallet = state.wallets[index];
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.w),
                          onTap: () {
                            onSelect(wallet);
                            AppNavigator.pop(context);
                          },
                          title: Text(
                            wallet.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: tones.textPrimary),
                          ),
                          subtitle: showCurrency
                              ? Text(
                                  wallet.currencyCode,
                                  style: TextStyle(
                                    color: tones.brand.deep,
                                    fontSize: 12.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: SvgPicture.asset(
                            Assets.images.arrowRight,
                            colorFilter: ColorFilter.mode(
                              tones.textMuted,
                              BlendMode.srcIn,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 4.h);
                      },
                      itemCount: state.wallets.length,
                    ),
            ],
          ),
        );
      },
    );
  }
}
