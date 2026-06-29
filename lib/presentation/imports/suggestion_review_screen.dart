import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/entities/import/import_session_status.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/widgets/suggestion_card.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class SuggestionReviewScreen extends StatefulWidget {
  final int sessionId;
  const SuggestionReviewScreen({super.key, required this.sessionId});

  @override
  State<SuggestionReviewScreen> createState() => _SuggestionReviewScreenState();
}

class _SuggestionReviewScreenState extends State<SuggestionReviewScreen> {
  final Map<int, TransactionSuggestionEntity> _edits = {};
  final Map<int, bool> _accepted = {};

  final Set<int> _autoMatchedSessions = {};

  bool _autoCreateWallets = false;
  bool _autoCreateParties = false;
  bool _autoCreateCategories = false;

  late final ImportCubit _importCubit;

  @override
  void initState() {
    super.initState();
    _importCubit = context.read<ImportCubit>();
    _importCubit.loadSession(widget.sessionId);
    _importCubit.startPollingSession(widget.sessionId);
    context.read<WalletCubit>().loadWallets();
    context.read<PartyCubit>().getParties();
    context.read<CategoryCubit>().loadCategories();
  }

  @override
  void dispose() {
    _importCubit.stopPolling();
    super.dispose();
  }

  void _maybeAutoMatch(ImportSessionEntity session) {
    if (_autoMatchedSessions.contains(session.id)) return;
    final wallets = context.read<WalletCubit>().state.wallets;
    final parties = context.read<PartyCubit>().state.parties;
    final categories = context.read<CategoryCubit>().state.categories;
    if (wallets.isEmpty && parties.isEmpty && categories.isEmpty) return;

    final newEdits = <int, TransactionSuggestionEntity>{};
    for (final entry in session.suggestions.asMap().entries) {
      final i = entry.key;
      final base = entry.value;
      var entity = _edits[i] ?? base;
      var changed = false;

      final walletMatch = _findByName<WalletEntity>(
        wallets,
        entity.wallet,
        (w) => w.name,
      );
      if (entity.walletId == null && walletMatch?.id != null) {
        entity = entity.withWalletId(walletMatch!.id);
        changed = true;
      }

      final partyMatch = _findByName<PartyEntity>(
        parties,
        entity.party,
        (p) => p.name,
      );
      if (entity.partyId == null && partyMatch?.id != null) {
        entity = entity.withPartyId(partyMatch!.id);
        changed = true;
      }

      final categoryMatch = _findByName<CategoryEntity>(
        categories,
        entity.category,
        (c) => c.name,
      );
      if (entity.categoryId == null && categoryMatch?.id != null) {
        entity = entity.withCategoryId(categoryMatch!.id);
        changed = true;
      }

      if (changed) newEdits[i] = entity;
    }

    _autoMatchedSessions.add(session.id);
    if (newEdits.isEmpty) return;
    setState(() => _edits.addAll(newEdits));
  }

  T? _findByName<T>(List<T> items, String? name, String Function(T) nameOf) {
    final needle = _normalize(name);
    if (needle == null) return null;
    for (final item in items) {
      if (_normalize(nameOf(item)) == needle) return item;
    }
    return null;
  }

  String? _normalize(String? s) {
    final v = s?.trim().toLowerCase();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  List<AcceptedSuggestion> _acceptedSuggestions(ImportSessionEntity session) {
    final accepted = <AcceptedSuggestion>[];
    for (final entry in session.suggestions.asMap().entries) {
      final i = entry.key;
      final suggestion = entry.value;
      final isAccepted = _accepted[i] ?? true;
      if (!isAccepted) continue;
      accepted.add((
        index: i,
        suggestion: _edits[i] ?? suggestion,
      ));
    }
    return accepted;
  }

  Future<void> _onConfirmTap(ImportSessionEntity session) async {
    final accepted = _acceptedSuggestions(session);
    if (accepted.isEmpty) {
      showSnackBar(
        message: LocaleKeys.importNoAcceptedSuggestions.tr(),
        borderRadius: 8.r,
        backgroundColor: Colors.orange,
        isFloating: false,
      );
      return;
    }

    final missingWallets =
        accepted.where((a) => a.suggestion.walletId == null).length;
    final missingParties =
        accepted.where((a) => a.suggestion.partyId == null).length;
    final missingCategories =
        accepted.where((a) => a.suggestion.categoryId == null).length;

    final shouldRun = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetCtx) {
        return _ConfirmSheet(
          acceptedCount: accepted.length,
          totalCount: session.suggestions.length,
          missingWallets: missingWallets,
          missingParties: missingParties,
          missingCategories: missingCategories,
          initialAutoCreateWallets: _autoCreateWallets,
          initialAutoCreateParties: _autoCreateParties,
          initialAutoCreateCategories: _autoCreateCategories,
          onSubmit: (w, p, c) {
            setState(() {
              _autoCreateWallets = w;
              _autoCreateParties = p;
              _autoCreateCategories = c;
            });
            Navigator.of(sheetCtx).pop(true);
          },
        );
      },
    );

