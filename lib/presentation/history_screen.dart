import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF047844),
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.transactionHistory.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Filter By ...",
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.filter,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              onTap: () async {},
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFB8BBB4),
                  )),
              child: ListView(
                shrinkWrap: true,
                children: List.generate(
                  5,
                  (index) => TransactionTile(
                    transactionType: (index % 2 == 0)
                        ? TransactionType.income
                        : TransactionType.expense,
                    accentColor: (index % 2 == 0)
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFEB5757),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
