import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _thresholdController = TextEditingController(text: '80');
  BudgetPeriodType _periodType = BudgetPeriodType.monthly;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _rolloverEnabled = false;
  bool _forecastAlertsEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _currencyController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<BudgetCubit>().addBudget(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      currency: _currencyController.text.trim().toUpperCase(),
      periodType: _periodType,
      startDate: _startDate,
      endDate: _periodType == BudgetPeriodType.custom ? _endDate : null,
      rolloverEnabled: _rolloverEnabled,
      thresholdPercent: int.parse(_thresholdController.text.trim()),
      forecastAlertsEnabled: _forecastAlertsEnabled,
      isActive: true,
      targets: const [],
    );

    if (!mounted) return;
    final state = context.read<BudgetCubit>().state;
    if (!state.failure.hasError) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: 'Budgets',
        headerTextColor: const Color(0xFFEBEDEC),
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.failure.hasError) ...[
                    Text(
                      state.failure.customMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(value?.trim() ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _currencyController,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 3,
                    validator: (value) {
                      if ((value ?? '').trim().length != 3) {
                        return 'Use a 3-letter currency code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<BudgetPeriodType>(
                    value: _periodType,
                    decoration: const InputDecoration(labelText: 'Period'),
                    items: BudgetPeriodType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.serverKey.tr()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _periodType = value);
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Start date'),
                    subtitle: Text(DateFormat.yMMMd().format(_startDate)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickStartDate,
                  ),
                  if (_periodType == BudgetPeriodType.custom)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('End date'),
                      subtitle: Text(
                        _endDate == null
                            ? 'Required for custom period'
                            : DateFormat.yMMMd().format(_endDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: _pickEndDate,
                    ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _thresholdController,
                    decoration: const InputDecoration(
                      labelText: 'Alert threshold percent',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsed = int.tryParse(value?.trim() ?? '');
                      if (parsed == null || parsed < 0 || parsed > 100) {
                        return 'Use a value from 0 to 100';
                      }
                      return null;
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Rollover'),
                    value: _rolloverEnabled,
                    onChanged: (value) =>
                        setState(() => _rolloverEnabled = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Forecast alerts'),
                    value: _forecastAlertsEnabled,
                    onChanged: (value) =>
                        setState(() => _forecastAlertsEnabled = value),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: state.isSaving ? null : _submit,
                    child: state.isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(LocaleKeys.save.tr()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
