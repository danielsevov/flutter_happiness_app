import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/weekly_retro_page.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_form.dart';
import 'package:mockito/annotations.dart';
import '../../localizations_injection.dart';
import 'weekly_retro_page_test.mocks.dart';

@GenerateMocks([
  WeeklyRetrospectionPresenter,
  DailyIntrospectionHistoryPresenter,
  SettingsPresenter,
  HappinessSettingsRepository,
  OdooTokenRepository
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock instances
  final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
  final mockOdooRepo = MockOdooTokenRepository();
  final mockSettingsRepo = MockHappinessSettingsRepository();
  final mockSettingsPresenter = MockSettingsPresenter();
  final mockWeeklyRetroPresenter = MockWeeklyRetrospectionPresenter();
  final mockInitOdooMethod = (String str, WidgetRef ref) async {};
  final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

  testWidgets('WeeklyRetrospectionPage test constructor', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Weekly Retrospection'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(WeeklyRetrospectionForm), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('WeeklyRetrospectionPage test go back', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Weekly Retrospection'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    expect(
      () async => tester.tap(find.byIcon(Icons.arrow_back)),
      returnsNormally,
    );
  });

  testWidgets('WeeklyRetrospectionPage test setInProgress', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<WeeklyRetrospectionPageState>(
      find.byType(WeeklyRetrospectionPage),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);

    state.setInProgress(true);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    state.setInProgress(false);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('WeeklyRetrospectionPage test notifyNotSaved', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    // Initialize mock instances
    final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
    final mockOdooRepo = MockOdooTokenRepository();
    final mockSettingsRepo = MockHappinessSettingsRepository();
    final mockSettingsPresenter = MockSettingsPresenter();
    final mockInitOdooMethod = (String str, WidgetRef ref) async {};
    final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

    await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
            odooRepoProvider.overrideWith((ref) => mockOdooRepo),
            settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
            settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
            initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
            userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
          ],
          child: MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    ));

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<WeeklyRetrospectionPageState>(
      find.byType(WeeklyRetrospectionPage),
    );

    expect(state.notifyNotSaved, returnsNormally);
  });

  testWidgets('WeeklyRetrospectionPage test notifySaved', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          weeklyRetroPresenterProvider.overrideWith((ref) => mockWeeklyRetroPresenter),
          initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<WeeklyRetrospectionPageState>(
      find.byType(WeeklyRetrospectionPage),
    );

    expect(state.notifySaved, returnsNormally);
  });

  testWidgets('WeeklyRetrospectionPage test notifyReportFetched',
      (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();
    final page = WeeklyRetrospectionPage(presenter: presenter,
      weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    );

    await tester.pumpAndSettle();

    final happinessReportModel = HappinessReportModel.empty();

    final state = tester.state<WeeklyRetrospectionPageState>(
      find.byType(WeeklyRetrospectionPage),
    )..notifyReportFetched(happinessReportModel);

    expect(state.todaysReport, equals(happinessReportModel));
  });
}
