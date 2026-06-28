import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// A tappable pill that sends [message] to the chat when tapped. Shared by the
/// question and quick-actions blocks.
class ChatActionPill extends StatelessWidget {
  final String label;
  final String message;
  const ChatActionPill({super.key, required this.label, required this.message});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: tones.bgCard,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => context.read<AiChatCubit>().sendMessage(message),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: tones.borderLight),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: tones.brand.deep,
            ),
          ),
        ),
      ),
    );
  }
}
