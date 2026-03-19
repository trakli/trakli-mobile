import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController = PageController();
  int currentIndex = 0;

  navigateToNextPage() {
    // Set onboarding mode to false when leaving onboarding
    setOnboardingMode(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void nextSlide() {
    if (currentIndex == 2) {
      navigateToNextPage();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 850),
        curve: Curves.decelerate,
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            height: 0.65.sh,
            child: Column(
              children: [
                SizedBox(height: 0.2.sh),
                SvgPicture.asset(
                  Assets.images.logo,
                  height: 120.h,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 0.45.sh,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        pageItem(
                          title: LocaleKeys.onboardTitle1.tr(),
                          desc: LocaleKeys.onboardDesc1.tr(),
                        ),
                        pageItem(
                          title: LocaleKeys.onboardTitle2.tr(),
                          desc: LocaleKeys.onboardDesc2.tr(),
                        ),
                        pageItem(
                          title: LocaleKeys.onboardTitle3.tr(),
                          desc: LocaleKeys.onboardDesc3.tr(),
                          isLastPage: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80.sp,
                    width: 80.sp,
                    child: animatedProgress,
                  ),
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: currentIndex != 2 ? navigateToNextPage : null,
                    child: Text(
                      currentIndex != 2 ? LocaleKeys.skip.tr() : "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get animatedProgress {
    return SfRadialGauge(
      animationDuration: 3000,
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          startAngle: 270,
          endAngle: 270,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothFlat,
            color: Color(0xFFFFFBE6),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: [
            RangePointer(
              color: Theme.of(context).primaryColor,
              value: ((currentIndex + 1) / 3) * 100,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              enableAnimation: true,
              animationDuration: 3500,
            )
          ],
          annotations: [
            GaugeAnnotation(
              widget: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    onPressed: nextSlide,
                    icon: currentIndex != 2
                        ? const Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          )
                        : Text(
                            LocaleKeys.go.tr().toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget pageItem({
    required String title,
    required String desc,
    bool isLastPage = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          desc,
          style: TextStyle(
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
