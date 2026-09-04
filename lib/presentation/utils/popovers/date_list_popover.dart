import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/custom_range_picker.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DateListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<PickerDateRange> onSelect;
  final ValueChanged<DateFilterOption> onSelectString;

  const DateListPopover({
    super.key,
    required this.label,
    required this.onSelect,
    required this.onSelectString,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: tones.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: DateFilterOption.values.length,
            itemBuilder: (context, index) {
              final option = DateFilterOption.values.elementAt(index);
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                onTap: () async {
                  if (index == DateFilterOption.values.length - 1) {
                    await showCustomDialog(
                      widget: CustomRangePicker(
                        onSelect: (range) {
                          onSelect(range);
                          onSelectString(option);
                        },
                      ),
                    );
                    if (context.mounted) {
                      AppNavigator.pop(context);
                    }
                  } else {
                    onSelect(
                      PickerDateRange(
                        getStartDateFromKey(option.name),
                        DateTime.now(),
                      ),
                    );
                    onSelectString(option);
                    if (context.mounted) {
                      AppNavigator.pop(context);
                    }
                  }
                },
                title: Text(
                  option.name.tr(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: tones.textPrimary),
                ),
                trailing: SvgPicture.asset(
                  Assets.images.arrowRight,
                  colorFilter: ColorFilter.mode(
                    tones.textMuted,
                    BlendMode.srcIn,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4.h);
            },
          ),
        ],
      ),
    );
  }
}
