// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/views/pages/daily_intro_page_view.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'daily_intro_presenter_test.mocks.dart';

@GenerateMocks([HappinessReportRepository, DailyIntrospectionPageView])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  var userDetails = UserDetailsState(0, 0, 0, false);
  
  setUpAll(() {
    userDetails = UserDetailsState(0, 0, 0, false);
  });

  /// DailyIntrospectionPresenter tests

  group('Daily Introspection Presenter tests', () {
    test('DailyIntrospectionPresenter constructor test', () {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      presenter.attachRepositories(repo);

      expect(presenter, isA<DailyIntrospectionPresenter>());
      expect(presenter.repositoriesAttached, true);
    });

    test('DailyIntrospectionPresenter attach and detach view test', () {
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();

      expect(() async => presenter.attach(view), returnsNormally);
      expect(() async => presenter.detach(), returnsNormally);
    });

    test('DailyIntrospectionPresenter saveChanges successfully test', () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view);

      when(repo.create(any)).thenAnswer((realInvocation) async {
        final report =
            realInvocation.positionalArguments[0] as HappinessReportModel;
        report.date = 'Today';
        report.setNewId(1);
        return report;
      });

      await presenter.saveChanges(
          1, 2, 3, 4, 'Accomplishments', 'Contributions', 'Insight', DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(1);
      verify(view.setInProgress(false)).called(1);
      verify(repo.create(any)).called(1);
      verify(view.notifySaved()).called(1);
      verifyNever(view.notifyNotSaved());
    });

    test('DailyIntrospectionPresenter saveChanges failed test', () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view);

      when(repo.create(any)).thenThrow(
        RepositoryException(
          'The datasource connector failed to persist the given model instance, so an EmptyModel was returned.',
        ),
      );

      await presenter.saveChanges(
          1, 2, 3, 4, 'Accomplishments', 'Contributions', 'Insight', DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(1);
      verify(view.setInProgress(false)).called(1);
      verify(repo.create(any)).called(1);
      verify(view.notifyNotSaved()).called(1);
      verifyNever(view.notifySaved());
    });

    test('DailyIntrospectionPresenter fetchReport with existing report test',
        () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();
      final today = Helper.formatter.format(DateTime.now());
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 5,
        sadnessLevel: 3,
        angerLevel: 1,
        fearLevel: 2,
        careForSelf: 'Accomplishments',
        careForOthers: 'Contributions',
        insight: 'Insight',
        employeeId: 0,
      )..date = today;

      when(repo.getReportByDate(DateFormat('yyyy-MM-dd').format(DateTime.now(),), true))
      .thenAnswer((realInvocation) async => report );
      when(repo.getLastDailyReport())
          .thenAnswer((realInvocation) async => [report]);
      when(view.notifyReportFetched(report))
          .thenAnswer((realInvocation) async => []);
      presenter.attachRepositories(repo);
      presenter.attach(view);

      await presenter.fetchReport(DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(1);
      verify(view.setInProgress(false)).called(1);
      verify(view.notifyReportFetched(report)).called(1);
    });

    test('DailyIntrospectionPresenter fetchReport with no existing report test',
        () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();

      when(repo.getReportByDate(DateFormat('yyyy-MM-dd').format(DateTime.now(),), true))
          .thenAnswer((realInvocation) async => null );
      when(repo.getLastDailyReport()).thenAnswer((realInvocation) async => []);
      presenter.attachRepositories(repo);
      presenter.attach(view);

      await presenter.fetchReport(DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(1);
      verify(view.setInProgress(false)).called(1);
    });

    test('DailyIntrospectionPresenter saveChanges with existing report test',
        () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 5,
        sadnessLevel: 3,
        angerLevel: 1,
        fearLevel: 2,
        careForSelf: 'Accomplishments',
        careForOthers: 'Contributions',
        insight: 'Insight',
        employeeId: 0,
      )..date = Helper.formatter.format(DateTime.now());

      when(repo.getReportByDate(DateFormat('yyyy-MM-dd').format(DateTime.now(),), true))
          .thenAnswer((realInvocation) async => report );
      when(repo.getLastDailyReport())
          .thenAnswer((realInvocation) async => [report]);
      when(view.notifyReportFetched(report))
          .thenAnswer((realInvocation) async => []);
      when(repo.update(report)).thenAnswer((realInvocation) async => report);
      presenter.attachRepositories(repo);
      presenter.attach(view);

      await presenter.fetchReport(DateFormat('yyyy-MM-dd').format(DateTime.now(),));
      await presenter.saveChanges(1, 2, 3, 4, 'New Accomplishments',
          'New Contributions', 'New Insight', DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(2);
      verify(view.setInProgress(false)).called(2);
      verify(repo.update(report)).called(1);
      verify(view.notifySaved()).called(1);
      verifyNever(view.notifyNotSaved()).called(0);
    });

    test('DailyIntrospectionPresenter saveChanges with existing report fails test',
            () async {
          final repo = MockHappinessReportRepository();
          final presenter = DailyIntrospectionPresenter(userDetails,);
          final view = MockDailyIntrospectionPageView();
          final report = HappinessReportModel.newDailyReport(
            happinessLevel: 5,
            sadnessLevel: 3,
            angerLevel: 1,
            fearLevel: 2,
            careForSelf: 'Accomplishments',
            careForOthers: 'Contributions',
            insight: 'Insight',
            employeeId: 0,
          )..date = Helper.formatter.format(DateTime.now());

          when(repo.getReportByDate(DateFormat('yyyy-MM-dd').format(DateTime.now(),), true))
              .thenAnswer((realInvocation) async => report );
          when(repo.getLastDailyReport())
              .thenAnswer((realInvocation) async => [report]);
          when(view.notifyReportFetched(report))
              .thenAnswer((realInvocation) async => []);
          when(repo.update(report)).thenThrow(RepositoryException('cause'));
          presenter.attachRepositories(repo);
          presenter.attach(view);

          await presenter.fetchReport(DateFormat('yyyy-MM-dd').format(DateTime.now(),));
          await presenter.saveChanges(1, 2, 3, 4, 'New Accomplishments',
            'New Contributions', 'New Insight', DateFormat('yyyy-MM-dd').format(DateTime.now(),));

          verify(view.setInProgress(true)).called(2);
          verify(view.setInProgress(false)).called(2);
          verify(repo.update(report)).called(1);
          verify(view.notifyNotSaved()).called(1);
        });

    test(
        'DailyIntrospectionPresenter saveChanges with repository exception test',
        () async {
      final repo = MockHappinessReportRepository();
      final presenter = DailyIntrospectionPresenter(userDetails,);
      final view = MockDailyIntrospectionPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view);

      when(repo.create(any)).thenThrow(
        RepositoryException(
          'The datasource connector failed to persist the given model instance, so an EmptyModel was returned.',
        ),
      );

      await presenter.saveChanges(
          1, 2, 3, 4, 'Accomplishments', 'Contributions', 'Insight', DateFormat('yyyy-MM-dd').format(DateTime.now(),));

      verify(view.setInProgress(true)).called(1);
      verify(view.setInProgress(false)).called(1);
      verify(repo.create(any)).called(1);
      verify(view.notifyNotSaved()).called(1);
      verifyNever(view.notifySaved()).called(0);
    });
  });
}
