import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/party_detail_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class PartyCard extends StatelessWidget {
  final PartyEntity party;
  final double receivedAmount;
  final double spentAmount;

  const PartyCard({
    super.key,
    required this.party,
    this.receivedAmount = 0,
    this.spentAmount = 0,
  });

  double get _netBalance => receivedAmount - spentAmount;

  AppTone _toneForBalance() {
    if (_netBalance > 0) return AppTone.income;
    if (_netBalance < 0) return AppTone.expense;
    return AppTone.brand;
  }

  Color _getAvatarColor(BuildContext context) {
    final palette = context.tones.tone(_toneForBalance());
    return palette.deep;
  }

  void _handleEdit(BuildContext context) {
    AppNavigator.push(
      context,
      AddPartyScreen(party: party),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteParty.tr(),
        subTitle:
            LocaleKeys.deletePartyConfirm.tr(namedArgs: {'name': party.name}),
        mainAction: () {
          context.read<PartyCubit>().deleteParty(party.clientId);
          AppNavigator.pop(context);
        },
        secondaryAction: () {
          AppNavigator.pop(context);
        },
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  IconData _getIconForType(PartyType? type) {
    switch (type) {
      case PartyType.individual:
        return Icons.person_outline;
      case PartyType.business:
        return Icons.business_outlined;
      case PartyType.organization:
        return Icons.corporate_fare_outlined;
      case PartyType.partnership:
        return Icons.handshake_outlined;
      case PartyType.nonProfit:
        return Icons.volunteer_activism_outlined;
      case PartyType.governmentAgency:
        return Icons.account_balance_outlined;
      case PartyType.educationalInstitution:
        return Icons.school_outlined;
      case PartyType.healthcareProvider:
        return Icons.local_hospital_outlined;
      default:
        return Icons.person_outline;
    }
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String amount,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 3.w),
          Text(
            amount,
            style: TextStyle(
              fontSize: 9.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: tones.bgSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: tones.borderLight),
          boxShadow: context.elevations.level1,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => AppNavigator.push(
            context,
            PartyDetailScreen(party: party),
          ),
          splashColor: tones.pressOverlay,
          highlightColor: tones.hoverOverlay,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getAvatarColor(context),
                    ),
                    child: Center(
                      child: party.icon != null
                          ? ImageWidget(
                              mediaEntity: party.icon,
                              accentColor: Colors.white,
                              iconSize: 28.sp,
                              emojiSize: 28.sp,
                              placeholderIcon: _getIconForType(party.type),
                            )
                          : Icon(
                              _getIconForType(party.type),
                              size: 28.sp,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    party.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (party.type != null) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        party.type!.customName,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  if (party.description != null &&
                      party.description!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      party.description!,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 11.sp),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (receivedAmount > 0 || spentAmount > 0) ...[
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      alignment: WrapAlignment.center,
                      children: [
                        if (receivedAmount > 0)
                          _buildStatChip(
                            context,
                            Icons.arrow_downward,
                            CurrencyFormater.formatAmount(
                              context,
                              receivedAmount,
                              compact: true,
                            ),
                            const Color(0xFF22C55E),
                          ),
                        if (spentAmount > 0)
                          _buildStatChip(
                            context,
                            Icons.arrow_upward,
                            CurrencyFormater.formatAmount(
                              context,
                              spentAmount,
                              compact: true,
                            ),
                            const Color(0xFFEF4444),
                          ),
                      ],
                    ),
                  ],
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4.r,
            right: 4.r,
            child: PopupMenuButton(
              icon: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: appPrimaryColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    height: 16.h,
                    width: 16.w,
                    Assets.images.more,
                    colorFilter: ColorFilter.mode(
                      appPrimaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => _handleEdit(context),
                    height: 40.h,
                    child: Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appPrimaryColor.withAlpha(50),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.edit2,
                            colorFilter: ColorFilter.mode(
                              appPrimaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(LocaleKeys.edit.tr()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => _showDeleteConfirmation(context),
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
                ];
              },
            ),
          ),
        ],
      ),
          ),
        ),
      ),
    );
  }
}
