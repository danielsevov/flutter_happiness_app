// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/manager_dashboard_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/manager_dashboard_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/manager_dashboard_page_narrow_body.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/manager_dashboard_page_wide_body.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../localizations_injection.dart';
import 'manager_dashboard_page_test.mocks.dart';

@GenerateMocks([
  ManagerDashboardPresenter,
  DailyIntrospectionHistoryPresenter,
  SettingsPresenter,
  HappinessSettingsRepository,
  OdooTokenRepository
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ManagerDashboardPage', () {
    testWidgets(
        'ManagerDashboardPage should create ManagerDashboardPage correctly',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      expect(find.byType(ManagerDashboardPage), findsOneWidget);
    });

    testWidgets(
        'ManagerDashboardPage should call initState and attach presenter',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      verify(mockPresenter.attach(any)).called(1);
      verify(mockPresenter.fetchData(fetchDaily: false)).called(1);
    });

    testWidgets(
        'ManagerDashboardPage should call deactivate and detach presenter',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      await tester.pumpWidget(const SizedBox());

      verify(mockPresenter.detach()).called(1);
    });

    testWidgets(
        'ManagerDashboardPage should show loading indicator when loading',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;
      await tester.pumpAndSettle();

      state.setInProgress(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      state.setInProgress(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'ManagerDashboardPage should call '
        'notifyNoReportsFound and clear reports', (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;
      state.notifyNoReportsFound();

      expect(state.reports, <HappinessReportModel>[]);
    });

    testWidgets(
        'ManagerDashboardPage should call notifyFetchFailed clear reports',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;
      state.notifyFetchFailed();

      expect(state.reports, <HappinessReportModel>[]);
    });

    testWidgets(
        'ManagerDashboardPage should call notifyDataFetched and update state',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      final mockReports = [
        HappinessReport(
          report: HappinessReportModel.empty(),
          rank: 1,
        ),
      ];
      final mockUsers = [
        UserModel.fromJson({'id': 1, 'name': 'User 1'}),
      ];

      state.notifyDataFetched(mockReports, mockUsers, mockReports);

      expect(state.reports, mockReports);
      expect(state.groupMembers, mockUsers);
      expect(state.mergedReports, mockReports);
    });

    testWidgets(
        'ManagerDashboardPage should call notifyDataFetched and update state on wide screen',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'Flutter Demo',
            home: LocalizationsInj(
              locale: const Locale('en'),
              child: SizedBox(height: 400, width: 1500, child: page),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      state.setState(() {
        state.isExpanded = false;
      });

      await tester.pumpAndSettle();

      final mockReports = [
        HappinessReport(
          report: HappinessReportModel.empty(),
          rank: 1,
        ),
      ];
      final mockUsers = [
        UserModel.fromJson({'id': 1, 'name': 'User 1'}),
      ];

      state.notifyDataFetched(mockReports, mockUsers, mockReports);

      expect(state.reports, mockReports);
      expect(state.groupMembers, mockUsers);
      expect(state.mergedReports, mockReports);
    });

    testWidgets(
        'ManagerDashboardPage should filter reports based on selected date range',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      final mockUsers = [
        UserModel.fromJson({'id': 1, 'name': 'User 1'}),
        UserModel.fromJson({'id': 2, 'name': 'User 2'}),
      ];

      state.groupMembers = mockUsers;

      final mockReports = [
        HappinessReport(
          report: HappinessReportModel.empty(date: '01-05-2023', employeeId: 1),
          rank: 1,
        ),
        HappinessReport(
          report: HappinessReportModel.empty(date: '02-05-2023', employeeId: 1),
          rank: 2,
        ),
        HappinessReport(
          report: HappinessReportModel.empty(date: '03-05-2023', employeeId: 1),
          rank: 3,
        ),
      ];

      state.dateRange = DateTimeRange(
        start: Helper.formatter.parse('01-05-2023'),
        end: Helper.formatter.parse('02-05-2023'),
      );

      final filteredReports = state.filteredReports(mockReports);
      expect(filteredReports.length, 2);
    });

    testWidgets('ManagerDashboardPage should group reports by user',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      final mockUsers = [
        UserModel.fromJson({'id': 1, 'name': 'User 1'}),
        UserModel.fromJson({'id': 2, 'name': 'User 2'}),
      ];

      state.groupMembers = mockUsers;

      final mockReports = [
        HappinessReport(
          report: HappinessReportModel.empty(employeeId: 1),
          rank: 1,
        ),
        HappinessReport(
          report: HappinessReportModel.empty(employeeId: 2),
          rank: 2,
        ),
      ];

      state.reports = mockReports;

      final groupedReports = state.groupReportsByUser(BoxConstraints());
      expect(groupedReports.length, mockUsers.length);
    });

    testWidgets(
        'ManagerDashboardPage should change report type and refetch data',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      // Initial report type
      expect(state.fetchDaily, false);

      // Change report type
      state.changeReportType(1);
      expect(state.fetchDaily, true);

      // Verify fetchData() called with new report type
      verify(mockPresenter.fetchData(fetchDaily: true)).called(1);
    });

    testWidgets('ManagerDashboardPage test go back to home page',
        (tester) async {
      final presenter = MockManagerDashboardPresenter();

      final page = ManagerDashboardPage(presenter: presenter);

      // Initialize mock instances
      final mockHistoryPresenter = MockDailyIntrospectionHistoryPresenter();
      final mockOdooRepo = MockOdooTokenRepository();
      final mockSettingsRepo = MockHappinessSettingsRepository();
      final mockSettingsPresenter = MockSettingsPresenter();
      final mockManagerPresenter = MockManagerDashboardPresenter();
      final mockInitOdooMethod = (String str, WidgetRef ref) async {};
      final mockUserDetailsState = UserDetailsState(0, 0, 0, false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyPresenterProvider.overrideWith((ref) => mockHistoryPresenter),
            odooRepoProvider.overrideWith((ref) => mockOdooRepo),
            settingsRepoProvider.overrideWith((ref) => mockSettingsRepo),
            settingsPresenterProvider.overrideWith((ref) => mockSettingsPresenter),
            managerPresenterProvider.overrideWith((ref) => mockManagerPresenter),
            initOdooMethodProvider.overrideWith((ref) => mockInitOdooMethod),
            userDetailsStateProvider.overrideWith((ref) => mockUserDetailsState),
          ],
          child: MaterialApp(
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

    testWidgets('ManagerDashboardPage should set loading state correctly',
        (WidgetTester tester) async {
      final mockPresenter = MockManagerDashboardPresenter();
      final page = ManagerDashboardPage(presenter: mockPresenter);

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

      final state = tester.state(find.byType(ManagerDashboardPage))
          as ManagerDashboardPageState;

      // Initial loading state
      expect(state.isLoading, false);

      // Set loading state to true
      state.setInProgress(true);
      expect(state.isLoading, true);

      // Set loading state back to false
      state.setInProgress(false);
      expect(state.isLoading, false);
    });
  });

  group('Manager Dashboard page body tests', () {
    final mockUsers = [
      UserModel.fromJson({'id': 1, 'name': 'User 1'}),
      UserModel.fromJson({'id': 2, 'name': 'User 2'}),
    ];

    final mockReports = [
      HappinessReport(
        report: HappinessReportModel.empty(employeeId: 1, date: '12-12-2020'),
        rank: 1,
      ),
      HappinessReport(
        report: HappinessReportModel.empty(employeeId: 2, date: '13-12-2020'),
        rank: 2,
      ),
    ];

    testWidgets('is created with correct parameters',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: ManagerDashboardPageNarrowBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: true,
                    mergedReports: [],
                    expand: expand,
                    groupMembers: [],
                    filteredReports: [],
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the creation of the widget
      await tester.pumpWidget(widget);
      expect(find.byType(ManagerDashboardPageNarrowBody), findsOneWidget);
    });

    testWidgets('builds CustomScrollView with appropriate slivers',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: ManagerDashboardPageNarrowBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: true,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      await tester.ensureVisible(find.byType(SliverToBoxAdapter));
      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });

    testWidgets('builds with appropriate report type',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: ManagerDashboardPageNarrowBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      await tester.ensureVisible(find.byType(SliverToBoxAdapter));
      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });

    testWidgets('builds with appropriate layout for wide screen',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 2000,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 2000,
                  height: 400,
                  child: ManagerDashboardPageNarrowBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      await tester.ensureVisible(find.byType(SliverToBoxAdapter).first);
      expect(find.byType(SliverToBoxAdapter), findsNWidgets(2));
      expect(find.byType(SliverPadding), findsOneWidget);
    });

    testWidgets('builds ListView when in wide mode',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 1500,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1500,
                  height: 400,
                  child: ManagerDashboardPageWideBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: true,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
      await tester.ensureVisible(find.byType(ListView));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('wide body builds with appropriate report type',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 1500,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1500,
                  height: 400,
                  child: ManagerDashboardPageWideBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
      await tester.ensureVisible(find.byType(ListView));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('wide body builds with appropriate screen width',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 1500,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1500,
                  height: 400,
                  child: ManagerDashboardPageWideBody(
                    constraints: constraints,
                    isExpanded: true,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: mockReports,
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: mockReports,
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
      await tester.ensureVisible(find.byType(ListView));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('wide body builds with empty report list',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 1500,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1500,
                  height: 400,
                  child: ManagerDashboardPageWideBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: [],
                    expand: expand,
                    groupMembers: mockUsers,
                    filteredReports: [],
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
      await tester.ensureVisible(find.byType(ListView));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('wide body builds with empty user list',
        (WidgetTester tester) async {
      // Initialize your parameters
      const constraints = BoxConstraints(
        maxWidth: 1500,
        maxHeight: 400,
      );
      expand() {}
      changeRange(DateTimeRange? newRange) {}

      // Create the widget
      final widget = ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          home: LocalizationsInj(
            locale: const Locale('en'),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1500,
                  height: 400,
                  child: ManagerDashboardPageWideBody(
                    constraints: constraints,
                    isExpanded: false,
                    isLoading: false,
                    fetchDaily: false,
                    mergedReports: [],
                    expand: expand,
                    groupMembers: [],
                    filteredReports: [],
                    changeRange: changeRange,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Test the CustomScrollView and its slivers
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text('No entry found!'), findsWidgets);
    });

    testWidgets('ManagerDashboardPageWideBody displays loading state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManagerDashboardPageWideBody(
              constraints: const BoxConstraints(),
              isExpanded: false,
              isLoading: true,
              fetchDaily: true,
              mergedReports: mockReports,
              filteredReports: mockReports,
              groupMembers: mockUsers,
              expand: () {},
              changeRange: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
