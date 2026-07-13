import 'dart:io';
import 'dart:typed_data';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pdfx/pdfx.dart';
import 'package:popover/popover.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart'
    show PlanType, DateFilterOption;
import 'package:trakli/presentation/utils/globals.dart';
import 'package:url_launcher/url_launcher.dart';

/// Allowed extensions for attachment (jpg, jpeg, png, pdf; max 1MB each).
const List<String> _transactionAttachmentExtensions = [
  'jpg',
  'jpeg',
  'png',
  'pdf',
];

Future<File?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _transactionAttachmentExtensions,
      withData: true,
    );
    if (result != null) {
      final fileSize = result.files.single.size;
      const maxSize = 1024 * 1024; // 1MB
      if (fileSize > maxSize) {
        throw Exception(LocaleKeys.fileSizeExceedsLimit.tr());
      }
      final path = result.files.single.path;
      if (path == null) return null;
      return File(path);
    } else {
      return null;
    }
  } catch (e) {
    rethrow;
  }
}

/// Renders the first page of a PDF to a small JPEG thumbnail.
/// Returns null on failure or if the PDF has no pages.
Future<Uint8List?> renderPdfFirstPageThumbnail({
  String? filePath,
  Uint8List? bytes,
  int size = 144,
}) async {
  assert(filePath != null || bytes != null);
  try {
    final document = filePath != null
        ? await PdfDocument.openFile(filePath)
        : await PdfDocument.openData(bytes!);
    final pageCount = document.pagesCount;
    if (pageCount == 0) {
      await document.close();
      return null;
    }
    final page = await document.getPage(1);
    final image = await page.render(
      width: size.toDouble(),
      height: size.toDouble(),
      format: PdfPageImageFormat.jpeg,
    );
    await page.close();
    await document.close();
    return image?.bytes;
  } catch (_) {
    return null;
  }
}

Future<void> openUrl({required String url}) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception(LocaleKeys.couldNotLaunchUrl.tr());
  }
}

void showLoader() {
  navigatorKey.currentContext?.loaderOverlay.show();
}

void hideLoader() {
  navigatorKey.currentContext?.loaderOverlay.hide();
}

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.emailEmptyDesc.tr();
  }
// Regular expression for email validation
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return LocaleKeys.emailValidDesc.tr();
  }
  return null;
}

String? validateEmailNoEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
// Regular expression for email validation
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return LocaleKeys.emailValidDesc.tr();
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.passEmptyDesc.tr();
  }
  return null;
}

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.firstNameEmptyDesc.tr();
  }
  return null;
}

void updateLanguage(BuildContext? context, Locale locale) {
  if (context != null) {
    context.setLocale(locale);
  } else {
    navigatorKey.currentState!.context.setLocale(locale);
  }
}

String getLanguageFromCode(Locale locale) {
  switch (locale.languageCode) {
    case "en":
      return LocaleKeys.langEnglish.tr();
    case "fr":
      return LocaleKeys.langFrench.tr();
    case "de":
      return LocaleKeys.langGerman.tr();
    case "es":
      return LocaleKeys.langSpanish.tr();
    case "it":
      return LocaleKeys.langItalian.tr();
    case "ru":
      return LocaleKeys.langRussian.tr();
    default:
      return locale.languageCode;
  }
}

String getFormDisplayText(String displayMode) {
  switch (displayMode) {
    case "full":
      return LocaleKeys.full.tr();
    case "compact":
      return LocaleKeys.compact.tr();
    default:
      return "";
  }
}

Widget flagWidget(Currency currency, {double? fontSize}) {
  if (currency.code == 'XAF') {
    return Text(
      "🇨🇲",
      style: TextStyle(
        fontSize: fontSize ?? 24.sp,
      ),
    );
  }
  if (currency.flag == null) {
    return Image.asset(
      'no_flag.png'.imagePath,
      package: 'currency_picker',
      width: 27.w,
      fit: BoxFit.cover,
    );
  }

  if (currency.isFlagImage) {
    return Image.asset(
      currency.flag!.imagePath,
      package: 'currency_picker',
      width: 27.w,
    );
  }

  return Text(
    CurrencyUtils.currencyToEmoji(currency),
    style: TextStyle(
      fontSize: fontSize ?? 24.sp,
    ),
  );
}

extension StringExtensions on String {
  String get imagePath => 'lib/src/res/$this';
}

Future<T?> showCustomPopOver<T>(
  context, {
  required Widget widget,
  double? maxWidth,
  PopoverDirection? direction,
}) async {
  return showPopover<T>(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    transitionDuration: const Duration(milliseconds: 150),
    bodyBuilder: (context) => widget,
    direction: direction ?? PopoverDirection.bottom,
    barrierColor: Colors.black.withAlpha(80),
    constraints: BoxConstraints(
      maxHeight: 0.6.sh,
      maxWidth: maxWidth ?? 0.4.sw,
    ),
    arrowHeight: 10.h,
    arrowWidth: 20.w,
  );
}

