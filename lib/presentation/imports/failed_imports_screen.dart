import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';

class FailedImportsScreen extends StatefulWidget {
  final int importId;
  const FailedImportsScreen({super.key, required this.importId});

  @override
  State<FailedImportsScreen> createState() => _FailedImportsScreenState();
}

class _FailedImportsScreenState extends State<FailedImportsScreen> {
  // Local edits keyed by failed-row id.
  final Map<int, FailedImportEntity> _edits = {};

  @override
  void initState() {
    super.initState();
    context.read<ImportCubit>().loadFailedImports(widget.importId);
  }

  Future<void> _retry() async {
    final cubit = context.read<ImportCubit>();
    final source = cubit.state.failedImports;
    final rows = source.map((r) => _edits[r.id] ?? r).toList();
    final result = await cubit.fixFailedImports(widget.importId, rows);
    if (!mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cubit.state.failure.customMessage)),
      );
      return;
    }
    if (result.allFixed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.importAllRowsFixed.tr())),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.importSomeRowsStillFailed.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importFailedRows.tr())),
      body: BlocBuilder<ImportCubit, ImportState>(
        builder: (context, state) {
          if (state.isLoading && state.failedImports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.failedImports.isEmpty) {
            return Center(child: Text(LocaleKeys.importNoFailedRows.tr()));
          }
          return ListView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: state.failedImports.length,
            itemBuilder: (context, i) {
              final row = state.failedImports[i];
              final edited = _edits[row.id] ?? row;
              return _EditableFailedRow(
                row: edited,
                onChanged: (updated) {
                  setState(() => _edits[row.id] = updated);
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: BlocBuilder<ImportCubit, ImportState>(
            builder: (context, state) {
              return SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: state.isConfirming || state.failedImports.isEmpty
                      ? null
                      : _retry,
                  label: state.isConfirming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(LocaleKeys.importRetryAll.tr()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EditableFailedRow extends StatefulWidget {
  final FailedImportEntity row;
  final ValueChanged<FailedImportEntity> onChanged;

  const _EditableFailedRow({required this.row, required this.onChanged});

  @override
  State<_EditableFailedRow> createState() => _EditableFailedRowState();
}

class _EditableFailedRowState extends State<_EditableFailedRow> {
  late TextEditingController _amount;
  late TextEditingController _desc;
  late TextEditingController _date;
  late TextEditingController _party;
  late TextEditingController _wallet;
  late TextEditingController _category;
  late String _type;

  @override
  void initState() {
    super.initState();
    final r = widget.row;
    _amount = TextEditingController(text: r.amount ?? '');
    _desc = TextEditingController(text: r.description ?? '');
    _date = TextEditingController(text: r.date ?? '');
    _party = TextEditingController(text: r.party ?? '');
    _wallet = TextEditingController(text: r.wallet ?? '');
    _category = TextEditingController(text: r.category ?? '');
    _type = (r.type ?? 'expense').toLowerCase();
  }

  @override
  void dispose() {
    _amount.dispose();
    _desc.dispose();
    _date.dispose();
    _party.dispose();
    _wallet.dispose();
    _category.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(widget.row.copyWith(
      amount: _amount.text,
      description: _desc.text,
      date: _date.text,
      party: _party.text,
      wallet: _wallet.text,
      category: _category.text,
      type: _type,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.row.reason != null)
              Text(
                widget.row.reason!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importAmount.tr(),
                      isDense: true,
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importType.tr(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'expense', child: Text('expense')),
                      DropdownMenuItem(value: 'income', child: Text('income')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _type = v);
                      _emit();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _desc,
              decoration: InputDecoration(
                labelText: LocaleKeys.importDescription.tr(),
                isDense: true,
              ),
              onChanged: (_) => _emit(),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _party,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importParty.tr(),
                      isDense: true,
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _wallet,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importWallet.tr(),
                      isDense: true,
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _category,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importCategory.tr(),
                      isDense: true,
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _date,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.importDate.tr(),
                      hintText: 'YYYY-MM-DD',
                      isDense: true,
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
