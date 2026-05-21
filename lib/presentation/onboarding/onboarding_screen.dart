import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/theme_toggle_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController = PageController();
  int currentIndex = 0;

  late final List<_OnboardSlide> _slides = const [
    _OnboardSlide(
      tone: AppTone.brand,
      asset: 'assets/images/onboarding/wallet.svg',
      title: LocaleKeys.onboardTitle1,
      description: LocaleKeys.onboardDesc1,
    ),
    _OnboardSlide(
      tone: AppTone.warm,
      asset: 'assets/images/onboarding/importer.svg',
      title: LocaleKeys.onboardTitle2,
      description: LocaleKeys.onboardDesc2,
    ),
    _OnboardSlide(
      tone: AppTone.brandSoft,
      asset: 'assets/images/onboarding/ready.svg',
      title: LocaleKeys.onboardTitle3,
      description: LocaleKeys.onboardDesc3,
    ),
  ];

  void navigateToNextPage() {
    setOnboardingMode(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void nextSlide() {
    if (currentIndex >= _slides.length - 1) {
      navigateToNextPage();
      return;
    }
    pageController.nextPage(
      duration: AppMotion.slow,
      curve: AppMotion.emphasized,
    );
  }

  @override
  void reassemble() {
    pageController = PageController();
    super.reassemble();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final activeSlide = _slides[currentIndex];
    final activePalette = tones.tone(activeSlide.tone);
    final isLast = currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: tones.bgPage,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                children: [
                  const ThemeToggleButton(),
                  const Spacer(),
                  AnimatedOpacity(
                    duration: AppMotion.base,
                    opacity: isLast ? 0 : 1,
                    child: TextButton(
                      onPressed: isLast ? null : navigateToNextPage,
                      style: TextButton.styleFrom(
                        foregroundColor: tones.textSecondary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.skip.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (v) => setState(() => currentIndex = v),
                itemCount: _slides.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 8.h, 28.w, 28.h),
              child: Column(
                children: [
                  _ProgressDots(
                    count: _slides.length,
                    index: currentIndex,
                    activeColor: activePalette.deep,
                    idleColor: tones.borderMedium,
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: nextSlide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activePalette.deep,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        elevation: 0,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: AppMotion.base,
                        child: Text(
                          isLast ? LocaleKeys.go.tr() : LocaleKeys.next.tr(),
                          key: ValueKey(isLast),
                        ),
                      ),
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

class _OnboardSlide {
  final AppTone tone;
  final String? asset;
  final String title;
  final String description;

  const _OnboardSlide({
    required this.tone,
    required this.asset,
    required this.title,
    required this.description,
  });
}

class _SlidePage extends StatelessWidget {
  final _OnboardSlide slide;

  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: slide.asset != null
                  ? SvgPicture.asset(slide.asset!, fit: BoxFit.contain)
                  : const SizedBox.shrink(),
            ),
          ),
          Text(
            slide.title.tr(),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            slide.description.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              color: tones.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int count;
  final int index;
  final Color activeColor;
  final Color idleColor;

  const _ProgressDots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.idleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppMotion.base,
            curve: AppMotion.standard,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 8,
            width: i == index ? 28 : 8,
            decoration: BoxDecoration(
              color: i == index ? activeColor : idleColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
