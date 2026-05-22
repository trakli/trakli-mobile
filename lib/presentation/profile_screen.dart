import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/usecases/sync/check_pending_changes_usecase.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_info_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/benefits/benefits_widget.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Check for pending changes
    final checkPendingChangesUsecase = getIt<CheckPendingChangesUsecase>();
    final result = await checkPendingChangesUsecase(NoParams());

    result.fold(
      (failure) {
        // If there's an error checking pending changes, show regular logout dialog
        _showLogoutDialog(context);
      },
      (hasPendingChanges) {
        if (hasPendingChanges) {
          // Show warning dialog with sync option
          _showLogoutWarningDialog(context);
        } else {
          // No pending changes, show regular logout dialog
          _showLogoutDialog(context);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logOut.tr(),
        subTitle: LocaleKeys.logoutConfirm.tr(),
        dialogType: DialogType.negative,
        mainAction: () {
          context.read<AuthCubit>().logout();
        },
      ),
    );
  }

  void _showLogoutWarningDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logoutWarningTitle.tr(),
        subTitle: LocaleKeys.logoutWarningMessage.tr(),
        dialogType: DialogType.negative,
        mainActionText: LocaleKeys.logoutAnyway.tr(),
        secondaryActionText: LocaleKeys.syncNow.tr(),
        buttonLayout: ButtonLayout.vertical,
        mainAction: () {
          // Logout anyway
          context.read<AuthCubit>().logout();
        },
        secondaryAction: () {
          // Sync now
          getIt<SynchAppDatabase>().sync();
          AppNavigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    final tones = context.tones;

    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.profile.tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(user: user),
            SizedBox(height: 18.h),
            if (user != null) ...[
              const PremiumTile(),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: tones.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: tones.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: tones.borderLight),
                  boxShadow: context.elevations.level1,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _ProfileActionTile(
                      iconPath: Assets.images.user,
                      label: LocaleKeys.accountInfo.tr(),
                      tone: AppTone.brand,
                      onTap: () => AppNavigator.push(
                        context,
                        const AccountInfoScreen(),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 60.w,
                      color: tones.borderLight.withValues(alpha: 0.6),
                    ),
                    _ProfileActionTile(
                      iconPath: Assets.images.logout,
                      label: LocaleKeys.logOut.tr(),
                      tone: AppTone.expense,
                      onTap: () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
            ] else
              const BenefitsWidget(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(AppTone.brand);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: palette.accent.withValues(alpha: 0.5)),
      ),
      child: Stack(
        children: [
          // Soft bloom for visual weight without a banner feel.
          Positioned(
            top: -80.r,
            right: -80.r,
            child: IgnorePointer(
              child: Container(
                width: 220.r,
                height: 220.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      palette.accent.withValues(alpha: 0.32),
                      palette.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _InitialsAvatar(
                  user: user,
                  size: 64.r,
                  shadowColor: palette.deep.withValues(alpha: 0.18),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.fullName ?? LocaleKeys.anonymous.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      if (user != null)
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: tones.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        Text(
                          'Not signed in',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: tones.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (user != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: tones.glassBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: tones.borderLight),
                        ),
                        child: SvgPicture.asset(
                          Assets.images.edit2,
                          height: 16.h,
                          width: 16.w,
                          colorFilter: ColorFilter.mode(
                            palette.deep,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final String iconPath;
  final String label;
  final AppTone tone;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.iconPath,
    required this.label,
    required this.tone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  width: 18.w,
                  height: 18.h,
                  colorFilter:
                      ColorFilter.mode(palette.deep, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: tones.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: tones.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final dynamic user;
  final double size;
  final Color shadowColor;

  const _InitialsAvatar({
    required this.user,
    required this.size,
    required this.shadowColor,
  });

  String _initials() {
    final name = user?.fullName as String?;
    if (name == null || name.trim().isEmpty) return '?';
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Color _bgColor() {
    const palette = [
      Color(0xFFB6E3F4),
      Color(0xFFC4B5FD),
      Color(0xFFA78BFA),
      Color(0xFFFB7185),
      Color(0xFFFDBA74),
      Color(0xFFFDE047),
      Color(0xFFA7F3D0),
      Color(0xFFFBB6CE),
      Color(0xFF93C5FD),
    ];
    final seed = (user?.email ?? user?.fullName ?? 'guest').toString();
    var hash = 0;
    for (var i = 0; i < seed.length; i++) {
      hash = (hash * 31 + seed.codeUnitAt(i)) & 0x7fffffff;
    }
    return palette[hash % palette.length];
  }

  Color _onColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.55
        ? const Color(0xFF1F2937)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(),
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w800,
          color: _onColor(bg),
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
