import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryWidget extends StatelessWidget {
  final String value;
  final String description;
  final Color? color;
  final bool showXaf;

  const SummaryWidget({
    super.key,
    required this.value,
    required this.description,
    this.color,
    this.showXaf = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB8BBB4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 44.sp,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              ),
              if (showXaf)
                Text(
                  "XAF",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: color ?? Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
