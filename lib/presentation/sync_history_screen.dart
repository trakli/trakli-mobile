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
      final metadata = await _db.getLocalSyncMetadataList();
      final allChanges = await _db.select(_db.localChanges).get();

      final pending = allChanges.where((c) => c.error == null).toList();
      final failed = allChanges.where((c) => c.error != null).toList();

      if (mounted) {
        setState(() {
          _syncMetadata = metadata;
          _pendingChanges = pending;
          _failedChanges = failed;
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

  Future<void> _dismissFailedChange(LocalChange change) async {
    await (_db.delete(_db.localChanges)
          ..where((lc) =>
              lc.entityType.equals(change.entityType) &
              lc.entityId.equals(change.entityId)))
        .go();
    _loadData();
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
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSyncButton(),
                    SizedBox(height: 24.h),
                    _buildSyncStatusSection(),
                    SizedBox(height: 24.h),
                    _buildPendingChangesSection(),
                    SizedBox(height: 24.h),
                    _buildFailedChangesSection(),
                  ],
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
                return ListTile(
                  dense: true,
                  title: Text(
                    _getEntityTypeDisplayName(meta.entityType),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  trailing: Text(
                    _formatDateTime(meta.lastSyncedAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
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
                      } else if (value == 'dismiss') {
                        _dismissFailedChange(change);
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
                      PopupMenuItem(
                        value: 'dismiss',
                        child: Row(
                          children: [
                            const Icon(Icons.close, size: 18),
                            SizedBox(width: 8.w),
                            Text(LocaleKeys.dismiss.tr()),
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
