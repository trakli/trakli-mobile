import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/party_detail_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Compact party row that visually matches the home-screen transaction
/// tile pattern: tinted leading square (tone-aware), name + secondary line,
/// net amount on the right with a chevron. Tap opens PartyDetailScreen.
class PartyListTile extends StatelessWidget {
  final PartyEntity party;
  final double receivedAmount;
  final double spentAmount;

  const PartyListTile({
    super.key,
    required this.party,
    required this.receivedAmount,
    required this.spentAmount,
  });

  double get _net => receivedAmount - spentAmount;

  AppTone get _tone {
    if (_net > 0) return AppTone.income;
    if (_net < 0) return AppTone.expense;
    return AppTone.brand;
  }

  IconData _iconForType(PartyType? type) {
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

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(_tone);
    final hasActivity = receivedAmount > 0 || spentAmount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppNavigator.push(
          context,
          PartyDetailScreen(party: party),
        ),
        splashColor: tones.pressOverlay,
        highlightColor: tones.hoverOverlay,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                alignment: Alignment.center,
                child: party.icon != null
                    ? ImageWidget(
                        mediaEntity: party.icon,
                        accentColor: palette.deep,
                        iconSize: 22.sp,
                        emojiSize: 22.sp,
                        placeholderIcon: _iconForType(party.type),
                      )
                    : Icon(
                        _iconForType(party.type),
                        size: 22.sp,
                        color: palette.deep,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    if (hasActivity)
                      _ActivityLine(
                        received: receivedAmount,
                        spent: spentAmount,
                      )
                    else
                      Text(
                        party.type?.customName ?? LocaleKeys.parties.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: tones.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormater.formatAmountWithSymbol(
                      context,
                      _net,
                      compact: true,
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: hasActivity
                          ? (_net >= 0
                              ? tones.incomeColor
                              : tones.expenseColor)
                          : tones.textMuted,
                      letterSpacing: -0.2,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'NET',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: tones.textMuted,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: tones.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityLine extends StatelessWidget {
  final double received;
  final double spent;

  const _ActivityLine({required this.received, required this.spent});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Row(
      children: [
        if (received > 0) ...[
          Icon(Icons.south_west, size: 11.sp, color: tones.incomeColor),
          SizedBox(width: 3.w),
          Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              received,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 11.sp,
              color: tones.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
        if (received > 0 && spent > 0) ...[
          SizedBox(width: 8.w),
          Container(width: 2, height: 2, color: tones.textMuted),
          SizedBox(width: 8.w),
        ],
        if (spent > 0) ...[
          Icon(Icons.north_east, size: 11.sp, color: tones.expenseColor),
          SizedBox(width: 3.w),
          Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              spent,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 11.sp,
              color: tones.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ],
    );
  }
}
