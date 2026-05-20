import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';

/// Reusable top bar for content pages.
///
/// Default mode: back button (optional) · title · trailing actions.
/// Search mode: when [onSearchChanged] is supplied and the leading
/// "search" action is tapped, the title slot transforms into an inline
/// search input that *uses the top-bar space*. Clearing/dismissing
/// returns to the title. Eyebrow line (optional) sits inline above the
/// title, kept small so the bar stays at a normal toolbar height.
class PageAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? eyebrow;
  final List<Widget> actions;
  final bool showBack;
  final VoidCallback? onBack;

  /// If non-null, a search icon appears on the right and tapping it
  /// transforms the title into a search input. The field calls this on
  /// every keystroke and on clear.
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;

  /// Custom leading widget. When provided, [showBack] is ignored.
  /// Use this on the home dashboard to show a drawer trigger instead of
  /// the default back arrow.
  final Widget? leading;

  /// Optional widget replacing the title text (eg. brand logo).
  final Widget? titleWidget;

  const PageAppBar({
    super.key,
    required this.title,
    this.eyebrow,
    this.actions = const [],
    this.showBack = true,
    this.onBack,
    this.onSearchChanged,
    this.searchHint = 'Search',
    this.leading,
    this.titleWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  State<PageAppBar> createState() => _PageAppBarState();
}

class _PageAppBarState extends State<PageAppBar> {
  bool _searching = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searching = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _closeSearch() {
    _controller.clear();
    widget.onSearchChanged?.call('');
    setState(() => _searching = false);
  }


  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    // (the calmer green) mixed at 13% over bgPage — readable as green on
    // most displays while still gentle on the eyes.
    return Material(
      color: tones.bgPage,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: tones.borderLight,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: widget.preferredSize.height,
            child: Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: _searching
                  ? Row(
                      children: [
                        _BarIconButton(
                          icon: Icons.arrow_back,
                          onTap: _closeSearch,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _SearchField(
                            controller: _controller,
                            focusNode: _focus,
                            hint: widget.searchHint,
                            onChanged: widget.onSearchChanged!,
                            onClear: () {
                              _controller.clear();
                              widget.onSearchChanged?.call('');
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered title floats above the row so it lands
                        // at the optical screen center, not the centre of
                        // the row's remaining space (which is shifted by
                        // unequal leading and trailing widths).
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 72.w),
                          child: widget.titleWidget ??
                              _TitleBlock(
                                title: widget.title,
                                eyebrow: widget.eyebrow,
                              ),
                        ),
                        Row(
                          children: [
                            if (widget.leading != null)
                              widget.leading!
                            else if (widget.showBack)
                              _BarIconButton(
                                icon: Icons.arrow_back,
                                onTap: widget.onBack ??
                                    () => Navigator.of(context).maybePop(),
                              )
                            else
                              const _BrandMark(),
                            const Spacer(),
                            if (widget.onSearchChanged != null)
                              _BarIconButton(
                                icon: Icons.search,
                                onTap: _openSearch,
                              ),
                            ...widget.actions,
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String? eyebrow;

  const _TitleBlock({
    required this.title,
    this.eyebrow,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (eyebrow != null)
          Text(
            eyebrow!.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: tones.brand.deep,
            ),
          ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: tones.brand.deep,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 16.sp,
        color: tones.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: tones.accentWarm,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: tones.textMuted,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: onClear,
              icon: Icon(Icons.close, size: 18.sp, color: tones.textMuted),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 32.r,
                minHeight: 32.r,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Compact brand mark shown at the leading slot of bottom-nav pages
/// (no back, no custom leading), so the toolbar isn't visually unbalanced
/// with an empty top-left. Matches the Gmail/Drive convention of using
/// the app's brand logo as the root-page anchor.
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mark = SizedBox(
      width: 40.r,
      height: 40.r,
      child: Center(
        child: SvgPicture.asset(
          isDark ? Assets.images.appLogo : Assets.images.appLogoGreen,
          width: 22.w,
          height: 28.h,
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => scaffoldKey.currentState?.openDrawer(),
        child: mark,
      ),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BarIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40.r,
          height: 40.r,
          alignment: Alignment.center,
          child: Icon(icon, size: 22.sp, color: tones.brand.deep),
        ),
      ),
    );
  }
}

/// Action button used in PageAppBar.actions. Renders as either a circular
/// icon (default) or a brand-filled pill (primary). With [label], the pill
/// shows text + icon — use for destination chips like "Reports".
class PageAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool primary;
  final String? label;

  const PageAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.primary = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final hasLabel = label != null;
    final bg = primary || hasLabel ? tones.brand.deep : Colors.transparent;
    final fg = primary || hasLabel ? Colors.white : tones.textPrimary;

    final shape = (primary || hasLabel)
        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))
        : const CircleBorder();

    final child = hasLabel
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  label!,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: 40.r,
            height: 40.r,
            child: Center(
              child: Icon(icon, color: fg, size: 20.sp),
            ),
          );

    final widget = SizedBox(
      height: 40.r,
      child: Material(
        color: bg,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: child,
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: widget) : widget;
  }
}
