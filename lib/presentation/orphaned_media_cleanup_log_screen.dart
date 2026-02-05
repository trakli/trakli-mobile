import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/services/orphaned_media_cleanup_service.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

/// Debug-only screen that shows the last orphaned media cleanup log content.
class OrphanedMediaCleanupLogScreen extends StatelessWidget {
  const OrphanedMediaCleanupLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.orphanedMediaCleanupLog.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
      ),
      body: FutureBuilder<String?>(
        future: getOrphanedMediaCleanupLogContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final content = snapshot.data;
          if (content == null || content.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  LocaleKeys.orphanedMediaCleanupLogEmpty.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: SelectableText(
              content,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
    );
  }
}
