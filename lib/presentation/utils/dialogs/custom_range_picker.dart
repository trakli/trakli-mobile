import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class CustomRangePicker extends StatefulWidget {
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final ValueChanged<PickerDateRange> onSelect;

  const CustomRangePicker({
    super.key,
    this.initialFrom,
    this.initialTo,
    required this.onSelect,
  });

  @override
  State<CustomRangePicker> createState() => _CustomRangePickerState();
}

class _CustomRangePickerState extends State<CustomRangePicker> {
  PickerDateRange? range;

  @override
  void initState() {
    range = PickerDateRange(widget.initialFrom, widget.initialTo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 20.h,
      ),
      backgroundColor: tones.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 32.h,
          horizontal: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.selectDateRange.tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: tones.textPrimary,
                  ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              readOnly: true,
              style: TextStyle(color: tones.textPrimary),
              decoration: InputDecoration(
                labelText: LocaleKeys.fromDate.tr(),
                fillColor: tones.bgSurface,
                suffixIcon: Icon(Icons.calendar_today, color: tones.textMuted),
              ),
              controller: TextEditingController(
                text: range?.startDate != null
                    ? formatDate.format(range!.startDate!)
                    : "",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: range?.startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    final endDate = range?.endDate;
                    range = PickerDateRange(picked, endDate);
                  });
                }
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              readOnly: true,
              style: TextStyle(color: tones.textPrimary),
              decoration: InputDecoration(
                labelText: LocaleKeys.toDate.tr(),
                fillColor: tones.bgSurface,
                suffixIcon: Icon(Icons.calendar_today, color: tones.textMuted),
              ),
              controller: TextEditingController(
                text: range?.endDate != null
                    ? formatDate.format(range!.endDate!)
                    : "",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: range?.endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    final startDate = range?.startDate;
                    range = PickerDateRange(startDate, picked);
                  });
                }
              },
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: range?.startDate != null && range?.endDate != null
                    ? () {
                        widget.onSelect(range!);
                        AppNavigator.pop(context);
                      }
                    : null,
                child: Text(LocaleKeys.apply.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
