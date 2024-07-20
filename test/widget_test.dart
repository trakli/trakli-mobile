import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/app_widget.dart';

void main() {
  testWidgets('HomePage has an AppBar with title Trakli',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Verify the AppBar title
    expect(find.text('Trakli'), findsOneWidget);
  });

  testWidgets('HomePage has a Text widget with Welcome to Trakli',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Verify the Text widget
    expect(find.text('Welcome to Trakli'), findsOneWidget);
  });
}
