import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popover/popover.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/wallet_list_popover.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletTypePopover extends StatelessWidget {
  final ValueChanged<WalletOption> onSelect;

  const WalletTypePopover({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: WalletOption.values.length,
            itemBuilder: (context, index) {
              final GlobalKey key = GlobalKey();
              final walletCubit = context.read<WalletCubit>();
              final option = WalletOption.values.elementAt(index);
              if (walletCubit.state.wallets.isEmpty && index == 2) {
                return const SizedBox.shrink();
              }
              return Builder(builder: (context) {
                return ListTile(
                  key: key,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () async {
                    onSelect(option);
                    if (index == 2) {
                      await showCustomPopOver(context,
                          direction: PopoverDirection.top,
                          // maxWidth: filterType == FilterType.date ? 0.45.sw : null,
                          widget: WalletListPopover(
                            showCurrency: true,
                            label: FilterType.wallet.filterName.tr(),
                            onSelect: (wallet) {
                              context.read<ConfigCubit>().saveConfig(
                                    key: ConfigConstants.defaultWallet,
                                    type: ConfigType.string,
                                    value: wallet.clientId,
                                  );
                            },
                          ));
                    }
                    if (context.mounted) {
                      AppNavigator.pop(context);
                    }
                  },
                  title: Text(
                    option.customName.tr(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: SvgPicture.asset(
                    Assets.images.arrowRight,
                  ),
                );
              });
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 2.h);
            },
          ),
        ],
      ),
    );
  }
}
