import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/config/theme_cubit/theme_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        final tones = context.tones;
        return Material(
          color: tones.bgSurface,
          shape: CircleBorder(
            side: BorderSide(color: tones.borderLight),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.read<ThemeCubit>().updateThemeByEnum(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                ),
            child: SizedBox(
              width: 40.r,
              height: 40.r,
              child: Center(
                child: Icon(
                  isDark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  size: 18.sp,
                  color: tones.brand.deep,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
