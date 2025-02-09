import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/helpers.dart';


class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final bool isPassword;
  final bool readOnly;
  final bool showBottomBorder;
  final bool showNoBorders;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;

  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool filled;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefix,
    this.isPassword = false,
    this.readOnly = false,
    this.showBottomBorder = false,
    this.showNoBorders = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
    this.filled = false,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void _changeTextVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      enableInteractiveSelection: false,
      onTapOutside: (c) => hideKeyBoard(),
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      enabled: true,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && obscureText,
      obscuringCharacter: '*',
      cursorColor: Colors.black,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      // style: AppStyles.body2black,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
        ),
        // prefix: widget.prefix,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: widget.prefix,
        ),
        prefixIconConstraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
        suffixIcon: widget.isPassword
            ? IconButton(
                splashRadius: 1,
                icon: SvgPicture.asset(
                  obscureText
                      ? Assets.images.eyeSlash
                      : Assets.images.eye,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                  // color: ,
                ),
                onPressed: _changeTextVisibility,
              )
            : widget.suffixIcon,
        hintText: widget.hintText,
        error: null,
        focusedErrorBorder: widget.showNoBorders == true
            ? InputBorder.none
            : widget.showBottomBorder == true
            ? UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        )
            : OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color:  Colors.redAccent,
            width: 2,
          ),
        ),
        errorBorder: widget.showNoBorders == true
            ? InputBorder.none
            : widget.showBottomBorder == true
            ? UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        )
            : OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color:  Colors.redAccent,
            width: 2,
          ),
        ),
        focusedBorder: widget.showNoBorders == true
            ? InputBorder.none
            : widget.showBottomBorder == true
                ? UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
        focusColor: Colors.blue,
        enabledBorder: widget.showNoBorders == true
            ? InputBorder.none
            : widget.showBottomBorder == true
                ? UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 2,
                    ),
                  ),
        fillColor: const Color(0xFFF5F6F7),
        filled: widget.filled,
        // filled: true,
      ),
    );
  }
}

