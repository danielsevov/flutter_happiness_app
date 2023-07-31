// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/domain/repositories/user_repo.dart';
import 'package:happiness_app/presentation/presenters/manager_dashboard_presenter.dart';
import 'package:happiness_app/presentation/views/pages/manager_dashboard_page_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'manager_dashboard_presenter_test.mocks.dart';


@GenerateMocks([HappinessReportRepository, UserRepository, ManagerDashboardPageView])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ManagerDashboardPresenter presenter;
  late MockHappinessReportRepository happinessReportRepository;
  late MockUserRepository userRepository;
  late MockManagerDashboardPageView view;

  setUp(() {
    happinessReportRepository = MockHappinessReportRepository();
    userRepository = MockUserRepository();
    view = MockManagerDashboardPageView();

    presenter = ManagerDashboardPresenter();
    presenter.attachRepositories(happinessReportRepository, userRepository);
    presenter.attach(view);
  });

  tearDown(() {
    presenter.detach();
  });

  test('fetchData daily', () async {
    // Prepare mock data
    final mockDailyReports = <HappinessReportModel>[
      HappinessReportModel.newDailyReport(
        happinessLevel: 5,
        sadnessLevel: 3,
        angerLevel: 2,
        fearLevel: 1,
        date: '01-05-2023',
        employeeId: 1,
      ),
    ];
    final mockTeamMembers = <UserModel>[
      UserModel.fromJson({'id': 1, 'name': 'John Doe',}),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamDailyReports()).thenAnswer((_) async => mockDailyReports);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => mockTeamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: true);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyDataFetched(any, any, any));
    verify(view.setInProgress(false));
  });

  test('fetchData weekly', () async {
    // Prepare mock data
    final mockWeeklyReports = <HappinessReportModel>[
      HappinessReportModel.newWeeklyReport(
        happinessLevel: 6,
        sadnessLevel: 4,
        angerLevel: 2,
        fearLevel: 1,
        date: '01-05-2023',
        employeeId: 1,
      ),
    ];
    final mockTeamMembers = <UserModel>[
      UserModel.fromJson({'id': 1, 'name': 'John Doe',}),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamWeeklyReports()).thenAnswer((_) async => mockWeeklyReports);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => mockTeamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: false);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyDataFetched(any, any, any));
    verify(view.setInProgress(false));
  });

  test('fetchData daily reports', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    final dailyReports = [
      HappinessReportModel.newDailyReport(
          happinessLevel: 8, sadnessLevel: 2, angerLevel: 2, fearLevel: 2, date: '01-05-2023', employeeId: 1,),
      HappinessReportModel.newDailyReport(
          happinessLevel: 7, sadnessLevel: 3, angerLevel: 3, fearLevel: 3, date: '01-05-2023', employeeId: 2,),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamDailyReports()).thenAnswer((_) async => dailyReports);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: true);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyDataFetched(any, teamMembers, any));
    verify(view.setInProgress(false));
  });

  test('fetchData weekly reports', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    final weeklyReports = [
      HappinessReportModel.newWeeklyReport(
          happinessLevel: 8, sadnessLevel: 2, angerLevel: 2, fearLevel: 2, date: '01-05-2023', employeeId: 1,),
      HappinessReportModel.newWeeklyReport(
          happinessLevel: 7, sadnessLevel: 3, angerLevel: 3, fearLevel: 3, date: '01-05-2023', employeeId: 2,),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamWeeklyReports()).thenAnswer((_) async => weeklyReports);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: false);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyDataFetched(any, teamMembers, any));
    verify(view.setInProgress(false));
  });

  test('fetchData daily reports with exception', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamDailyReports()).thenThrow(Exception('Error fetching daily reports'));
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: true);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyFetchFailed());
    verify(view.setInProgress(false));
  });

  test('fetchData weekly reports with exception', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamWeeklyReports()).thenThrow(Exception('Error fetching weekly reports'));
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: false);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyFetchFailed());
    verify(view.setInProgress(false));
  });

  test('fetchData daily reports with empty list', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    // Configure mock repositories
    when(happinessReportRepository.getTeamDailyReports()).thenAnswer((_) async => []);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: true);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyNoReportsFound());
    verify(view.setInProgress(false));
  });

  test('fetchData weekly reports with empty list', () async {
    // Mock data
    final teamMembers = [
      UserModel.fromJson({'id': 1, 'name': 'Alice'}),
      UserModel.fromJson({'id': 2, 'name': 'Bob'}),
    ];

    final weeklyReports = <HappinessReportModel>[];

    // Configure mock repositories
    when(happinessReportRepository.getTeamWeeklyReports()).thenAnswer((_) async => weeklyReports);
    when(userRepository.getTeamMembers()).thenAnswer((_) async => teamMembers);

    // Call fetchData
    await presenter.fetchData(fetchDaily: false);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyNoReportsFound());
    verify(view.setInProgress(false));
  });

  test('fetchData error', () async {
    // Configure mock repositories
    when(happinessReportRepository.getTeamDailyReports()).thenThrow(Exception('Error fetching reports'));
    when(userRepository.getTeamMembers()).thenAnswer((_) async => []);

    // Call fetchData
    await presenter.fetchData(fetchDaily: true);

    // Verify interactions with the view
    verify(view.setInProgress(true));
    verify(view.notifyFetchFailed());
    verify(view.setInProgress(false));
  });

}
