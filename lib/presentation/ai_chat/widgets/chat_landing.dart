import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class ChatLanding extends StatefulWidget {
  final void Function(String) onPick;
  final ChatSessionDto? recentSession;
  final VoidCallback onContinue;
  const ChatLanding({
    super.key,
    required this.onPick,
    required this.onContinue,
    this.recentSession,
  });

  @override
  State<ChatLanding> createState() => ChatLandingState();
}

class ChatLandingState extends State<ChatLanding>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _resumeDismissed = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return LocaleKeys.aiGreetingMorning.tr();
    if (hour < 17) return LocaleKeys.aiGreetingAfternoon.tr();
    return LocaleKeys.aiGreetingEvening.tr();
  }

  /// Staggered fade + rise entrance animation for landing sections.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.07).clamp(0.0, 0.5);
    final anim = CurvedAnimation(
      parent: _anim,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 14.h * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final firstName =
        context.watch<AuthCubit>().state.user?.firstName.trim() ?? '';
    final greeting =
        firstName.isEmpty ? _greeting() : '${_greeting()}, $firstName';

    final suggestions = <String>[
      LocaleKeys.aiSuggestSpendMonth.tr(),
      LocaleKeys.aiSuggestTopCategory.tr(),
      LocaleKeys.aiSuggestIncomeVsExpense.tr(),
      LocaleKeys.aiSuggestBalance.tr(),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      children: [
        SizedBox(height: 8.h),
        _stagger(0, _hero(tones)),
        SizedBox(height: 20.h),
        _stagger(
          1,
          Text(
            greeting,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _stagger(
          2,
          Text(
            LocaleKeys.aiChatEmptyHint.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (widget.recentSession != null && !_resumeDismissed) ...[
          SizedBox(height: 20.h),
          _stagger(4, _resumeOptions(tones)),
        ],
        SizedBox(height: 24.h),
        ...suggestions.asMap().entries.map(
              (e) => _stagger(
                5 + e.key,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _suggestionChip(tones, e.value),
                ),
              ),
            ),
      ],
    );
  }

  Widget _hero(AppTones tones) {
    return Center(
      child: Container(
        width: 76.r,
        height: 76.r,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tones.brand.accent, tones.brand.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: tones.brand.deep.withAlpha(60),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.r),
        child: Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 34.r,
        ),
      ),
    );
  }

  /// Compact, vertically-stacked resume options shown under the stats slider.
  Widget _resumeOptions(AppTones tones) {
    final rawTitle = widget.recentSession?.title?.trim() ?? '';
    final title = rawTitle.isEmpty ? LocaleKeys.aiChatUntitled.tr() : rawTitle;
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: tones.textMuted, fontSize: 11.sp),
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiContinueSession.tr(),
          icon: Icons.history_rounded,
          filled: true,
          onTap: widget.onContinue,
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiStartNewSession.tr(),
          icon: Icons.add_rounded,
          filled: false,
          onTap: () => setState(() => _resumeDismissed = true),
        ),
      ],
    );
  }

  Widget _pillButton(
    AppTones tones, {
    required String label,
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    final fg = filled ? Colors.white : tones.textPrimary;
    return Center(
      child: Material(
        color: filled ? tones.brand.deep : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: filled ? null : Border.all(color: tones.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.sp, color: fg),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _suggestionChip(AppTones tones, String q) {
    return InkWell(
      onTap: () => widget.onPick(q),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: tones.bgCard,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, size: 16.sp, color: tones.brand.deep),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                q,
                style: TextStyle(
                  color: tones.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            Icon(Icons.arrow_outward_rounded,
                size: 14.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }
}
