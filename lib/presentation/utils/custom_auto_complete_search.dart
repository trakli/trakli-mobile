import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class CustomAutoCompleteSearch<T extends Object> extends StatefulWidget {
  final String label;
  final FutureOr<Iterable<T>> Function(TextEditingValue textEditingValue)
      optionsBuilder;
  final String Function(T option) displayStringForOption;
  final void Function(T selectedOption)? onSelected;
  final String? Function(String? value)? validator;
  final Color accentColor;
  final T? initialValue;

  const CustomAutoCompleteSearch({
    super.key,
    required this.label,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.accentColor,
    this.onSelected,
    this.validator,
    this.initialValue,
  });

  @override
  State<CustomAutoCompleteSearch<T>> createState() =>
      _CustomAutoCompleteSearchState<T>();
}

class _CustomAutoCompleteSearchState<T extends Object>
    extends State<CustomAutoCompleteSearch<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<T> _options = [];
  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.displayStringForOption(widget.initialValue!);
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
      setState(() {});
      initializeOptions();
    });

    _controller.addListener(_onChanged);
  }

  initializeOptions() async {
    final result =
        await widget.optionsBuilder(TextEditingValue(text: _controller.text));

    _options = result.toList();
  }

  void _onChanged() async {
    final result =
        await widget.optionsBuilder(TextEditingValue(text: _controller.text));
    setState(() {
      _options = result.toList();
    });
    _updateOverlay();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final tones = context.tones;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final fieldGlobalY = renderBox.localToGlobal(Offset.zero).dy;
    final mediaQuery = MediaQuery.of(context);
    final spaceBelow = mediaQuery.size.height -
        mediaQuery.viewInsets.bottom -
        mediaQuery.padding.bottom -
        (fieldGlobalY + size.height);
    final spaceAbove = fieldGlobalY - mediaQuery.padding.top;
    final desired = 250.h;
    // Drop upward when there's not enough room below and more room above —
    // It keeps the last items visible when the field is near the screen bottom.
    final openUpward = spaceBelow < desired && spaceAbove > spaceBelow;
    final maxHeight =
        (openUpward ? spaceAbove : spaceBelow - 8.h).clamp(120.h, desired);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          // Anchor the BOTTOM of the overlay to the TOP of the field when
          // opening up
          // Anchor and the TOP of the overlay to the BOTTOM of the field
          // when opening down.
          targetAnchor: openUpward ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor: openUpward ? Alignment.bottomLeft : Alignment.topLeft,
          child: Material(
            color: tones.bgSurface,
            elevation: 4,
            borderRadius: openUpward
                ? BorderRadius.vertical(top: Radius.circular(AppRadii.md.r))
                : BorderRadius.vertical(bottom: Radius.circular(AppRadii.md.r)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
              ),
              child: _options.isNotEmpty
                  ? Builder(builder: (context) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          final T option = _options[index];
                          return ListTile(
                            title: Text(
                              widget.displayStringForOption(option),
                              style: TextStyle(color: tones.textPrimary),
                            ),
                            onTap: () {
                              _controller.text =
                                  widget.displayStringForOption(option);
                              widget.onSelected?.call(option);
                              _hideOverlay();
                              _focusNode.unfocus();
                            },
                          );
                        },
                      );
                    })
                  : ListTile(
                      onTap: () {
                        _focusNode.unfocus();
                      },
                      title: Text(
                        LocaleKeys.noData.tr(),
                        style: TextStyle(color: tones.textPrimary),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Material(
        color: _focusNode.hasFocus ? tones.bgSurface : tones.bgPage,
        elevation: _focusNode.hasFocus ? 4 : 0,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.md.r),
          bottom: Radius.circular(_focusNode.hasFocus ? 0 : AppRadii.md.r),
        ),
        child: TextFormField(
          readOnly: readOnly,
          controller: _controller,
          focusNode: _focusNode,
          validator: widget.validator,
          style: TextStyle(color: tones.textPrimary),
          decoration: InputDecoration(
            fillColor: _focusNode.hasFocus ? tones.bgSurface : null,
            labelText: widget.label,
            labelStyle: TextStyle(color: tones.textSecondary),
            contentPadding: EdgeInsets.only(top: 16.h),
            prefixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  readOnly = !readOnly;
                });
              },
              icon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                child: SvgPicture.asset(
                  Assets.images.searchSpecial,
                  colorFilter:
                      ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
                ),
              ),
            ),
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                } else {
                  _focusNode.requestFocus();
                }
              },
              icon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                child: SvgPicture.asset(
                  Assets.images.arrowDown,
                  colorFilter:
                      ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg.r),
              borderSide: BorderSide(
                color: widget.accentColor,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg.r),
              borderSide: BorderSide(
                color: tones.borderLight,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg.r),
              borderSide: BorderSide(
                color: tones.borderLight,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md.r),
              borderSide: BorderSide(color: tones.expense.accent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md.r),
              borderSide: BorderSide(
                color: tones.expense.accent,
                width: 2.0.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
