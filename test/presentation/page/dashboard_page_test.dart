// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/presenters/manager_dashboard_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/dashboard_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../localizations_injection.dart';
import 'dashboard_page_test.mocks.dart';

@GenerateMocks([
  DailyIntrospectionHistoryPresenter,
  SettingsPresenter,
  HappinessSettingsRepository,
  OdooTokenRepository,
  ManagerDashboardPresenter,
  DailyIntrospectionPresenter,
  WeeklyRetrospectionPresenter,
])
void main() {
  final odooRepo = MockOdooTokenRepository();
  final settingsPresenter = MockSettingsPresenter();
  var userDetails = UserDetailsState(0, 0, 0, false);

  // Initialize mock instances
  final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
  final mockOdooRepo = MockOdooTokenRepository();
  final mockSettingsRepo = MockHappinessSettingsRepository();
  final mockSettingsPresenter = MockSettingsPresenter();
  final mockManagerPresenter = MockManagerDashboardPresenter();
  final mockWeeklyRetroPresenter = MockWeeklyRetrospectionPresenter();
  final mockLanguageSettingsState = LanguageSettingsState(const Locale('en'));
  final mockDailyIntroPresenter = MockDailyIntrospectionPresenter();
  final mockInitOdooMethod = (String str, WidgetRef ref) async {};
  final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register the MethodChannel with the Flutter engine for testing
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      if (methodCall.method == 'remove') {
        return true;
      }
      return null;
    });

    when(odooRepo.clearOdooToken()).thenAnswer((realInvocation) async => false);

    userDetails = UserDetailsState(0, 0, 0, false);
  });

  testWidgets('DashboardPage test constructor', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.image(
        const AssetImage(
          'assets/images/rect_logo_plain.png',
        ),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DashboardPage start introspection test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 200, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.play).first, findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.clockRotateLeft), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.arrowRightFromBracket), findsOneWidget);

    expect(() async => tester.tap(find.byIcon(FontAwesomeIcons.play).first),
        returnsNormally,);
  });

  testWidgets('DashboardPage start weekly retrospection test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 200, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.play).first, findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.magnifyingGlass), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.clockRotateLeft), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.arrowRightFromBracket), findsOneWidget);

    expect(
        () async =>
            tester.tap(find.byIcon(FontAwesomeIcons.magnifyingGlass).first),
        returnsNormally,);
  });

  testWidgets('DashboardPage start introspection from action button test',
      (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 200, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.play).last, findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.clockRotateLeft), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.arrowRightFromBracket), findsOneWidget);

    expect(() async => tester.tap(find.byIcon(FontAwesomeIcons.play).last),
        returnsNormally,);
  });

  testWidgets('DashboardPage introspection history test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(FontAwesomeIcons.clockRotateLeft));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsNothing);
  });

  testWidgets('DashboardPage navigates to daioly introspection page',
      (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    // Create a UserDetailsState instance
    final userDetailsState = UserDetailsState(0, 0, 0, true);

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetailsState,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(() async => tester.tap(find.byIcon(FontAwesomeIcons.play).first),
        returnsNormally,);
  });

  testWidgets('DashboardPage my settings test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(() async => tester.tap(find.byIcon(FontAwesomeIcons.gear)),
        returnsNormally,);
  });

  testWidgets('DashboardPage navigates to manager dashboard', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: UserDetailsState(0, 0, 0, true),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(() async => tester.tap(find.byIcon(FontAwesomeIcons.chartLine)),
        returnsNormally,);
  });

  testWidgets('DashboardPage logout cancel test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: LocalizationsInj(
          locale: const Locale('en'),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations
                  .delegate, // assuming AppLocalizations uses the generated delegate
              // add other delegates as needed
            ],
            supportedLocales: const [
              Locale('en', ''), // add supported locales as needed
              // ...
            ],
            title: 'Flutter Demo',
            home: SizedBox(width: 200, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.play).first, findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.clockRotateLeft), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.arrowRightFromBracket), findsOneWidget);

    await tester.tap(find.byIcon(FontAwesomeIcons.arrowRightFromBracket));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to log out?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.cancel));
  });

  testWidgets('DashboardPage logout confirm test', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: LocalizationsInj(
          locale: const Locale('en'),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations
                  .delegate, // assuming AppLocalizations uses the generated delegate
              // add other delegates as needed
            ],
            supportedLocales: const [
              Locale('en', ''), // add supported locales as needed
              // ...
            ],
            title: 'Flutter Demo',
            home: SizedBox(width: 200, height: 800, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.play).first, findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.clockRotateLeft), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.arrowRightFromBracket), findsOneWidget);

    await tester.tap(find.byIcon(FontAwesomeIcons.arrowRightFromBracket));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to log out?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check_circle));
  });

  testWidgets('DashboardPage test setInProgress', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);

    state.setInProgress(true);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    state.setInProgress(false);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DashboardPage test notifyNoReportsFound', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    expect(state.notifyNoReportsFound, returnsNormally);
  });

  testWidgets('DashboardPage test notifyFetchFailed', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    expect(() => state.notifyFetchFailed(''), returnsNormally);
  });

  testWidgets('DashboardPage test notifyReportsFetched', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    expect(
        () => state.notifyReportsFetched(
            const [Text('Widget 1'), Text('Widget 2'), Text('Widget 3')], true),
        returnsNormally,);
    await tester.pumpAndSettle();

    expect(find.text('Widget 1'), findsOneWidget);
    expect(find.text('Widget 2'), findsOneWidget);
    expect(find.text('Widget 3'), findsOneWidget);
  });

  testWidgets('DashboardPage test switching pages', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    when(introspectionPresenter.fetchReports(
            fetchDaily: anyNamed('fetchDaily'),),)
        .thenAnswer((realInvocation) async => const [
              Text('Widget 1'),
              Text('Widget 2'),
              Text('Widget 3'),
              Text('Widget 4'),
              Text('Widget 5'),
              Text('Widget 6'),
              Text('Widget 7'),
              Text('Widget 8'),
              Text('Widget 9'),
              Text('Widget 10'),
            ],);
    expect(
        () => state.notifyReportsFetched(const [
              Text('Widget 1'),
              Text('Widget 2'),
              Text('Widget 3'),
              Text('Widget 4'),
              Text('Widget 5'),
              Text('Widget 6'),
              Text('Widget 7'),
              Text('Widget 8'),
              Text('Widget 9'),
              Text('Widget 10'),
            ], true),
        returnsNormally,);
    await tester.pumpAndSettle();

    // Test page changing with right button
    await tester.dragUntilVisible(find.text('Widget 1'),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.byIcon(CupertinoIcons.right_chevron));
    await tester.pumpAndSettle();

    verify(introspectionPresenter.fetchReports(
      pageLimit: 10,
      currentPageIndex: 0,
      fetchDaily: true,
    ),).called(1);

    await tester.tap(find.byIcon(CupertinoIcons.right_chevron));
    await tester.pumpAndSettle();

    verify(introspectionPresenter.fetchReports(
            fetchDaily: true, pageLimit: 10, currentPageIndex: 2,),)
        .called(1);

    // Test page changing with left button
    await tester.tap(find.byIcon(CupertinoIcons.left_chevron));
    await tester.pumpAndSettle();

    verify(introspectionPresenter.fetchReports(
      pageLimit: 10,
      currentPageIndex: 1,
      fetchDaily: true,
    ),).called(2);
  });

  testWidgets('DashboardPage test switching report types', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    expect(
        () => state.notifyReportsFetched(const [
              Text('Widget 1'),
              Text('Widget 2'),
              Text('Widget 3'),
              Text('Widget 4'),
              Text('Widget 5'),
              Text('Widget 6'),
              Text('Widget 7'),
              Text('Widget 8'),
              Text('Widget 9'),
              Text('Widget 10'),
            ], true),
        returnsNormally,);
    await tester.pumpAndSettle();

    // Test page changing with right button
    await tester.dragUntilVisible(find.text('Weekly Retrospection'),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.text('Weekly Retrospection'));
    await tester.pumpAndSettle();

    verify(introspectionPresenter.fetchReports(
      pageLimit: 10,
      currentPageIndex: 0,
      fetchDaily: false,
    ),).called(1);

    await tester.tap(find.text('Daily Introspection').first);
    await tester.pumpAndSettle();

    verify(introspectionPresenter.fetchReports(
      pageLimit: 10,
      currentPageIndex: 0,
      fetchDaily: true,
    ),).called(2);
  });

  testWidgets('DashboardPage test notifySettingsImported', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    );

    final settingsModel = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 0,
      canShare: false,
      locale: 'nl',
      weeklyReviewDayOfWeek: Day.friday,
    );
    await state.notifySettingsImported(settingsModel);
    await tester.pumpAndSettle();

    expect(
      find.image(
        const AssetImage(
          'assets/images/rect_logo_plain.png',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('DashboardPage test notifySettingsNotFetched', (tester) async {
    final introspectionPresenter = MockDailyIntrospectionHistoryPresenter();
    final settingsPresenter = MockSettingsPresenter();

    final page = DashboardPage(
      introspectionPresenter: introspectionPresenter,
      settingsPresenter: settingsPresenter,
      odooTokenRepository: odooRepo,
      userDetails: userDetails,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          dailyIntroPresenterProvider.overrideWith((ref) => mockDailyIntroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DashboardPageState>(
      find.byType(DashboardPage),
    )..notifySettingsNotFetched();

    await tester.pump(const Duration(seconds: 1));

    // Assuming `Helper.makeToast()` is using `FlutterToast` or similar package to show toast
    expect(find.text(AppLocalizations.of(state.context)!.noSettingsFetched),
        findsOneWidget,);
  });
}