    if (shouldRun != true || !mounted) return;
    await _runConfirm(session, accepted);
  }

  Future<void> _runConfirm(
    ImportSessionEntity session,
    List<AcceptedSuggestion> accepted,
  ) async {
    final cubit = context.read<ImportCubit>();
    final result = await cubit.confirmSession(
      sessionId: widget.sessionId,
      accepted: accepted,
      autoCreateWallets: _autoCreateWallets,
      autoCreateParties: _autoCreateParties,
      autoCreateCategories: _autoCreateCategories,
    );
    if (!mounted) return;
    if (result == null) {
      showSnackBar(
        message: cubit.state.failure,
        borderRadius: 8.r,
        backgroundColor: appDangerColor,
        isFloating: false,
      );
      return;
    }
    showSnackBar(
      message: LocaleKeys.importCreatedCount
          .tr(args: [result.createdCount.toString()]),
      borderRadius: 8.r,
      backgroundColor: Colors.green,
      isFloating: false,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importReviewSuggestions.tr())),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            final session = state.currentSession;
            return _buildBody(session);
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ImportCubit, ImportState>(
        builder: (context, state) {
          final session = state.currentSession;
          final showConfirm = session != null &&
              session.status == ImportSessionStatus.ready &&
              session.suggestions.isNotEmpty;
          if (!showConfirm) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state.isConfirming ? null : () => _onConfirmTap(session),
                  child: state.isConfirming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline),
                            SizedBox(width: 8.w),
                            Text(LocaleKeys.importConfirm.tr()),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ImportSessionEntity? session) {
    if (session == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (session.status.isInFlight) {
      return _StageLoader(
        step: session.status.stepNumber!,
        totalSteps: ImportSessionStatus.totalSteps,
        label: _labelForInFlightStatus(session.status),
      );
    }

    // Empty suggestions take priority over the failed-status banner.
    if (session.suggestions.isEmpty) {
      return const _NoSuggestions();
    }

    if (session.status == ImportSessionStatus.failed) {
      return const _AnalysisFailed();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeAutoMatch(session);
    });

    return ListView(
      padding: EdgeInsets.all(12.w),
      children: session.suggestions.asMap().entries.map((entry) {
        final i = entry.key;
        final s = entry.value;
        final accepted = _accepted[i] ?? true;
        return SuggestionCard(
          position: i,
          suggestion: _edits[i] ?? s,
          accepted: accepted,
          onAcceptedChanged: (v) => setState(() => _accepted[i] = v),
          onChanged: (updated) => setState(() => _edits[i] = updated),
        );
      }).toList(),
    );
  }

  /// Localized label for each in-flight stage. Caller guarantees [status]
  /// is one of the four in-flight values via [ImportSessionStatus.isInFlight].
  String _labelForInFlightStatus(ImportSessionStatus status) {
    return switch (status) {
      ImportSessionStatus.analyzing => LocaleKeys.importAnalyzing.tr(),
      ImportSessionStatus.extracting => LocaleKeys.importExtracting.tr(),
      ImportSessionStatus.enriching => LocaleKeys.importEnriching.tr(),
      ImportSessionStatus.checking => LocaleKeys.importCheckingDuplicates.tr(),
      _ => '',
    };
  }
}

class _StageLoader extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String label;

  const _StageLoader({
    required this.step,
    required this.totalSteps,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(color: theme.colorScheme.primary, size: 56.r),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              'Step $step of $totalSteps',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnalysisFailed extends StatelessWidget {
  const _AnalysisFailed();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56.r,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.importAnalysisFailed.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.importAnalysisFailedHint.tr(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              label: Text(LocaleKeys.cancel.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSuggestions extends StatelessWidget {
  const _NoSuggestions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.r,
              height: 96.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48.r,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.importNoSuggestions.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              label: Text(LocaleKeys.cancel.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmSheet extends StatefulWidget {
  final int acceptedCount;
  final int totalCount;
  final int missingWallets;
  final int missingParties;
  final int missingCategories;
  final bool initialAutoCreateWallets;
  final bool initialAutoCreateParties;
  final bool initialAutoCreateCategories;
  final void Function(bool wallets, bool parties, bool categories) onSubmit;

  const _ConfirmSheet({
    required this.acceptedCount,
    required this.totalCount,
    required this.missingWallets,
    required this.missingParties,
    required this.missingCategories,
    required this.initialAutoCreateWallets,
    required this.initialAutoCreateParties,
    required this.initialAutoCreateCategories,
    required this.onSubmit,
  });

  @override
  State<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends State<_ConfirmSheet> {
  late bool _autoCreateWallets = widget.initialAutoCreateWallets;
  late bool _autoCreateParties = widget.initialAutoCreateParties;
  late bool _autoCreateCategories = widget.initialAutoCreateCategories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.importConfirmSheetTitle.tr(args: [
                widget.acceptedCount.toString(),
                widget.totalCount.toString(),
              ]),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16.h),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateWallets.tr(),
              missingCount: widget.missingWallets,
              value: _autoCreateWallets,
              onChanged: (v) => setState(() => _autoCreateWallets = v),
            ),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateParties.tr(),
              missingCount: widget.missingParties,
              value: _autoCreateParties,
              onChanged: (v) => setState(() => _autoCreateParties = v),
            ),
            _MissingSwitch(
              label: LocaleKeys.importAutoCreateCategories.tr(),
              missingCount: widget.missingCategories,
              value: _autoCreateCategories,
              onChanged: (v) => setState(() => _autoCreateCategories = v),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => widget.onSubmit(
                  _autoCreateWallets,
                  _autoCreateParties,
                  _autoCreateCategories,
                ),
                label: Text(LocaleKeys.importCreateTransactions.tr()),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neutralN40,
                  foregroundColor: neutralN900,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocaleKeys.cancel.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingSwitch extends StatelessWidget {
  final String label;
  final int missingCount;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MissingSwitch({
    required this.label,
    required this.missingCount,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hint = missingCount == 0
        ? LocaleKeys.importAutoCreateNoneNeeded.tr()
        : LocaleKeys.importAutoCreateMissingHint
            .tr(args: [missingCount.toString()]);
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(hint),
      value: value,
      onChanged: missingCount == 0 ? null : onChanged,
    );
  }
}
