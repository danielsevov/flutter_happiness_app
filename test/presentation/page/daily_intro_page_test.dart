import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/daily_intro_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_form.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import '../../localizations_injection.dart';
import 'daily_intro_page_test.mocks.dart';

@GenerateMocks([
  DailyIntrospectionPresenter,
  DailyIntrospectionHistoryPresenter,
  SettingsPresenter,
  HappinessSettingsRepository,
  OdooTokenRepository
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DailyIntrospectionPage test constructor', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Daily Introspection'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(DailyIntrospectionForm), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DailyIntrospectionPage test go back', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

    // Initialize mock providers
    final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
    final mockOdooRepo = MockOdooTokenRepository();
    final mockSettingsRepo = MockHappinessSettingsRepository();
    final mockSettingsPresenter = MockSettingsPresenter();
    final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

// Then, use them in the test
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
          userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(locale: const Locale('en'), child: page),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Daily Introspection'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    expect(
      () async => tester.tap(find.byIcon(Icons.arrow_back)),
      returnsNormally,
    );
  });

  testWidgets('DailyIntrospectionPage test setInProgress', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(locale: const Locale('en'), child: page),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DailyIntrospectionPageState>(
      find.byType(DailyIntrospectionPage),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);

    state.setInProgress(true);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    state.setInProgress(false);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DailyIntrospectionPage test notifyNotSaved', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

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
      )),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<DailyIntrospectionPageState>(
      find.byType(DailyIntrospectionPage),
    );

    expect(state.notifyNotSaved, returnsNormally);
  });

  testWidgets('DailyIntrospectionPage test notifySaved', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

    // Initialize mock providers
    final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
    final mockOdooRepo = MockOdooTokenRepository();
    final mockSettingsRepo = MockHappinessSettingsRepository();
    final mockSettingsPresenter = MockSettingsPresenter();
    final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

// Then, use them in the test
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
          odooRepoProvider.overrideWith((ref) => mockOdooRepo),
          settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
          settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
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
    final state = tester.state<DailyIntrospectionPageState>(
      find.byType(DailyIntrospectionPage),
    );

    expect(state.notifySaved, returnsNormally);
  });

  testWidgets('DailyIntrospectionPage test notifyReportFetched',
      (tester) async {
    final presenter = MockDailyIntrospectionPresenter();
    final page = DailyIntrospectionPage(presenter: presenter, date: DateFormat('yyyy-MM-dd').format(DateTime.now(),));

    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      home: LocalizationsInj(locale: const Locale('en'), child: page),
    ));

    await tester.pumpAndSettle();

    final happinessReportModel = HappinessReportModel.empty();

    final state = tester.state<DailyIntrospectionPageState>(
      find.byType(DailyIntrospectionPage),
    );
    state.notifyReportFetched(happinessReportModel);

    expect(state.todaysReport, equals(happinessReportModel));
  });
}
