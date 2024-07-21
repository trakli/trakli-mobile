import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

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