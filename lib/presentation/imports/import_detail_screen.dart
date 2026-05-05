import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/failed_imports_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class ImportDetailScreen extends StatefulWidget {
  final int importId;
  const ImportDetailScreen({super.key, required this.importId});

  @override
  State<ImportDetailScreen> createState() => _ImportDetailScreenState();
}

class _ImportDetailScreenState extends State<ImportDetailScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ImportCubit>();
    cubit.loadImports();
    cubit.startPollingImport(widget.importId);
  }

  @override
  void dispose() {
    context.read<ImportCubit>().stopPolling();
    super.dispose();
  }

  FileImportEntity? _findImport(ImportState state) {
    for (final i in state.imports) {
      if (i.id == widget.importId) return i;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.importDetail.tr()),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            final imp = _findImport(state);
            if (imp == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroHeader(imp: imp),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!imp.isTerminal) ...[
                        const _ProcessingBanner(),
                        SizedBox(height: 20.h),
                      ],
                      if ((imp.totalRows ?? 0) > 0) ...[
                        _ProgressCard(imp: imp),
                        SizedBox(height: 16.h),
                      ],
                      _StatsRow(imp: imp),
                      SizedBox(height: 16.h),
                      if (imp.createdAt != null || imp.updatedAt != null)
                        _MetadataCard(imp: imp),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ImportCubit, ImportState>(
        builder: (context, state) {
          final imp = _findImport(state);
          if (imp == null || (imp.failedCount ?? 0) == 0) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.build_circle_outlined),
                  onPressed: () => AppNavigator.push(
                    context,
                    FailedImportsScreen(importId: imp.id),
                  ),
                  label: Text(
                    LocaleKeys.importFixFailedRows.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final FileImportEntity imp;
  const _HeroHeader({required this.imp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusIcon, statusLabel) = _statusStyle(imp.status);
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appPrimaryColor,
            appPrimaryColor.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      imp.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      imp.fileType.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              _HeroPill(
                icon: statusIcon,
                label: statusLabel,
                color: statusColor,
              ),
              SizedBox(width: 8.w),
              if ((imp.totalRows ?? 0) > 0)
                _HeroPill(
                  icon: Icons.list_alt_rounded,
                  label: '${imp.totalRows} ${LocaleKeys.importTotalRows.tr().toLowerCase()}',
                  color: Colors.white,
                  ghost: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  (Color, IconData, String) _statusStyle(String status) {
    switch (status) {
      case 'completed':
        return (const Color(0xFF1FB979), Icons.check_circle, status);
      case 'failed':
        return (appDangerColor, Icons.error, status);
      case 'partial':
        return (Colors.orange.shade600, Icons.warning_rounded, status);
      case 'processing':
      case 'pending':
      default:
        return (Colors.amber.shade300, Icons.hourglass_top_rounded, status);
    }
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool ghost;

  const _HeroPill({
    required this.icon,
    required this.label,
    required this.color,
    this.ghost = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = ghost ? Colors.white.withValues(alpha: 0.16) : color;
    final fg = ghost ? Colors.white : Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: fg),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingBanner extends StatefulWidget {
  const _ProcessingBanner();

  @override
  State<_ProcessingBanner> createState() => _ProcessingBannerState();
}

class _ProcessingBannerState extends State<_ProcessingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: appPrimaryColor.withValues(alpha: 0.08 + 0.04 * t),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: appPrimaryColor.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: appPrimaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.importProcessing.tr(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: appPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Hold tight — this updates automatically.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final FileImportEntity imp;
  const _ProgressCard({required this.imp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = imp.totalRows ?? 0;
    final success = imp.successCount ?? 0;
    final failed = imp.failedCount ?? 0;
    final processed = success + failed;
    final remaining = (total - processed).clamp(0, total);
    final pct = total == 0 ? 0 : ((processed / total) * 100).round();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '$pct%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: appPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _SegmentedBar(
              success: success,
              failed: failed,
              remaining: remaining,
            ),
            SizedBox(height: 14.h),
            Wrap(
              spacing: 14.w,
              runSpacing: 6.h,
              children: [
                _LegendDot(color: appPrimaryColor, label: '$success success'),
                _LegendDot(color: appDangerColor, label: '$failed failed'),
                if (remaining > 0)
                  _LegendDot(
                    color: theme.colorScheme.outlineVariant,
                    label: '$remaining pending',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  final int success;
  final int failed;
  final int remaining;

  const _SegmentedBar({
    required this.success,
    required this.failed,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = success + failed + remaining;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: SizedBox(
        height: 12.h,
        child: total == 0
            ? Container(color: theme.colorScheme.surfaceContainerHighest)
            : Row(
                children: [
                  if (success > 0)
                    Expanded(
                      flex: success,
                      child: Container(color: appPrimaryColor),
                    ),
                  if (failed > 0) ...[
                    if (success > 0) SizedBox(width: 2.w),
                    Expanded(
                      flex: failed,
                      child: Container(color: appDangerColor),
                    ),
                  ],
                  if (remaining > 0) ...[
                    if (success > 0 || failed > 0) SizedBox(width: 2.w),
                    Expanded(
                      flex: remaining,
                      child: Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final FileImportEntity imp;
  const _StatsRow({required this.imp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_rounded,
            label: LocaleKeys.importSuccessCount.tr(),
            value: imp.successCount?.toString() ?? '—',
            color: appPrimaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatTile(
            icon: Icons.cancel_rounded,
            label: LocaleKeys.importFailedCount.tr(),
            value: imp.failedCount?.toString() ?? '—',
            color: appDangerColor,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 20.r),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataCard extends StatelessWidget {
  final FileImportEntity imp;
  const _MetadataCard({required this.imp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          children: [
            if (imp.createdAt != null)
              _MetaRow(
                icon: Icons.upload_file_outlined,
                label: 'Imported',
                value: formatDate.format(imp.createdAt!),
              ),
            if (imp.createdAt != null && imp.updatedAt != null)
              Divider(
                height: 16.h,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            if (imp.updatedAt != null)
              _MetaRow(
                icon: Icons.update_rounded,
                label: 'Last update',
                value: formatDate.format(imp.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16.r,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