Future<T?> showCustomBottomSheet<T>(
  BuildContext context, {
  required Widget widget,
  Color color = Colors.white,
  double maxHeightRatio = 0.95,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: color,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * maxHeightRatio,
    ),
    builder: (context) {
      return widget;
    },
  );
}

Future<T?> showCustomDialog<T>({
  bool barrierDismissible = true,
  required Widget widget,
}) async {
  return showDialog<T>(
    context: navigatorKey.currentContext!,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return widget;
    },
  );
}

Future<File?> pickImageApp({
  ImageSource sourcePick = ImageSource.gallery,
  bool skipCrop = true,
}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: sourcePick,
  );
  if (pickedFile != null) {
    if (skipCrop) {
      return File(pickedFile.path);
    }
    // Status-bar–friendly: Android = same toolbar + statusBar;
    // iOS = embed in nav controller so safe area is respected.
    const statusBarColor = Colors.white;
    final androidSettings = AndroidUiSettings(
      toolbarTitle: LocaleKeys.cropper.tr(),
      toolbarColor: statusBarColor,
      statusBarLight: true,
      activeControlsWidgetColor: appPrimaryColor,
      toolbarWidgetColor: appPrimaryColor,
      navBarLight: false,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPresetCustom(),
      ],
    );
    final iosSettings = IOSUiSettings(
      title: LocaleKeys.cropper.tr(),
      embedInNavigationController: true,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPresetCustom(),
      ],
    );
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [androidSettings, iosSettings],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
  }
  return null;
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => LocaleKeys.cropAspectRatioCustom.tr();
}

void showSnackBar({
  required dynamic message,
  bool isSuccess = false,
  Color? backgroundColor,
  Color textColor = Colors.white,
  double fontSize = 16,
  bool isFloating = true,
  double? borderRadius,
}) {
  final String messageText =
      message is Failure ? message.customMessage : message.toString();
  final bgColor = backgroundColor ?? (isSuccess ? appPrimaryColor : appDangerColor);

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      shape: borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              messageText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Icon(
              Icons.close,
              color: textColor,
              size: 18.sp,
            ),
          ),
        ],
      ),
    ),
  );
}

String formatDateYmd(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

Widget bulletPoint(BuildContext context, String text) {
  return Row(
    spacing: 4.w,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "• ",
        style: TextStyle(fontSize: 16.sp),
      ),
      Expanded(
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 12.5.sp,
              ),
        ),
      ),
    ],
  );
}

getPlanType(String interval) {
  switch (interval) {
    case 'monthly':
      return PlanType.monthly;
    case 'yearly':
      return PlanType.yearly;
    default:
      return PlanType.monthly;
  }
}

/// Returns a datetime to use as a start date
DateTime? getStartDateFromKey(String key) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  switch (key) {
    case LocaleKeys.thisWeek:
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      return startOfWeek;
    case LocaleKeys.thisMonth:
      return DateTime(today.year, today.month);
    case LocaleKeys.lastThreeMonths:
      return DateTime(today.year, today.month - 2);
    case LocaleKeys.lastSixMonths:
      return DateTime(today.year, today.month - 5);
    case LocaleKeys.thisYear:
      return DateTime(today.year);
    default:
      return null;
  }
}

/// Checks if a transaction matches the date range passed
bool matchTransactionDate(
  PickerDateRange? range,
  TransactionEntity transaction,
) {
  final txDate = transaction.datetime;
  final start = range?.startDate;
  final end = range?.endDate;

  if (start == null) return true;

  if (end == null) {
    return txDate.year == start.year &&
        txDate.month == start.month &&
        txDate.day == start.day;
  }

  return (txDate.isAtSameMomentAs(start) || txDate.isAfter(start)) &&
      (txDate.isAtSameMomentAs(end) || txDate.isBefore(end));
}

/// Date formatter
DateFormat formatDate = DateFormat('d MMM yyyy');

/// Format a date range to a string
String? formatRange(PickerDateRange? range) {
  if (range != null) {
    if (range.startDate != null && range.endDate != null) {
      return "${formatDate.format(range.startDate!)} - ${formatDate.format(range.endDate!)}";
    } else {
      return "";
    }
  }
  return null;
}

/// Get svgIcon for a type
String? getIconPath(dynamic item) {
  if (item is WalletEntity) {
    return Assets.images.wallet;
  }
  if (item is CategoryEntity) {
    return Assets.images.tag2;
  }
  if (item is DateFilterOption) {
    return Assets.images.calendar;
  }
  return null;
}
