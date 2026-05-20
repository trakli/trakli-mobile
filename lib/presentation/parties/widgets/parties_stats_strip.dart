import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/party_screen.dart' show PartyStats;
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Mobile port of PartiesStatsStrip.vue. Renders a 2x2 grid of tonal cards
/// summarizing the parties book: count, net trade, top earner, top spender.
class PartiesStatsStrip extends StatelessWidget {
  final List<PartyEntity> parties;
  final Map<String, PartyStats> stats;

  const PartiesStatsStrip({
    super.key,
    required this.parties,
    required this.stats,
  });

  ({
    double received,
    double spent,
    double net,
    PartyEntity? topEarner,
    PartyEntity? topSpender,
  }) _computeTotals() {
    double received = 0;
    double spent = 0;
    PartyEntity? topEarner;
    PartyEntity? topSpender;
    double topEarnerAmount = 0;
    double topSpenderAmount = 0;

    for (final p in parties) {
      final s = stats[p.clientId];
      final r = s?.receivedAmount ?? 0;
      final sp = s?.spentAmount ?? 0;
      received += r;
      spent += sp;
      if (r > topEarnerAmount) {
        topEarner = p;
        topEarnerAmount = r;
      }
      if (sp > topSpenderAmount) {
        topSpender = p;
        topSpenderAmount = sp;
      }
    }

    return (
      received: received,
      spent: spent,
      net: received - spent,
      topEarner: topEarner,
      topSpender: topSpender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = _computeTotals();
    final tones = context.tones;

    final cells = <_StatCell>[
      _StatCell(
        label: LocaleKeys.parties.tr(),
        value: parties.length.toString(),
        icon: Icons.people_outline,
        tone: AppTone.brand,
      ),
      _StatCell(
        label: 'Net trade',
        value: CurrencyFormater.formatAmountWithSymbol(
          context,
          totals.net,
          compact: true,
        ),
        sub: 'Lifetime',
        icon: Icons.trending_up,
        tone: totals.net >= 0 ? AppTone.income : AppTone.expense,
      ),
      _StatCell(
        label: 'Top earner',
        value: totals.topEarner?.name ?? '—',
        sub: totals.topEarner == null
            ? 'No income yet'
            : CurrencyFormater.formatAmountWithSymbol(
                context,
                stats[totals.topEarner!.clientId]?.receivedAmount ?? 0,
                compact: true,
              ),
        icon: Icons.arrow_downward,
        tone: AppTone.income,
      ),
      _StatCell(
        label: 'Top spend',
        value: totals.topSpender?.name ?? '—',
        sub: totals.topSpender == null
            ? 'No spend yet'
            : CurrencyFormater.formatAmountWithSymbol(
                context,
                stats[totals.topSpender!.clientId]?.spentAmount ?? 0,
                compact: true,
              ),
        icon: Icons.arrow_upward,
        tone: AppTone.expense,
      ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatTile(cell: cells[0])),
              const _Divider(vertical: true),
              Expanded(child: _StatTile(cell: cells[1])),
            ],
          ),
          const _Divider(vertical: false),
          Row(
            children: [
              Expanded(child: _StatTile(cell: cells[2])),
              const _Divider(vertical: true),
              Expanded(child: _StatTile(cell: cells[3])),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell {
  final String label;
  final String value;
  final String? sub;
  final IconData icon;
  final AppTone tone;

  const _StatCell({
    required this.label,
    required this.value,
    this.sub,
    required this.icon,
    required this.tone,
  });
}

class _StatTile extends StatelessWidget {
  final _StatCell cell;

  const _StatTile({required this.cell});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(cell.tone);

    return Container(
      color: palette.background,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: tones.glassBg,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: tones.borderLight),
            ),
            alignment: Alignment.center,
            child: Icon(cell.icon, size: 14.sp, color: palette.deep),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cell.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: palette.deep.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  cell.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (cell.sub != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    cell.sub!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: palette.ink.withValues(alpha: 0.6),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool vertical;
  const _Divider({required this.vertical});

  @override
  Widget build(BuildContext context) {
    final color = context.tones.borderLight;
    return vertical
        ? Container(width: 1, height: 50.h, color: color)
        : Container(height: 1, color: color);
  }
}
