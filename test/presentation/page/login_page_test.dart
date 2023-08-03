// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/repositories/secure_storage_odoo_token_repo_impl.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/presentation/ui/pages/login_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../localizations_injection.dart';
import 'login_page_test.mocks.dart';

@GenerateMocks([OdooTokenRepository])
void main() {
  final odooRepo = MockOdooTokenRepository();
  final initializeDatasources = (String str, WidgetRef ref) async {};

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register the MethodChannel with the Flutter engine for testing
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      if (methodCall.method == 'setBool') {
        return true;
      }
      return null;
    });

    when(odooRepo.getOdooToken()).thenAnswer((realInvocation) async => null);
  });

  testWidgets('LogInPage test constructor', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
          initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Welcome! Please log in to proceed!'), findsOneWidget);
  });

  testWidgets('LogInPage test log in', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(() async => tester.tap(find.text('Log in')), returnsNormally);
  });

  testWidgets('LogInPage test cancel privacy policy', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: LocalizationsInj(
          locale: const Locale('en'),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              // add other delegates as needed
            ],
            supportedLocales: const [
              Locale('en', ''), // add supported locales as needed
              // ...
            ],
            title: 'Flutter Demo',
            home: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));

    await tester.pumpAndSettle();

    expect(find.text('Data Privacy Policy'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.cancel));
  });

  testWidgets('LogInPage test agree privacy policy', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: LocalizationsInj(
          locale: const Locale('en'),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              // add other delegates as needed
            ],
            supportedLocales: const [
              Locale('en', ''), // add supported locales as needed
              // ...
            ],
            title: 'Flutter Demo',
            home: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));

    await tester.pumpAndSettle();

    expect(find.text('Data Privacy Policy'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check_circle));
  });

  testWidgets('LogInPage test logo image is displayed', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('logoImage')), findsOneWidget);
  });

  testWidgets(
      'LogInPage test CircularProgressIndicator '
      'is displayed when isLoading is true', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    tester
        .state<LogInPageState>(
          find.byType(LogInPage),
        )
        .setInProgress(true);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'LogInPage test FloatingActionButton '
      'is displayed when isLoading is false', (tester) async {
    final page = LogInPage(
      odooTokenRepository: odooRepo,
      initializeDatasource:
      initializeDatasources,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    tester.state<LogInPageState>(
      find.byType(LogInPage),
    )
      ..setInProgress(true)
      ..setInProgress(false);

    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  group('LogInPage auto log in tests', () {
    String? token;

    setUpAll(() async {
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'read':
            return token;
          case 'write':
            token = methodCall.arguments['value'] as String?;
            return null;
          case 'delete':
            token = null;
            return null;
          default:
            return null;
        }
      });
    });

    testWidgets('auto log in fails if no token can be found', (tester) async {
      final page = LogInPage(
        odooTokenRepository: SecureStorageOdooTokenRepositoryImplementation(),
        initializeDatasource:
        initializeDatasources,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'Flutter Demo',
            home: LocalizationsInj(locale: const Locale('en'), child: page),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Welcome! Please log in to proceed!'), findsOneWidget);
    });

    testWidgets('auto log in fails if the token is not accepted',
        (tester) async {
      final repo = SecureStorageOdooTokenRepositoryImplementation();
      await repo.saveToken('testTokenFail');

      final page = LogInPage(
        odooTokenRepository: repo,
        initializeDatasource: (String value, WidgetRef ref) async {
          if (value == 'testTokenFail') {
            throw Exception();
          }
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'Flutter Demo',
            home: LocalizationsInj(locale: const Locale('en'), child: page),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Welcome! Please log in to proceed!'), findsOneWidget);
    });
  });
}
