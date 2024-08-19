import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen has an AppBar with title Trakli',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Verify the AppBar title
    expect(find.text(LocaleKeys.appName.tr()), findsOneWidget);
  });
}
