import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class SyncHistoryScreen extends StatefulWidget {
  const SyncHistoryScreen({super.key});

  @override
  State<SyncHistoryScreen> createState() => _SyncHistoryScreenState();
}

class _SyncHistoryScreenState extends State<SyncHistoryScreen> {
  final AppDatabase _db = getIt<AppDatabase>();
  final SynchAppDatabase _syncDb = getIt<SynchAppDatabase>();

  List<LocalSyncMetadata> _syncMetadata = [];
  List<LocalChange> _pendingChanges = [];
  List<LocalChange> _failedChanges = [];
  List<LocalChange> _quarantinedChanges = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _syncDb.syncStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isSyncing = state.isSynchronizing;
        });
        if (!state.isSynchronizing) {
          _loadData();
        }
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final savedMetadata = await _db.getLocalSyncMetadataList();
      final metadataByType = {
        for (final item in savedMetadata) item.entityType: item,
      };
      final metadata = _syncDb.typeHandlers
          .where((handler) => !handler.skipDownSync)
          .map((handler) =>
              metadataByType[handler.entityType] ??
              LocalSyncMetadata(entityType: handler.entityType))
          .toList()
        ..sort((a, b) => a.entityType.compareTo(b.entityType));
      final allChanges = await _db.select(_db.localChanges).get();

      // Quarantined changes are permanently failed and never retry
      // automatically; keep them out of the transient "failed" bucket.
      final pending = allChanges
          .where((c) => c.error == null && c.quarantinedAt == null)
          .toList();
      final failed = allChanges
          .where((c) => c.error != null && c.quarantinedAt == null)
          .toList();
      final quarantined =
          allChanges.where((c) => c.quarantinedAt != null).toList();

      if (mounted) {
        setState(() {
          _syncMetadata = metadata;
          _pendingChanges = pending;
          _failedChanges = failed;
          _quarantinedChanges = quarantined;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Error loading sync data: $e\n$st');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _triggerSync() async {
    setState(() => _isSyncing = true);
    try {
      await _syncDb.sync();
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
        _loadData();
      }
    }
  }

  Future<void> _retryFailedChange(LocalChange change) async {
    await (_db.update(_db.localChanges)
          ..where((lc) =>
              lc.entityType.equals(change.entityType) &
              lc.entityId.equals(change.entityId)))
        .write(const LocalChangesCompanion(error: Value(null)));
    _loadData();
    _triggerSync();
  }

  /// Un-quarantine: clear the error, lift quarantine, and reset the attempt
  /// counter so the change re-enters the normal retry path immediately.
  Future<void> _retryQuarantinedChange(LocalChange change) async {
    await (_db.update(_db.localChanges)
          ..where((lc) =>
              lc.entityType.equals(change.entityType) &
              lc.entityId.equals(change.entityId)))
        .write(const LocalChangesCompanion(
      error: Value(null),
      quarantinedAt: Value(null),
      attemptCount: Value(0),
    ));
    _loadData();
    _triggerSync();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return LocaleKeys.notSet.tr();
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime.toLocal());
  }

  String _getEntityTypeDisplayName(String entityType) {
    switch (entityType) {
      case 'transaction':
        return LocaleKeys.transaction.tr();
      case 'category':
        return LocaleKeys.category.tr();
      case 'wallet':
        return LocaleKeys.wallet.tr();
      case 'party':
        return LocaleKeys.party.tr();
      case 'group':
        return LocaleKeys.group.tr();
      case 'transfer':
        return LocaleKeys.transfer.tr();
      case 'budget':
        return LocaleKeys.budget.tr();
      case 'budget_period_state':
        return LocaleKeys.budgetPeriod.tr();
      case 'notification':
        return LocaleKeys.notifications.tr();
      case 'reminder':
        return LocaleKeys.reminders.tr();
      case 'config':
        return LocaleKeys.settings.tr();
      default:
        return entityType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.synchronization.tr(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 16.h,
                    bottom: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSyncButton(),
                      SizedBox(height: 24.h),
                      _buildSyncStatusSection(),
                      SizedBox(height: 24.h),
                      if (_quarantinedChanges.isNotEmpty) ...[
                        _buildQuarantinedSection(),
                        SizedBox(height: 24.h),
                      ],
                      _buildPendingChangesSection(),
                      SizedBox(height: 24.h),
                      _buildFailedChangesSection(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSyncButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSyncing ? null : _triggerSync,
        icon: _isSyncing
            ? SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.sync),
        label: Text(
          _isSyncing ? LocaleKeys.synchronizing.tr() : LocaleKeys.syncNow.tr(),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSyncStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.lastSyncStatus.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        if (_syncMetadata.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  LocaleKeys.noSyncHistory.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _syncMetadata.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final meta = _syncMetadata[index];
                final error = meta.lastError;
                return ListTile(
                  dense: true,
                  onTap: error == null
                      ? null
                      : () => _showModelSyncError(meta, error),
                  title: Text(
                    _getEntityTypeDisplayName(meta.entityType),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: error == null
                      ? null
                      : Text(
                          error,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: context.tones.expense.deep,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Kept alongside the error so a failing model still
                      // shows when it was last tried.
                      Text(
                        _formatDateTime(meta.lastAttemptedAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.tones.textMuted,
                        ),
                      ),
                      if (error != null) ...[
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.error,
                          color: context.tones.expense.deep,
                          size: 20.sp,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPendingChangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.pendingChanges.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _pendingChanges.length.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (_pendingChanges.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  LocaleKeys.noPendingChanges.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pendingChanges.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final change = _pendingChanges[index];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    change.deleted ? Icons.delete : Icons.upload,
                    size: 20.sp,
                    color: change.deleted ? Colors.red : Colors.blue,
                  ),
                  title: Text(
                    _getEntityTypeDisplayName(change.entityType),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    _formatDateTime(change.createAt),
                    style: TextStyle(fontSize: 11.sp),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  /// Full error text plus the queued request payload, so validation
  /// failures show exactly what the server received.
  /// Down-sync failures have no queued change to inspect, so the error is
  /// only recoverable from the model's sync metadata.
  void _showModelSyncError(LocalSyncMetadata meta, String error) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getEntityTypeDisplayName(meta.entityType)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${LocaleKeys.lastAttempted.tr()}: '
                  '${_formatDateTime(meta.lastAttemptedAt)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.tones.textMuted,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SelectableText(
                    error,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'monospace',
                      color: context.tones.expense.deep,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.done.tr()),
          ),
        ],
      ),
    );
  }

  void _showChangeDetails(LocalChange change) {
    final payload = const JsonEncoder.withIndent('  ').convert(change.data);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getEntityTypeDisplayName(change.entityType)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (change.error != null) ...[
                  SelectableText(
                    change.error!,
                    style: TextStyle(fontSize: 12.sp, color: Colors.red[700]),
                  ),
                  SizedBox(height: 12.h),
                ],
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SelectableText(
                    payload,
                    style: TextStyle(fontSize: 11.sp, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.done.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarantinedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.report_problem, size: 18.sp, color: Colors.orange[800]),
            SizedBox(width: 6.w),
            Text(
              LocaleKeys.needsAttention.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _quarantinedChanges.length.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          LocaleKeys.quarantinedHint.tr(),
          style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 8.h),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quarantinedChanges.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final change = _quarantinedChanges[index];
              return ListTile(
                dense: true,
                leading: Icon(Icons.report_problem,
                    size: 20.sp, color: Colors.orange[800]),
                title: Text(
                  _getEntityTypeDisplayName(change.entityType),
                  style: TextStyle(fontSize: 14.sp),
                ),
                subtitle: Text(
                  change.error ?? '',
                  style: TextStyle(fontSize: 11.sp, color: Colors.orange[900]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 20.sp),
                  onSelected: (value) {
                    if (value == 'retry') {
                      _retryQuarantinedChange(change);
                    } else if (value == 'details') {
                      _showChangeDetails(change);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 18),
                          SizedBox(width: 8),
                          Text('View details'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'retry',
                      child: Row(
                        children: [
                          const Icon(Icons.refresh, size: 18),
                          SizedBox(width: 8.w),
                          Text(LocaleKeys.retry.tr()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFailedChangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.failedChanges.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            if (_failedChanges.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _failedChanges.length.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        if (_failedChanges.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  LocaleKeys.noFailedChanges.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _failedChanges.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final change = _failedChanges[index];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.error_outline,
                    size: 20.sp,
                    color: Colors.red,
                  ),
                  title: Text(
                    _getEntityTypeDisplayName(change.entityType),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    change.error ?? '',
                    style: TextStyle(fontSize: 11.sp, color: Colors.red[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20.sp),
                    onSelected: (value) {
                      if (value == 'retry') {
                        _retryFailedChange(change);
                      } else if (value == 'details') {
                        _showChangeDetails(change);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18),
                            SizedBox(width: 8),
                            Text('View details'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'retry',
                        child: Row(
                          children: [
                            const Icon(Icons.refresh, size: 18),
                            SizedBox(width: 8.w),
                            Text(LocaleKeys.retry.tr()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
