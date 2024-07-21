import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController = PageController();
  int currentPage = 1;

  navigateToNextPage(){
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
            color: const Color(0xFF047844),
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
                  pageOne,
                  pageTwo,
                  pageThree,
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
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF047844)),
              );
            },
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 80.0,
            height: 80.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF047844),
            ),
            child: currentPage != 3
                ? IconButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                      ).then((val){
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget get pageOne {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.onboardTitle1.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        Text(
          LocaleKeys.onboardDesc1.tr(),
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        SizedBox(
          height: 80,
          width: 80,
          child: animatedProgress,
        ),
        TextButton(
          onPressed: () {
            navigateToNextPage();
          },
          child: Text(
            LocaleKeys.skip.tr(),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget get pageTwo {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.onboardTitle2.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        Text(
          LocaleKeys.onboardDesc2.tr(),
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        SizedBox(
          height: 80,
          width: 80,
          child: animatedProgress,
        ),
        TextButton(
          onPressed: () {
           navigateToNextPage();
          },
          child: Text(
            LocaleKeys.skip.tr(),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget get pageThree {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.onboardTitle3.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        Text(
          LocaleKeys.onboardDesc3.tr(),
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 20),
        SizedBox(
          height: 80,
          width: 80,
          child: animatedProgress,
        ),
        const TextButton(
          onPressed: null,
          child: Text(""),
        ),
      ],
    );
  }
}
