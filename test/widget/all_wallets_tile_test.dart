import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/all_wallets_tile.dart';
import 'package:trakli/presentation/utils/enums.dart';

class MockExchangeRateCubit extends Mock implements ExchangeRateCubit {}

class MockCurrencyCubit extends Mock implements CurrencyCubit {}

class MockConfigCubit extends Mock implements ConfigCubit {}

class MockTransactionCubit extends Mock implements TransactionCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockExchangeRateCubit mockExchangeRateCubit;
  late MockCurrencyCubit mockCurrencyCubit;
  late MockConfigCubit mockConfigCubit;
  late MockTransactionCubit mockTransactionCubit;
  final now = DateTime.now();

  setUp(() {
    mockExchangeRateCubit = MockExchangeRateCubit();
    mockCurrencyCubit = MockCurrencyCubit();
    mockConfigCubit = MockConfigCubit();
    mockTransactionCubit = MockTransactionCubit();

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

    when(() => mockTransactionCubit.state).thenReturn(
      TransactionState.initial(),
    );

    when(() => mockTransactionCubit.stream).thenAnswer(
      (_) => Stream.value(mockTransactionCubit.state),
    );
  });

  Widget createTestWidget(List<WalletEntity> wallets) {
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
              BlocProvider<TransactionCubit>.value(value: mockTransactionCubit),
            ],
            child: Scaffold(
              body: AllWalletsTile(wallets: wallets),
            ),
          ),
        ),
      ),
    );
  }

  group('AllWalletsTile', () {
    testWidgets('should display wallet count badge with correct count',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wallets = <WalletEntity>[
        WalletEntity(
          clientId: 'wallet-1',
          type: WalletType.cash,
          name: 'Cash',
          balance: 1000,
          currencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
        WalletEntity(
          clientId: 'wallet-2',
          type: WalletType.bank,
          name: 'Bank',
          balance: 5000,
          currencyCode: 'EUR',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(createTestWidget(wallets));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show 0 count with empty wallets list', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget([]));
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display wallet icon', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wallets = <WalletEntity>[
        WalletEntity(
          clientId: 'wallet-1',
          type: WalletType.cash,
          name: 'Cash',
          balance: 1000,
          currencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(createTestWidget(wallets));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('should render AllWalletsTile widget', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wallets = <WalletEntity>[
        WalletEntity(
          clientId: 'wallet-1',
          type: WalletType.cash,
          name: 'Cash',
          balance: 1000,
          currencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(createTestWidget(wallets));
      await tester.pumpAndSettle();

      expect(find.byType(AllWalletsTile), findsOneWidget);
    });

    testWidgets('should have container with primary color background',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wallets = <WalletEntity>[
        WalletEntity(
          clientId: 'wallet-1',
          type: WalletType.cash,
          name: 'Cash',
          balance: 1000,
          currencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(createTestWidget(wallets));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AllWalletsTile),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.decoration, isA<BoxDecoration>());
    });
  });
}
