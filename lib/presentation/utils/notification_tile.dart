import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/notifications/cubit/notification_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  static Color getTypeColor(NotificationType type, AppTones tones) {
    return switch (type) {
      NotificationType.reminder => tones.accentWarm,
      NotificationType.alert => tones.expense.accent,
      NotificationType.achievement => tones.accentWarm,
      NotificationType.system => tones.brand.deep,
    };
  }

  static String getTypeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => LocaleKeys.notificationTypeReminder.tr(),
      NotificationType.alert => LocaleKeys.notificationTypeAlert.tr(),
      NotificationType.achievement =>
        LocaleKeys.notificationTypeAchievement.tr(),
      NotificationType.system => LocaleKeys.notificationTypeSystem.tr(),
    };
  }

  static IconData getTypeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => Icons.schedule_outlined,
      NotificationType.alert => Icons.warning_amber_rounded,
      NotificationType.achievement => Icons.stars_rounded,
      NotificationType.system => Icons.info_outline,
    };
  }

  void _handleTap(BuildContext context) {
    final isRead = notification.readAt != null;
    if (!isRead) {
      context.read<NotificationCubit>().markAsRead(notification.clientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final isRead = notification.readAt != null;
    final typeColor = getTypeColor(notification.type, tones);
    final typeLabel = getTypeLabel(notification.type);
    final iconData = getTypeIcon(notification.type);

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(AppRadii.md.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isRead ? tones.bgCard : tones.bgSurface,
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          border: Border.all(
            color: tones.borderLight,
            width: 1,
          ),
          boxShadow: isRead ? null : context.elevations.level1,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadii.sm.r),
              ),
              child: Icon(
                iconData,
                size: 24.r,
                color: typeColor,
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadii.xs.r),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: typeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: tones.brand.deep,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isRead ? tones.textSecondary : tones.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isRead ? tones.textMuted : tones.textSecondary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm')
                        .format(notification.createdAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: tones.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
