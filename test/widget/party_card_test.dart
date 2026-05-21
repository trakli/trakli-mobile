import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/party_card.dart';

class MockExchangeRateCubit extends Mock implements ExchangeRateCubit {}

class MockCurrencyCubit extends Mock implements CurrencyCubit {}

class MockConfigCubit extends Mock implements ConfigCubit {}

class MockPartyCubit extends Mock implements PartyCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockExchangeRateCubit mockExchangeRateCubit;
  late MockCurrencyCubit mockCurrencyCubit;
  late MockConfigCubit mockConfigCubit;
  late MockPartyCubit mockPartyCubit;
  final now = DateTime.now();

  setUp(() {
    mockExchangeRateCubit = MockExchangeRateCubit();
    mockCurrencyCubit = MockCurrencyCubit();
    mockConfigCubit = MockConfigCubit();
    mockPartyCubit = MockPartyCubit();

    when(() => mockExchangeRateCubit.state).thenReturn(
      ExchangeRateState.success(
        ExchangeRateEntity(
          provider: 'test',
          baseCode: 'USD',
          rates: {'USD': 1.0, 'EUR': 0.85, 'XAF': 600.0},
          timeLastUpdated: now,
          timeNextUpdated: now.add(const Duration(hours: 24)),
        ),
      ),
    );

    when(() => mockExchangeRateCubit.stream).thenAnswer(
      (_) => Stream.value(mockExchangeRateCubit.state),
    );

    final usdCurrency = CurrencyService().findByCode('USD');
    when(() => mockCurrencyCubit.state).thenReturn(
      CurrencyState.loaded(usdCurrency!),
    );

    when(() => mockCurrencyCubit.stream).thenAnswer(
      (_) => Stream.value(mockCurrencyCubit.state),
    );

    when(() => mockConfigCubit.state).thenReturn(
      ConfigState(
        configs: [
          ConfigEntity(
            id: 1,
            userId: 1,
            key: 'default-currency',
            type: ConfigType.string,
            value: 'USD',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: const Failure.none(),
      ),
    );

    when(() => mockConfigCubit.stream).thenAnswer(
      (_) => Stream.value(mockConfigCubit.state),
    );

    when(() => mockPartyCubit.state).thenReturn(
      const PartyState(
        parties: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      ),
    );

    when(() => mockPartyCubit.stream).thenAnswer(
      (_) => Stream.value(mockPartyCubit.state),
    );
  });

  Widget createTestWidget(PartyEntity party,
      {double receivedAmount = 0, double spentAmount = 0}) {
    return MediaQuery(
      data: const MediaQueryData(size: Size(375, 812)),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ExchangeRateCubit>.value(
                  value: mockExchangeRateCubit),
              BlocProvider<CurrencyCubit>.value(value: mockCurrencyCubit),
              BlocProvider<ConfigCubit>.value(value: mockConfigCubit),
              BlocProvider<PartyCubit>.value(value: mockPartyCubit),
            ],
            child: Scaffold(
              body: SizedBox(
                width: 180,
                child: PartyCard(
                  party: party,
                  receivedAmount: receivedAmount,
                  spentAmount: spentAmount,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('PartyCard', () {
    testWidgets('should display party name', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.text('Test Company'), findsOneWidget);
    });

    testWidgets('should display party type badge when type is set',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        type: PartyType.business,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.text(PartyType.business.customName), findsOneWidget);
    });

    testWidgets('should display description when present', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        description: 'A test description',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.text('A test description'), findsOneWidget);
    });

    testWidgets('should show green avatar when received > spent',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(
        party,
        receivedAmount: 1000,
        spentAmount: 500,
      ));
      await tester.pumpAndSettle();

      final incomeDeep = AppTones.light.income.deep;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final avatarContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).shape == BoxShape.circle &&
            (c.decoration as BoxDecoration).color == incomeDeep,
        orElse: () => Container(),
      );

      expect(avatarContainer.decoration, isNotNull,
          reason:
              'Avatar circle should use AppTones.light.income.deep when net is positive');
    });

    testWidgets('should show red avatar when spent > received', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(
        party,
        receivedAmount: 500,
        spentAmount: 1000,
      ));
      await tester.pumpAndSettle();

      final expenseDeep = AppTones.light.expense.deep;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final avatarContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).shape == BoxShape.circle &&
            (c.decoration as BoxDecoration).color == expenseDeep,
        orElse: () => Container(),
      );

      expect(avatarContainer.decoration, isNotNull,
          reason:
              'Avatar circle should use AppTones.light.expense.deep when net is negative');
    });

    testWidgets('should display stats chips when amounts are present',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(
        party,
        receivedAmount: 1000,
        spentAmount: 500,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('should not display stats chips when amounts are zero',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_downward), findsNothing);
      expect(find.byIcon(Icons.arrow_upward), findsNothing);
    });

    testWidgets('should show correct icon for business type', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        type: PartyType.business,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
    });

    testWidgets('should show correct icon for individual type', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'John Doe',
        type: PartyType.individual,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should have popup menu button', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final party = PartyEntity(
        clientId: 'party-1',
        name: 'Test Company',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(party));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton), findsOneWidget);
    });
  });
}
