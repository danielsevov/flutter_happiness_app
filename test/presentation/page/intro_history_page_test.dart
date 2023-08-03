// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/introspection_history_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_bar_chart.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_time_chart.dart';
import 'package:mockito/annotations.dart';

import '../../localizations_injection.dart';
import 'intro_history_page_test.mocks.dart';

@GenerateMocks([DailyIntrospectionHistoryPresenter, SettingsPresenter, HappinessSettingsRepository, OdooTokenRepository])
void main() {

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register the MethodChannel with the Flutter engine for testing
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      if (methodCall.method == 'setString') {
        return true;
      }
      return null;
    });
  });

  testWidgets('IntrospectionHistoryPage test constructor', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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

    expect(find.text('Introspection History'), findsWidgets);
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('IntrospectionHistoryPage test setLoading', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 1200, height: 400, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    )
      ..setInProgress(true)
      ..setInProgress(false);
  });

  testWidgets('IntrospectionHistoryPage test fetchFailed', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

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
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: page,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),);

    expect(() => state.notifyFetchFailed(''), returnsNormally);
    await tester.pumpAndSettle();
  });

  testWidgets('IntrospectionHistoryPage test notifyNoReports', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),);

    expect(state.notifyNoReportsFound, returnsNormally);
    await tester.pumpAndSettle();
  });

  testWidgets('IntrospectionHistoryPage test notifyReportsFetched empty list',
      (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    expect(() => state.notifyReportsFetched(const [], true), returnsNormally);
    await tester.pumpAndSettle();
  });

  testWidgets('IntrospectionHistoryPage test notifyReportsFetched',
      (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 400, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    expect(
      () => state.notifyReportsFetched([
        HappinessReport(
          report: HappinessReportModel.fromJson({
            'id': 1,
            'x_employee_id': [1],
            'create_date': DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
            'x_is_daily_report': true,
            'x_level_happiness': 1,
            'x_level_sadness': 2,
            'x_level_anger': 3,
            'x_level_fear': 4,
            'x_care_for_self': 'Care self',
            'x_care_for_others': 'Care others',
            'x_insight': 'My insight'
          }),
          rank: 12,
        )
      ], true),
      returnsNormally,
    );
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find
        .text(DateTime.now().subtract(const Duration(days: 1)).day.toString())
        .last, find.byType(SingleChildScrollView), const Offset(1, 1),);

    await tester.tap(find
        .text(DateTime.now().subtract(const Duration(days: 1)).day.toString())
        .last,);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find
        .text(DateTime.now().subtract(const Duration(days: 1)).day.toString())
        .last,);

    await tester.pumpAndSettle();

    expect(find.textContaining('#12'), findsOneWidget);
  });

  testWidgets('IntrospectionHistoryPage test notifyReportsFetched today',
      (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    expect(
      () => state.notifyReportsFetched([
        HappinessReport(
          report: HappinessReportModel.fromJson({
            'id': 1,
            'x_employee_id': [1],
            'x_is_daily_report': true,
            'x_level_happiness': 1,
            'x_level_sadness': 2,
            'x_level_anger': 3,
            'x_level_fear': 4,
            'x_care_for_self': 'Care self',
            'x_care_for_others': 'Care others',
            'x_insight': 'My insight'
          }),
          rank: 1,
        )
      ], true),
      returnsNormally,
    );
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text(DateTime.now().day.toString()).last, find.byType(SingleChildScrollView), const Offset(1, 1));

    await tester.tap(find.text(DateTime.now().day.toString()).last);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.text(DateTime.now().day.toString()).last);

    await tester.pumpAndSettle();

    expect(find.textContaining('#1'), findsOneWidget);
  });

  testWidgets('IntrospectionHistoryPage test chart', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(
      ProviderScope(
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
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: SizedBox(width: 400, height: 400, child: page),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final report = HappinessReportModel.fromJson({
      'id': 1,
      'x_employee_id': [1],
      'x_is_daily_report': true,
      'x_level_happiness': 1,
      'x_level_sadness': 2,
      'x_level_anger': 3,
      'x_level_fear': 4,
      'x_care_for_self': 'Care self',
      'x_care_for_others': 'Care others',
      'x_insight': 'My insight'
    })
      ..date = Helper.formatter.format(DateTime.now());

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    expect(
      () => state.notifyReportsFetched([
        HappinessReport(
          report: report,
          rank: 1,
        )
      ], true),
      returnsNormally,
    );
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('12 periods').first,
        find.byType(SingleChildScrollView), const Offset(1, 1),);

    await tester.pumpAndSettle();

    await tester.drag(find.byType(IntrospectionChart), const Offset(50, 0));

    await tester.pumpAndSettle();

    await tester.drag(find.byType(IntrospectionChart), const Offset(-50, 0));

    await tester.tap(find.text('12 periods').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('4 periods').first);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('Bar Chart').first,
      find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.text('Bar Chart').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Line Chart').first);
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Weeks').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Months').first);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('4 periods').first,
      find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.text('4 periods').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('12 periods').first);

    await tester.pumpAndSettle();
  });

  testWidgets('IntrospectionHistoryPage test chart 2', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(ProviderScope(
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
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: SizedBox(
            width: 400,
            height: 400,
            child: page,
          ),
        ),
      ),
    ),);

    await tester.pumpAndSettle();

    final report = HappinessReportModel.fromJson({
      'id': 1,
      'x_employee_id': [1],
      'x_is_daily_report': true,
      'x_level_happiness': 1,
      'x_level_sadness': 2,
      'x_level_anger': 3,
      'x_level_fear': 4,
      'x_care_for_self': 'Care self',
      'x_care_for_others': 'Care others',
      'x_insight': 'My insight'
    })
      ..date = Helper.formatter.format(DateTime.now());

    final report2 = HappinessReportModel.fromJson({
      'id': 1,
      'x_employee_id': [1],
      'x_is_daily_report': true,
      'x_level_happiness': 1,
      'x_level_sadness': 2,
      'x_level_anger': 3,
      'x_level_fear': 4,
      'x_care_for_self': 'Care self',
      'x_care_for_others': 'Care others',
      'x_insight': 'My insight'
    })
      ..date = Helper.formatter
          .format(DateTime.now().subtract(const Duration(days: 14)));

    final report3 = HappinessReportModel.fromJson({
      'id': 1,
      'x_employee_id': [1],
      'x_is_daily_report': true,
      'x_level_happiness': 1,
      'x_level_sadness': 2,
      'x_level_anger': 3,
      'x_level_fear': 4,
      'x_care_for_self': 'Care self',
      'x_care_for_others': 'Care others',
      'x_insight': 'My insight'
    })
      ..date = Helper.formatter
          .format(DateTime.now().subtract(const Duration(days: 3)));

    // Access the state object using `tester.state` method on the widget
    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    expect(
      () => state.notifyReportsFetched([
        HappinessReport(
          report: report,
          rank: 1,
        ),
        HappinessReport(
          report: report2,
          rank: 1,
        ),
        HappinessReport(
          report: report3,
          rank: 1,
        )
      ], true),
      returnsNormally,
    );

    await tester.pumpAndSettle();

    // Test bar chart
    expect(find.byType(IntrospectionBarChart), findsOneWidget);
    expect(find.byType(IntrospectionTimeChart), findsNothing);

    await tester.dragUntilVisible(find.text('12 periods').first,
        find.byType(SingleChildScrollView), const Offset(1, 1),);

    await tester.dragUntilVisible(find.text('Bar Chart').first,
      find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.text('Bar Chart').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Line Chart').first);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('12 periods').first,
      find.byType(SingleChildScrollView), const Offset(1, 1),);
    await tester.tap(find.text('12 periods').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('4 periods').first);
    await tester.pumpAndSettle();
  });

  testWidgets('Test time chart', (tester) async {
    final page = IntrospectionTimeChart(averages: [], constraints: const BoxConstraints(maxWidth: 400), smallLabel: false, groupBy: GroupBy.day, numberOfPeriods: 4,);

    await tester.pumpWidget(ProviderScope(
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
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: SizedBox(
            width: 400,
            height: 400,
            child: page,
          ),
        ),
      ),
    ),);

    await tester.pumpAndSettle();
  });

  testWidgets('Test notifyNoReportsFound method', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        title: 'Flutter Demo',
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: SizedBox(
            width: 400,
            height: 400,
            child: page,
          ),
        ),
      ),
    ),);

    await tester.pumpAndSettle();

    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    // Assuming notifyNoReportsFound shows a SnackBar when there are no reports
    state.notifyNoReportsFound();

    await tester.pumpAndSettle();

    expect(find.textContaining('No entry found!'), findsOneWidget);
  });

  testWidgets('Test changeReportType method', (tester) async {
    final presenter = MockDailyIntrospectionHistoryPresenter();

    final page = IntrospectionHistoryPage(presenter: presenter);

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        title: 'Flutter Demo',
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: SizedBox(
            width: 400,
            height: 400,
            child: page,
          ),
        ),
      ),
    ),);

    await tester.pumpAndSettle();

    final state = tester.state<IntrospectionHistoryPageState>(
      find.byType(IntrospectionHistoryPage),
    );

    // Assuming the initial report type is ReportType.bar
    expect(state.fetchDaily, true);

    // Change the report type to time
    state.changeReportType(0);

    await tester.pumpAndSettle();

    expect(state.fetchDaily, false);

    // Change the report type back to bar
    state.changeReportType(1);

    await tester.pumpAndSettle();

    expect(state.fetchDaily, true);
  });

  testWidgets('IntrospectionHistoryPage test go back to home page',
          (tester) async {
        final presenter = MockDailyIntrospectionHistoryPresenter();

        final page = IntrospectionHistoryPage(presenter: presenter);

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
              home: LocalizationsInj(
                locale: const Locale('en'),
                child: SizedBox(width: 400, height: 400, child: page),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_back));

        expect(find.text('Personal History'), findsNothing);
      });
}
