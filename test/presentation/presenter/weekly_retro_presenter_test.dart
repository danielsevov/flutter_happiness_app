// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/views/pages/weekly_retro_page_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weekly_retro_presenter_test.mocks.dart';

@GenerateMocks([HappinessReportRepository, WeeklyRetrospectionPageView])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var userDetails = UserDetailsState(0, 0, 0, false);

  setUpAll(() {
    userDetails = UserDetailsState(0, 0, 0, false);
  });

  /// WeeklyRetrospectionPresenter tests

  late WeeklyRetrospectionPresenter presenter;
  late MockHappinessReportRepository mockRepository;
  late MockWeeklyRetrospectionPageView mockView;

  setUp(() {
    mockRepository = MockHappinessReportRepository();
    mockView = MockWeeklyRetrospectionPageView();
    presenter = WeeklyRetrospectionPresenter(userDetails,);
    presenter.attachRepositories(mockRepository);
    presenter.detach();
    presenter.attach(mockView);
  });

  test('WeeklyRetrospectionPresenter fetches report if it exists', () async {
    final today = DateTime.now();

    final reports = [
      HappinessReportModel.newWeeklyReport(
        happinessLevel: 3,
        careForSelf: 'Take a break',
        insight: 'I need to take more breaks during the week',
        date: Helper.formatter.format(today),
        employeeId: 0,
      ),
    ];

    when(mockRepository.getReportByWeekNumber(Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,)).thenAnswer((_) async => reports.first);
    when(mockRepository.getLastWeeklyReport()).thenAnswer((_) async => reports);

    await presenter.fetchReport(Helper.getWeekNumber(DateTime.now()),
    DateTime.now().year,);

    verify(mockView.setInProgress(true)).called(1);
    verify(mockView.setInProgress(false)).called(1);
    verify(mockView.notifyReportFetched(reports.first)).called(1);
    expect(presenter.currentWeekReport, reports.first);
  });

  test(
      'WeeklyRetrospectionPresenter does not fetch report if it does not exist',
      () async {
    final today = DateTime.now();

    final reports = [
      HappinessReportModel.newWeeklyReport(
        happinessLevel: 3,
        careForSelf: 'Take a break',
        insight: 'I need to take more breaks during the week',
        date: Helper.formatter.format(today.subtract(const Duration(days: 8))),
        employeeId: 0,
      ),
      HappinessReportModel.newWeeklyReport(
        happinessLevel: 4,
        careForSelf: 'Take a walk',
        insight: 'Taking a walk helps me think better',
        date: Helper.formatter.format(today.subtract(const Duration(days: 10))),
        employeeId: 0,
      ),
    ];

    when(mockRepository.getReportByWeekNumber(Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,)).thenAnswer((_) async => null);
    when(mockRepository.getReportByWeekNumber(Helper.getWeekNumber(DateTime.now().subtract(const Duration(days: 8))),
      DateTime.now().subtract(const Duration(days: 8)).year,)).thenAnswer((_) async => reports[0]);
    when(mockRepository.getReportByWeekNumber(Helper.getWeekNumber(DateTime.now().subtract(const Duration(days: 10))),
      DateTime.now().subtract(const Duration(days: 10)).year,)).thenAnswer((_) async => reports[1]);
    when(mockRepository.getLastWeeklyReport()).thenAnswer((_) async => reports);

    await presenter.fetchReport(Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,);

    verify(mockView.setInProgress(true)).called(1);
    verify(mockView.setInProgress(false)).called(1);
    expect(presenter.currentWeekReport, null);
  });

  test(
      'saveChanges should call notifySaved and create method on repository when currentWeekReport is null',
      () async {
    // Arrange
    const weeklyRating = 4.0;
    const feedback = 'Weekly feedback';
    const insight = 'Weekly insight';
    final report = HappinessReportModel.newWeeklyReport(
      happinessLevel: weeklyRating,
      careForSelf: feedback,
      insight: insight,
      employeeId: 0,
      date: Helper.formatter.format(DateTime.now()),
    );

    when(mockRepository.create(report)).thenAnswer((_) async => report);
    presenter.attach(mockView);

    // Act
    await presenter.saveChanges(weeklyRating.toInt(), feedback, insight, Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,);

    report.date = Helper.formatter.format(DateTime.now());

    // Assert
    verify(mockView.setInProgress(true)).called(1);
    verify(mockView.setInProgress(false)).called(1);
    verify(mockRepository.create(any)).called(1);
  });

  test(
      'saveChanges should call notifySaved and update method on repository when currentWeekReport is not null',
      () async {
    // Arrange
    const weeklyRating = 4.0;
    const feedback = 'Weekly feedback updated';
    const insight = 'Weekly insight updated';
    final report = HappinessReportModel.newWeeklyReport(
      happinessLevel: weeklyRating,
      careForSelf: feedback,
      insight: insight,
      employeeId: 0,
    );

    presenter.currentWeekReport = report;
    when(mockRepository.update(report)).thenAnswer((_) async => report);
    presenter.attach(mockView);

    // Act
    await presenter.saveChanges(weeklyRating.toInt(), feedback, insight, Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,);

    // Assert
    verify(mockView.setInProgress(true)).called(1);
    verify(mockView.setInProgress(false)).called(1);
    verify(mockRepository.update(report)).called(1);
    verify(mockView.notifySaved()).called(1);
    verifyNever(mockView.notifyNotSaved());
  });

  test(
      'saveChanges should call notifyNotSaved when create or update method on repository throws an error',
      () async {
    // Arrange
    const weeklyRating = 4.0;
    const feedback = 'Weekly feedback';
    const insight = 'Weekly insight';
    final report = HappinessReportModel.newWeeklyReport(
      happinessLevel: weeklyRating,
      careForSelf: feedback,
      insight: insight,
      employeeId: 0,
      date: Helper.formatter.format(DateTime.now()),
    );

    when(mockRepository.create(report)).thenThrow(Exception());
    presenter.attach(mockView);

    // Act
    await presenter.saveChanges(weeklyRating.toInt(), feedback, insight, Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,);

    // Assert
    verify(mockView.setInProgress(true)).called(1);
    verify(mockView.setInProgress(false)).called(1);
    verify(mockRepository.create(any)).called(1);
    verifyNever(mockRepository.update(report));
    verify(mockView.notifyNotSaved()).called(1);
    verifyNever(mockView.notifySaved());
  });

  test('saveChanges should notify view with notifyNotSaved when update fails',
      () async {
    // Arrange
    final repository = MockHappinessReportRepository();
    final presenter = WeeklyRetrospectionPresenter(userDetails,);
    final view = MockWeeklyRetrospectionPageView();

    // Attach the repository and view to the presenter
    presenter.attachRepositories(repository);
    presenter.attach(view);

    // Mock the response of getLastWeeklyReport to return an empty list
    when(repository.getLastWeeklyReport()).thenAnswer((_) async => []);

    // Mock the response of update to throw an error
    when(repository.update(any)).thenThrow('error');

    // Act
    await presenter.saveChanges(5, 'feedback', 'insight', Helper.getWeekNumber(DateTime.now()),
      DateTime.now().year,);

    // Assert
    verify(view.setInProgress(true)).called(1);
    verify(view.setInProgress(false)).called(1);
    verify(view.notifyNotSaved()).called(1);
  });
}
