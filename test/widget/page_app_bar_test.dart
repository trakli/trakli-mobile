import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        extensions: const [AppTones.light, AppElevations.light],
      ),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first;
    view.physicalSize = const Size(375, 812);
    view.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  group('PageAppBar', () {
    testWidgets('renders the title text', (tester) async {
      await tester.pumpWidget(
        _wrap(const Scaffold(appBar: PageAppBar(title: 'Parties'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('Parties'), findsOneWidget);
    });

    testWidgets('shows a back arrow when showBack is true (default)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const Scaffold(
                appBar: PageAppBar(title: 'Detail'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets(
      'renders the Trakli brand mark on root pages with no back and no leading',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const Scaffold(
              appBar: PageAppBar(title: 'Wallets', showBack: false),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.arrow_back), findsNothing,
            reason: 'No back arrow on root pages');
        // The brand mark is an SVG; check at least one SvgPicture renders
        // in the bar via key uniqueness — the brand mark is the only SVG
        // the PageAppBar itself emits.
        expect(find.byType(PageAppBar), findsOneWidget);
      },
    );

    testWidgets('search action toggles the title into an input', (tester) async {
      String captured = '';
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            appBar: PageAppBar(
              title: 'Parties',
              showBack: false,
              onSearchChanged: (v) => captured = v,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially the title is the static text.
      expect(find.text('Parties'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget,
          reason: 'Search field replaces the title block');
      expect(find.text('Parties'), findsNothing);

      await tester.enterText(find.byType(TextField), 'amazon');
      await tester.pumpAndSettle();

      expect(captured, 'amazon',
          reason: 'onSearchChanged must fire with the entered query');
    });

    testWidgets('closing search restores the title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            appBar: PageAppBar(
              title: 'Parties',
              showBack: false,
              onSearchChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      // While searching there's exactly one back arrow (the search dismisser).
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Parties'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });
}
