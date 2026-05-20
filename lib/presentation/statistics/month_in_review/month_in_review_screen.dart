import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Instagram-style "Month in Review" story player.
///
/// Direct port of `MonthInReview.vue`: full-screen modal, top progress bars,
/// tap-left / tap-right to navigate, tap-center to pause, and a slide per
/// data point (opening, income, spending, top category, top payee, biggest
/// expense, closing). Each slide swaps the active tonal surface so the
/// experience feels colorful and varied as the user advances.
class MonthInReviewScreen extends StatefulWidget {
  final MonthInReviewData data;

  const MonthInReviewScreen({super.key, required this.data});

  static Future<void> show(BuildContext context, MonthInReviewData data) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => MonthInReviewScreen(data: data),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<MonthInReviewScreen> createState() => _MonthInReviewScreenState();
}

class _MonthInReviewScreenState extends State<MonthInReviewScreen>
    with TickerProviderStateMixin {
  static const Duration _slideDuration = Duration(milliseconds: 6500);

  late final List<_Slide> _slides;
  late final PageController _pageController;
  late final AnimationController _progressController;
  int _currentIndex = 0;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _slides = _buildSlides(widget.data);
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _next();
        }
      });
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex >= _slides.length - 1) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _currentIndex++);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 250),
      curve: AppMotion.standard,
    );
    _progressController
      ..reset()
      ..forward();
  }

  void _prev() {
    if (_currentIndex == 0) {
      _progressController
        ..reset()
        ..forward();
      return;
    }
    setState(() => _currentIndex--);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 250),
      curve: AppMotion.standard,
    );
    _progressController
      ..reset()
      ..forward();
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _progressController.stop();
    } else {
      _progressController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];

    return Theme(
      // consistent regardless of the app's active theme.
      data: ThemeData.dark().copyWith(
        extensions: const [AppTones.dark, AppElevations.dark],
      ),
      child: Builder(builder: (context) {
        final palette = context.tones.tone(slide.tone);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.all(12.r),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Stack(
                children: [
                  // Tonal aura fills the frame behind the slide content.
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: AppMotion.slow,
                      child: Container(
                        key: ValueKey(slide.kind),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topRight,
                            radius: 1.4,
                            colors: [
                              palette.accent.withValues(alpha: 0.45),
                              palette.accent.withValues(alpha: 0.06),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Decorative dot pattern overlay.
                  const Positioned.fill(child: _DotPattern()),
                  // Slide carousel.
                  PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _slides.length,
                    itemBuilder: (_, index) {
                      return _SlideView(slide: _slides[index]);
                    },
                  ),
                  // Tap zones: left = prev, right = next, center = pause.
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _prev,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _togglePause,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _next,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _Header(
                      slides: _slides,
                      currentIndex: _currentIndex,
                      progressController: _progressController,
                      monthLabel: widget.data.monthLabel,
                      onClose: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  static List<_Slide> _buildSlides(MonthInReviewData d) {
    final cadence = d.transactionCount > 0
        ? math.max(1, (d.daysInMonth / d.transactionCount).round())
        : 0;

    final out = <_Slide>[
      _Slide(
        kind: _SlideKind.opening,
        tone: AppTone.brand,
        eyebrow: d.monthLabel,
        headline: _monthDescriptor(d.savingsRate),
        detail: 'Here is your recap.',
        icon: Icons.auto_awesome,
      ),
      if (d.income > 0)
        _Slide(
          kind: _SlideKind.income,
          tone: AppTone.income,
          eyebrow: 'Cash in',
          icon: Icons.trending_up,
          amount: d.income,
          detail: 'Money you brought home this month.',
        )
      else
        const _Slide(
          kind: _SlideKind.income,
          tone: AppTone.neutral,
          eyebrow: 'Cash in',
          icon: Icons.trending_flat,
          amount: 0,
          detail: 'No income recorded.',
        ),
      if (d.expense > 0)
        _Slide(
          kind: _SlideKind.spending,
          tone: AppTone.expense,
          eyebrow: 'Cash out',
          icon: Icons.shopping_bag_outlined,
          amount: d.expense,
          detail: 'Where your spending went.',
          footnote: d.topCategory != null
              ? '${d.topCategory!.name} led the way.'
              : null,
        ),
      if (d.topCategory != null)
        _Slide(
          kind: _SlideKind.topCategory,
          tone: AppTone.brandSoft,
          eyebrow: 'Top category',
          icon: Icons.emoji_events_outlined,
          headline: d.topCategory!.name,
          amount: d.topCategory!.amount,
          footnote: d.expense > 0
              ? '${((d.topCategory!.amount / d.expense) * 100).round()}% of your spending.'
              : null,
        ),
      if (d.topPayee != null)
        _Slide(
          kind: _SlideKind.topPayee,
          tone: AppTone.brand,
          eyebrow: 'Your favourite',
          icon: Icons.favorite_outline,
          headline: d.topPayee!.name,
          amount: d.topPayee!.amount,
          footnote: 'Total spent with this party.',
        ),
      if (d.biggestExpense != null)
        _Slide(
          kind: _SlideKind.biggest,
          tone: AppTone.expense,
          eyebrow: 'Biggest single expense',
          icon: Icons.local_fire_department_outlined,
          amount: d.biggestExpense!.amount,
          detail: d.biggestExpense!.party,
          footnote: d.biggestExpense!.category != null
              ? 'in ${d.biggestExpense!.category}'
              : null,
        ),
      _Slide(
        kind: _SlideKind.closing,
        tone: AppTone.brand,
        eyebrow: 'The recap',
        icon: Icons.celebration_outlined,
        headline: _closingHeadline(d.savingsRate),
        detail: cadence > 0
            ? '${d.transactionCount} transactions logged. Roughly one every $cadence days.'
            : '${d.transactionCount} transactions logged.',
      ),
    ];

    return out;
  }

  static String _monthDescriptor(double savingsRate) {
    if (savingsRate >= 0.3) return 'A strong saver month.';
    if (savingsRate >= 0.1) return 'A balanced month.';
    if (savingsRate >= 0) return 'A tight month.';
    return 'A stretching month.';
  }

  static String _closingHeadline(double savingsRate) {
    if (savingsRate >= 0.3) return 'Great job — you saved a chunk!';
    if (savingsRate >= 0.1) return 'Steady wins.';
    if (savingsRate >= 0) return 'You kept it close.';
    return 'A month to learn from.';
  }
}

enum _SlideKind {
  opening,
  income,
  spending,
  topCategory,
  topPayee,
  biggest,
  closing,
}

class _Slide {
  final _SlideKind kind;
  final AppTone tone;
  final String eyebrow;
  final IconData icon;
  final String? headline;
  final double? amount;
  final String? detail;
  final String? footnote;

  const _Slide({
    required this.kind,
    required this.tone,
    required this.eyebrow,
    required this.icon,
    this.headline,
    this.amount,
    this.detail,
    this.footnote,
  });
}

/// Animated count-up for monetary values inside a slide. Eases from 0 to
/// the target as soon as the slide enters the tree, so the hero number
/// "lands" rather than appearing static.
class _AnimatedAmount extends StatelessWidget {
  final double value;
  final TextStyle style;

  const _AnimatedAmount({required this.value, required this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: AppMotion.emphasized,
      builder: (ctx, v, _) {
        return Text(
          CurrencyFormater.formatAmountWithSymbol(ctx, v, compact: false),
          style: style,
        );
      },
    );
  }
}

/// Slide-up + fade entrance animation for inline slide content.
class _SlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _SlideIn({required this.child, this.delay = Duration.zero});

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<Offset> _offset =
      Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
          .animate(CurvedAnimation(parent: _c, curve: AppMotion.emphasized));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(slide.tone);

    switch (slide.kind) {
      case _SlideKind.opening:
        return _OpeningSlide(slide: slide, palette: palette);
      case _SlideKind.closing:
        return _ClosingSlide(slide: slide, palette: palette);
      case _SlideKind.income:
      case _SlideKind.spending:
      case _SlideKind.biggest:
        return _AmountSlide(slide: slide, palette: palette);
      case _SlideKind.topCategory:
      case _SlideKind.topPayee:
        return _NamedSlide(slide: slide, palette: palette);
    }
  }
}

/// Hero amount layout: huge animated number with a tinted icon orbiting
/// it. Used for "Cash in", "Cash out", and "Biggest single expense".
class _AmountSlide extends StatelessWidget {
  final _Slide slide;
  final ToneColors palette;

  const _AmountSlide({required this.slide, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.r, 90.r, 28.r, 28.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideIn(
            child: _OrbitedIcon(icon: slide.icon, palette: palette),
          ),
          const Spacer(),
          _SlideIn(
            delay: const Duration(milliseconds: 80),
            child: _Eyebrow(slide.eyebrow, color: palette.deep),
          ),
          SizedBox(height: 10.h),
          _SlideIn(
            delay: const Duration(milliseconds: 160),
            child: _AnimatedAmount(
              value: slide.amount ?? 0,
              style: TextStyle(
                fontSize: 52.sp,
                fontWeight: FontWeight.w800,
                color: palette.deep,
                letterSpacing: -1.4,
                height: 0.95,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (slide.detail != null) ...[
            SizedBox(height: 18.h),
            _SlideIn(
              delay: const Duration(milliseconds: 260),
              child: Text(
                slide.detail!,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.4,
                ),
              ),
            ),
          ],
          if (slide.footnote != null) ...[
            SizedBox(height: 18.h),
            _SlideIn(
              delay: const Duration(milliseconds: 340),
              child: _FootnotePill(slide.footnote!),
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

/// Opening slide — centered layered ring illustration with month label
/// and a welcoming display headline.
class _OpeningSlide extends StatelessWidget {
  final _Slide slide;
  final ToneColors palette;

  const _OpeningSlide({required this.slide, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.r, 90.r, 28.r, 28.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          _SlideIn(
            child: _LayeredRings(palette: palette, child: Icon(
              slide.icon, size: 44.sp, color: palette.deep,
            )),
          ),
          SizedBox(height: 28.h),
          _SlideIn(
            delay: const Duration(milliseconds: 120),
            child: _Eyebrow(slide.eyebrow, color: palette.deep, center: true),
          ),
          SizedBox(height: 12.h),
          _SlideIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              slide.headline ?? 'Your recap',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.05,
                letterSpacing: -0.8,
              ),
            ),
          ),
          if (slide.detail != null) ...[
            SizedBox(height: 12.h),
            _SlideIn(
              delay: const Duration(milliseconds: 280),
              child: Text(
                slide.detail!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.4,
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

/// Closing slide — celebratory bloom + final message + cadence detail.
class _ClosingSlide extends StatelessWidget {
  final _Slide slide;
  final ToneColors palette;

  const _ClosingSlide({required this.slide, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.r, 90.r, 28.r, 28.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          _SlideIn(
            child: _CelebrationBloom(palette: palette, icon: slide.icon),
          ),
          SizedBox(height: 28.h),
          _SlideIn(
            delay: const Duration(milliseconds: 120),
            child: _Eyebrow(slide.eyebrow, color: palette.deep, center: true),
          ),
          SizedBox(height: 12.h),
          _SlideIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              slide.headline ?? 'Done.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
                letterSpacing: -0.6,
              ),
            ),
          ),
          if (slide.detail != null) ...[
            SizedBox(height: 14.h),
            _SlideIn(
              delay: const Duration(milliseconds: 280),
              child: Text(
                slide.detail!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.5,
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

/// Named-thing slide — used for "Top category" and "Top payee". Hero
/// typography front-and-center with the amount underneath as supporting.
class _NamedSlide extends StatelessWidget {
  final _Slide slide;
  final ToneColors palette;

  const _NamedSlide({required this.slide, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.r, 90.r, 28.r, 28.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideIn(
            child: _OrbitedIcon(icon: slide.icon, palette: palette),
          ),
          const Spacer(),
          _SlideIn(
            delay: const Duration(milliseconds: 80),
            child: _Eyebrow(slide.eyebrow, color: palette.deep),
          ),
          SizedBox(height: 10.h),
          _SlideIn(
            delay: const Duration(milliseconds: 160),
            child: Text(
              slide.headline ?? '—',
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.05,
                letterSpacing: -0.8,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (slide.amount != null) ...[
            SizedBox(height: 14.h),
            _SlideIn(
              delay: const Duration(milliseconds: 260),
              child: _AnimatedAmount(
                value: slide.amount!,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.deep,
                  letterSpacing: -0.4,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
          if (slide.footnote != null) ...[
            SizedBox(height: 16.h),
            _SlideIn(
              delay: const Duration(milliseconds: 340),
              child: _FootnotePill(slide.footnote!),
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  final bool center;

  const _Eyebrow(this.text, {required this.color, this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.4,
        color: color,
      ),
    );
  }
}

class _FootnotePill extends StatelessWidget {
  final String text;
  const _FootnotePill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Tonal-icon plate with a soft halo orbit. Reused across amount + named
/// slides as the visual anchor.
class _OrbitedIcon extends StatelessWidget {
  final IconData icon;
  final ToneColors palette;

  const _OrbitedIcon({required this.icon, required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.r,
      height: 96.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft halo.
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  palette.accent.withValues(alpha: 0.4),
                  palette.accent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          // Dashed orbit.
          CustomPaint(
            size: Size(80.r, 80.r),
            painter: _DashedRingPainter(
              color: palette.accent.withValues(alpha: 0.55),
            ),
          ),
          // Inner gradient plate.
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.accent.withValues(alpha: 0.95),
                  palette.deep,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.deep.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 28.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Concentric ring illustration used on the opening slide.
class _LayeredRings extends StatelessWidget {
  final ToneColors palette;
  final Widget child;

  const _LayeredRings({required this.palette, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.r,
      height: 200.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  palette.accent.withValues(alpha: 0.4),
                  palette.accent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size(170.r, 170.r),
            painter: _DashedRingPainter(
              color: palette.accent.withValues(alpha: 0.6),
            ),
          ),
          CustomPaint(
            size: Size(120.r, 120.r),
            painter: _SolidRingPainter(
              color: palette.accent.withValues(alpha: 0.4),
            ),
          ),
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.accent,
                  palette.deep,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.deep.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Celebratory bloom illustration used on the closing slide — confetti
/// dots radiating around a center disc.
class _CelebrationBloom extends StatelessWidget {
  final ToneColors palette;
  final IconData icon;

  const _CelebrationBloom({required this.palette, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.r,
      height: 200.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  palette.accent.withValues(alpha: 0.45),
                  palette.accent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size(200.r, 200.r),
            painter: _ConfettiPainter(color: palette.accent),
          ),
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: palette.deep.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 44.sp, color: palette.deep),
          ),
        ],
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  final Color color;
  _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final radius = size.shortestSide / 2;
    const dash = 3.5, gap = 5.0;
    final circumference = 2 * math.pi * radius;
    final count = (circumference / (dash + gap)).floor();
    final step = (2 * math.pi) / count;
    final arc = (dash / circumference) * 2 * math.pi;
    for (var i = 0; i < count; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
        i * step,
        arc,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter old) => old.color != color;
}

class _SolidRingPainter extends CustomPainter {
  final Color color;
  _SolidRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.shortestSide / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SolidRingPainter old) => old.color != color;
}

class _ConfettiPainter extends CustomPainter {
  final Color color;
  _ConfettiPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(13);
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2;
    for (var i = 0; i < 22; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final distance = r * (0.55 + rng.nextDouble() * 0.45);
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * distance;
      final shapeSize = 3.0 + rng.nextDouble() * 4;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.5 + rng.nextDouble() * 0.4);
      if (i % 3 == 0) {
        canvas.drawCircle(pos, shapeSize, paint);
      } else if (i % 3 == 1) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: pos, width: shapeSize * 2.4, height: shapeSize * 0.9),
            const Radius.circular(2),
          ),
          paint,
        );
      } else {
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(width: shapeSize, height: shapeSize, center: Offset.zero),
            const Radius.circular(1.5),
          ),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.color != color;
}

class _Header extends StatelessWidget {
  final List<_Slide> slides;
  final int currentIndex;
  final AnimationController progressController;
  final String monthLabel;
  final VoidCallback onClose;

  const _Header({
    required this.slides,
    required this.currentIndex,
    required this.progressController,
    required this.monthLabel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < slides.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i == slides.length - 1 ? 0 : 4.w,
                    ),
                    child: _ProgressBar(
                      controller: progressController,
                      filled: i < currentIndex,
                      active: i == currentIndex,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              SizedBox(width: 6.w),
              Text(
                monthLabel,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.92),
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close, size: 18.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final AnimationController controller;
  final bool filled;
  final bool active;

  const _ProgressBar({
    required this.controller,
    required this.filled,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: filled
            ? Container(color: Colors.white.withValues(alpha: 0.95))
            : active
                ? AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.value,
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      );
                    },
                  )
                : const SizedBox.expand(),
      ),
    );
  }
}

class _DotPattern extends StatelessWidget {
  const _DotPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotPatternPainter(
        color: Colors.white.withValues(alpha: 0.045),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  final Color color;
  _DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 24.0;
    const radius = 1.4;
    final paint = Paint()..color = color;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x + 2, y + 2), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter old) => old.color != color;
}
