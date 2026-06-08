import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/notifications/cubit/notification_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/notification_tile.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: Scaffold(
        appBar: PageAppBar(
          title: LocaleKeys.notifications.tr(),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(appPrimaryColor),
                ),
              );
            }

            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.images.notificationBing,
                      width: 64.w,
                      height: 64.h,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade300,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No notifications',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationCubit>().loadNotifications();
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 15.h,
                ),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return NotificationTile(
                    notification: notification,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
