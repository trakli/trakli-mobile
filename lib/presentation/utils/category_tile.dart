import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final Color accentColor;
  final CategoryModel category;
  final bool showStat;

  const CategoryTile({
    super.key,
    required this.category,
    this.accentColor = const Color(0xFFEB5757),
    this.showStat = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          category.icon,
          size: 20.sp,
          color: accentColor,
        ),
      ),
      title: Text(
        category.name,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF061D23),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        showStat
            ? "0 transactions in 2 wallets"
            : "Here you store your office Elements",
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF576760),
        ),
      ),
      trailing: const Icon(Icons.menu),
    );
  }
}
