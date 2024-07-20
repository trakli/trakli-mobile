import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF047844),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(Assets.images.topRightCircle),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(Assets.images.bottomLeftCircle),
          ),
          Center(
            child: SvgPicture.asset(Assets.images.logo),
          )
        ],
      ),
    );
  }
}
