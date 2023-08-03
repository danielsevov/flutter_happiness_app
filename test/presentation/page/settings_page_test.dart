// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/ui/pages/settings_page.dart';
import 'package:happiness_app/presentation/ui/widgets/settings/settings_switch_tile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../localizations_injection.dart';
import 'settings_page_test.mocks.dart';

@GenerateMocks([
  HappinessSettingsRepository,
  SettingsPresenter,
])
void main() {
  // Initialize mock instances
  final mockSettingsRepo = MockHappinessSettingsRepository();
  final mockSettingsPresenter = MockSettingsPresenter();
  final mockLanguageSettingsState = LanguageSettingsState(const Locale('en'));
  final mockInitOdooMethod = (String str, WidgetRef ref) async {};

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));

    // Register the MethodChannel with the Flutter engine for testing
    const MethodChannel('dexterous.com/flutter/local_notifications')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'cancelAll') {}
      if (methodCall.method == 'zonedSchedule') {}
      return null;
    });
  });

  testWidgets('SettingsPage test constructor', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('SettingsPage change language test', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer((realInvocation) async => settings);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
        ],
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('nl'), // Dutch
                Locale('bg'), // Bulgarian
              ],
              locale: ref
                  .read(languageSettingsStateProvider,)
                  .currentLocale,
              title: 'Flutter Demo',
              home: LocalizationsInj(
                locale: const Locale('en'),
                child: page,
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Nederlands'), findsOneWidget);
    expect(find.text('Български'), findsOneWidget);

    await tester.tap(find.text('Nederlands'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Nederlands'), findsOneWidget);
    expect(find.text('Български'), findsOneWidget);

    await tester.tap(find.text('Български'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Nederlands'), findsOneWidget);
    expect(find.text('Български'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
  });

  testWidgets('SettingsPage test setInProgress', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);

    state.setInProgress(true);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    state.setInProgress(false);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('SettingsPage test notifySettingsNotFetched', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    expect(state.notifySettingsNotFetched, returnsNormally);
  });

  testWidgets('SettingsPage test notifySettingsFetched', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    expect(
      () => state.notifySettingsImported(
        HappinessSettingsModel.newSettings(
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
          employeeId: 1,
          weeklyReviewDayOfWeek: Day.friday,
          canShare: false,
        ),
      ),
      returnsNormally,
    );
  });

  testWidgets('SettingsPage test notifySettingsFetched', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer((realInvocation) async =>
        realInvocation.positionalArguments[0] as HappinessSettingsModel,);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Monday').first);
    await tester.tap(find.textContaining('Wednesday').first);
    await tester.tap(find.textContaining('Friday').first);

    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, true);

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Tuesday').first);
    await tester.tap(find.textContaining('Thursday').first);

    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, true);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, true);
    expect(state.settingsModel.friday, true);
  });

  testWidgets('SettingsPage test time picker functionality',
      (WidgetTester tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '12:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer((realInvocation) async =>
        realInvocation.positionalArguments[0] as HappinessSettingsModel,);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    expect(find.text('Notify me at 12:00').first, findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.clock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.keyboard));
    await tester.pumpAndSettle();

    // Change the time in the time picker dialog
    await tester.tap(find.text('12').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.text('12').first, '11');
    await tester.pumpAndSettle();

    await tester.tap(find.text('00'));
    await tester.pumpAndSettle();

    await tester.enterText(find.text('00').first, '30');
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Notify me at 11:30'), findsWidgets);
  });

  testWidgets('SettingsPage test notification settings functionality',
      (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer((realInvocation) async =>
        realInvocation.positionalArguments[0] as HappinessSettingsModel,);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    await tester.pumpAndSettle();

    expect(state.settingsModel.monday, false);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, false);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, false);

    // toggle Monday
    await tester.tap(find.textContaining('Monday').first);
    expect(state.settingsModel.monday, true);

    // toggle Wednesday
    await tester.tap(find.textContaining('Wednesday').first);
    expect(state.settingsModel.wednesday, true);

    // toggle Friday
    await tester.tap(find.textContaining('Friday').first);
    expect(state.settingsModel.friday, true);

    await tester.pumpAndSettle();

    verify(repo.update(settings)).called(3);
  });

  testWidgets('SettingsPage test toggling notifications on and off',
      (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );
    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer((realInvocation) async =>
        realInvocation.positionalArguments[0] as HappinessSettingsModel,);

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    await tester.pumpAndSettle();

    // Test toggling each day's notification setting on
    await tester.tap(find.textContaining('Monday').first);
    expect(state.settingsModel.monday, true);

    await tester.tap(find.textContaining('Tuesday').first);
    expect(state.settingsModel.tuesday, true);

    await tester.tap(find.textContaining('Wednesday').first);
    expect(state.settingsModel.wednesday, true);

    await tester.tap(find.textContaining('Thursday').first);
    expect(state.settingsModel.thursday, true);

    await tester.tap(find.textContaining('Friday').first);
    expect(state.settingsModel.friday, true);

    await tester.tap(find.textContaining('Saturday').first);
    expect(state.settingsModel.saturday, true);

    await tester.tap(find.textContaining('Sunday').first);
    expect(state.settingsModel.sunday, true);

    await tester.pumpAndSettle();

    // Test toggling each day's notification setting off
    await tester.tap(find.textContaining('Monday').first);
    expect(state.settingsModel.monday, false);

    await tester.tap(find.textContaining('Tuesday').first);
    expect(state.settingsModel.tuesday, false);

    await tester.tap(find.textContaining('Wednesday').first);
    expect(state.settingsModel.wednesday, false);

    await tester.tap(find.textContaining('Thursday').first);
    expect(state.settingsModel.thursday, false);

    await tester.tap(find.textContaining('Friday').first);
    expect(state.settingsModel.friday, false);

    await tester.tap(find.textContaining('Saturday').first);
    expect(state.settingsModel.saturday, false);

    await tester.tap(find.textContaining('Sunday').first);
    expect(state.settingsModel.sunday, false);
  });

  testWidgets('SettingsPage test notifySettingsFetched', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<SettingsPageState>(
      find.byType(SettingsPage),
    );

    await tester.pumpAndSettle();

    // Toggle Monday
    await tester.tap(find.textContaining('Monday').first);
    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, false);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, false);

    await tester.pumpAndSettle();

    // Toggle Wednesday
    await tester.tap(find.textContaining('Wednesday').first);
    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, false);

    await tester.pumpAndSettle();

    // Toggle Friday
    await tester.tap(find.textContaining('Friday').first);
    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, true);

    await tester.pumpAndSettle();

    // Toggle Saturday
    await tester.tap(find.textContaining('Saturday').first);
    expect(state.settingsModel.saturday, true);
    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, true);
    expect(state.settingsModel.sunday, false);

    await tester.pumpAndSettle();

    // Toggle Sunday
    await tester.tap(find.textContaining('Sunday').first);
    expect(state.settingsModel.saturday, true);
    expect(state.settingsModel.monday, true);
    expect(state.settingsModel.tuesday, false);
    expect(state.settingsModel.wednesday, true);
    expect(state.settingsModel.thursday, false);
    expect(state.settingsModel.friday, true);
    expect(state.settingsModel.sunday, true);
  });

  testWidgets('SettingsPage test canShare switch on', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: false,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    await tester.dragUntilVisible(find.byType(SettingsSwitchTile).last,
        find.byType(SingleChildScrollView), const Offset(1, 1),);
    final canShareSwitch = find.byType(SettingsSwitchTile).last;

    await tester.dragUntilVisible(
        canShareSwitch, find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(canShareSwitch);
    await tester.pumpAndSettle();

    final state = tester.state<SettingsPageState>(find.byType(SettingsPage));
    expect(state.settingsModel.canShare, true);
  });

  testWidgets('SettingsPage test canShare switch off', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: true,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    await tester.dragUntilVisible(find.byType(SettingsSwitchTile).last,
        find.byType(SingleChildScrollView), const Offset(1, 1),);

    final canShareSwitch = find.byType(SettingsSwitchTile).last;
    await tester.dragUntilVisible(
        canShareSwitch, find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(canShareSwitch);
    await tester.pumpAndSettle();

    final state = tester.state<SettingsPageState>(find.byType(SettingsPage));
    expect(state.settingsModel.canShare, false);
  });

  testWidgets('SettingsPage test data settings pop-up', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: true,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    final guidePopUp = find.byIcon(CupertinoIcons.info);
    await tester.dragUntilVisible(
        guidePopUp, find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(guidePopUp);
    await tester.pumpAndSettle();

    expect(find.text('Data & Privacy'), findsWidgets);
    expect(
        find.textContaining('Your daily introspections are private by default'),
        findsOneWidget,);
  });

  testWidgets('SettingsPage test data privacy policy pop-up', (tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: true,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    final guidePopUp = find.byType(TextButton);
    await tester.dragUntilVisible(
        guidePopUp, find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(guidePopUp);
    await tester.pumpAndSettle();

    expect(find.text('Data Privacy Policy'), findsWidgets);
    expect(
        find.textContaining(
            'This data privacy policy outlines how the  Happiness App collects, uses, and protects the personal data of its users.',),
        findsOneWidget,);
  });

  testWidgets('Weekly notification time picker updates value',
      (WidgetTester tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: true,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Pick a new time for the weekly notification.
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byIcon(CupertinoIcons.clock).last);
    await tester.tap(find.byIcon(CupertinoIcons.clock).last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.keyboard));
    await tester.pumpAndSettle();

    // Change the time in the time picker dialog
    await tester.tap(find.text('16').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.text('16').first, '11');
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Notify me at 11:00'), findsWidgets);

    // Verify that the onChanged event is triggered
    verify(repo.update(any)).called(1);
  });

  testWidgets('Weekly notification day picker updates value',
      (WidgetTester tester) async {
    final settings = HappinessSettingsModel.newSettings(
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      employeeId: 1,
      canShare: true,
      timeOfTheDay: '16:00',
      weeklyReviewDayOfWeek: Day.friday,
    );

    final repo = MockHappinessSettingsRepository();
    when(repo.getMySettings()).thenAnswer((realInvocation) async => settings);
    when(repo.update(any)).thenAnswer(
      (realInvocation) async =>
          realInvocation.positionalArguments[0] as HappinessSettingsModel,
    );

    final settingsPresenter = SettingsPresenter()..attachRepositories(repo);

    final page = SettingsPage(
      settingsPresenter: settingsPresenter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          languageSettingsStateProvider.overrideWith((ref) => mockLanguageSettingsState),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
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

    // Find the initial selected day
    await tester.ensureVisible(find.text('Friday').last);
    expect(find.text('Friday').last, findsOneWidget);

    // Tap on a different day (e.g., Monday)
    await tester.tap(find.text('Monday').last);
    await tester.pumpAndSettle();

    // Verify that the onChanged event is triggered with the new day.
    verify(repo.update(any)).called(1);
  });
}
