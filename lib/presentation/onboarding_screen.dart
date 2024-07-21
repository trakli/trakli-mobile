import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController = PageController();
  int currentPage = 1;

  navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                SvgPicture.asset(Assets.images.logo),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.45,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: PageView(
                controller: pageController,
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
          ),
        ],
      ),
    );
  }

  Widget get animatedProgress {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Builder(
            builder: (context) {
              return CircularProgressIndicator(
                value: currentPage / 3,
                strokeWidth: 6,
                backgroundColor: const Color(0xFFFFFBE6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 80.0.sp,
            height: 80.0.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: currentPage != 3
                ? IconButton(
                    onPressed: () {
                      pageController
                          .nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                      )
                          .then((val) {
                        setState(() {
                          currentPage += 1;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                    ),
                  )
                : Center(
                    child: TextButton(
                      onPressed: () {
                        navigateToNextPage();
                      },
                      child: Text(
                        LocaleKeys.go.tr().toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget pageItem({
    required String title,
    required String desc,
    bool isLastPage = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        Text(
          desc,
          style: TextStyle(
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        SizedBox(
          height: 80.sp,
          width: 80.sp,
          child: animatedProgress,
        ),
        TextButton(
          onPressed: isLastPage ? null : () {
            navigateToNextPage();
          },
          child: Text(
            isLastPage ? "" : LocaleKeys.skip.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
