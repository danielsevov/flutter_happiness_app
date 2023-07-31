// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, avoid_slow_async_io

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/data/repositories/happiness_report_repo_impl.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'happiness_report_repo_test.mocks.dart';

@GenerateMocks([Datasource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final datasource = MockDatasource();
  var userDetails = UserDetailsState(0, 0, 0, false);

  setUpAll(() {
    userDetails = UserDetailsState(0, 0, 0, false);
  });

  test('HappinessReportRepositoryImplementation constructor test', () async {
    final HappinessReportRepository repo =
        HappinessReportRepositoryImplementation(
      datasource,
      'x_happiness_report',
      userDetails,
    );

    expect(repo.runtimeType, HappinessReportRepositoryImplementation);
  });

  group('HappinessReportRepositoryImplementation Create tests', () {
    test('Create and persist single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
        datasource,
        'x_happiness_report',
        userDetails,
      );
      final instance = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
      );

      when(datasource.create(any, any)).thenAnswer(
        (realInvocation) async =>
            await realInvocation.positionalArguments[1] as HappinessReportModel,
      );

      final createdInstance = await repo.create(instance);

      verify(datasource.create('x_happiness_report', instance)).called(1);
      expect(createdInstance, instance);
    });

    test('Create and persist single partial model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
        datasource,
        'x_happiness_report',
        userDetails,
      );
      final instance = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
      );

      when(datasource.create(any, any)).thenAnswer(
        (realInvocation) async =>
            await realInvocation.positionalArguments[1] as HappinessReportModel,
      );

      final createdInstance = await repo.create(instance);

      verify(datasource.create('x_happiness_report', instance)).called(1);
      expect(createdInstance, instance);
      expect(createdInstance.careForSelf, null);
      expect(createdInstance.careForOthers, null);
      expect(createdInstance.insight, null);
    });

    test('Create and fail to persist single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
        datasource,
        'x_happiness_report',
        userDetails,
      );
      final instance = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
      );

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.create(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Create and persist single model instance but from wrong type',
        () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
        datasource,
        'x_happiness_report',
        userDetails,
      );
      final instance = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
      );

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      expect(
        () async => repo.create(instance),
        throwsA(isA<RepositoryException>()),
      );
    });
  });
  //
  group('HappinessReportRepositoryImplementation Get & GetAll tests', () {
    /// Get tests

    test('Get non-existent model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetch(any, any))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get wrong type model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetch(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get wrong id model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetch(any, any)).thenAnswer((realInvocation) async =>
          HappinessReportModel.newDailyReport(
              employeeId: 1,
              happinessLevel: 0,
              sadnessLevel: 0,
              angerLevel: 0,
              fearLevel: 0,
              careForSelf: '',
              careForOthers: '',
              insight: '',),);

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get right id model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);
      instance.setNewId(1);

      when(datasource.fetch(any, any))
          .thenAnswer((realInvocation) async => instance);

      expect(
        () async => repo.get(1),
        returnsNormally,
      );
    });

    test('Get right id partial model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,);
      instance.setNewId(1);

      when(datasource.fetch(any, any))
          .thenAnswer((realInvocation) async => instance);

      final createdInstance = await repo.get(1);
      expect(createdInstance.careForSelf, null);
      expect(createdInstance.careForOthers, null);
      expect(createdInstance.insight, null);
    });

    /// GetAll tests

    test('GetAll non-existent model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getAllDailyReports(), <HappinessReportModel>[]);
    });

    test('GetAll wrong type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [TestModel(), EmptyModel()]);

      expect(await repo.getAllDailyReports(), <HappinessReportModel>[]);
    });

    test('GetAll mixed wrong and right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [
                TestModel(),
                EmptyModel(),
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',)
              ],);

      expect(await repo.getAllDailyReports(), [
        HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 0,
            sadnessLevel: 0,
            angerLevel: 0,
            fearLevel: 0,
            careForSelf: '',
            careForOthers: '',
            insight: '',)
      ]);
    });

    test('GetAll right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                    date: Helper.formatter.format(DateTime.now()),),
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                  date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 1))),),
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                  date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 2))),),
              ],);

      expect((await repo.getAllDailyReports()).length, 3);
    });

    test('GetLast right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'),
              fields: anyNamed('fields'),
              offset: anyNamed('offset'),
              order: anyNamed('order'),
              limit: anyNamed('limit'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                    date: Helper.formatter.format(DateTime.now()),),
              ],);

      expect((await repo.getLastDailyReport()).length, 1);
    });

    test('GetN right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'),
              fields: anyNamed('fields'),
              offset: anyNamed('offset'),
              order: anyNamed('order'),
              limit: anyNamed('limit'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                    date: Helper.formatter.format(DateTime.now()),),
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                  date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 1))),),
                HappinessReportModel.newDailyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    sadnessLevel: 0,
                    angerLevel: 0,
                    fearLevel: 0,
                    careForSelf: '',
                    careForOthers: '',
                    insight: '',
                  date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 2))),),
              ],);

      expect((await repo.getDailyReports(3, 0)).length, 3);
    });

    test('GetAll non-existent model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getAllWeeklyReports(), <HappinessReportModel>[]);
    });

    test('GetAll wrong type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [TestModel(), EmptyModel()]);

      expect(await repo.getAllWeeklyReports(), <HappinessReportModel>[]);
    });

    test('GetAll mixed wrong and right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [
                TestModel(),
                EmptyModel(),
                HappinessReportModel.newWeeklyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    careForSelf: '',
                    insight: '',)
              ],);

      expect(await repo.getAllWeeklyReports(), [
        HappinessReportModel.newWeeklyReport(
            employeeId: 1, happinessLevel: 0, careForSelf: '', insight: '',)
      ]);
    });

    test('GetAll right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newWeeklyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    careForSelf: '',
                    insight: '',)
              ],);

      expect((await repo.getAllWeeklyReports()).length, 1);
    });

    test('GetLast right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'),
              fields: anyNamed('fields'),
              offset: anyNamed('offset'),
              order: anyNamed('order'),
              limit: anyNamed('limit'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newWeeklyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    careForSelf: '',
                    insight: '',),
              ],);

      expect((await repo.getLastWeeklyReport()).length, 1);
    });

    test('GetN right type model instances', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any,
              domain: anyNamed('domain'),
              fields: anyNamed('fields'),
              offset: anyNamed('offset'),
              limit: anyNamed('limit'),),)
          .thenAnswer((realInvocation) async => [
                HappinessReportModel.newWeeklyReport(
                    employeeId: 1,
                    happinessLevel: 0,
                    careForSelf: '',
                    insight: '',),
              ],);

      expect((await repo.getWeeklyReports(3, 0)).length, 1);
    });
  });

  group('HappinessReportRepositoryImplementation Delete tests', () {
    /// Delete tests

    test('Delete non-existent single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.delete(any, any))
          .thenAnswer((realInvocation) async => false);

      expect(
        () async => repo.delete(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Delete single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);

      when(datasource.delete(any, any))
          .thenAnswer((realInvocation) async => true);

      expect(
        () async => repo.delete(1),
        returnsNormally,
      );
      expect(
        await repo.delete(1),
        true,
      );
    });
  });

  group('HappinessReportRepositoryImplementation Update tests', () {
    /// Update tests

    test('Update non-existent single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update wrong type single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update wrong id single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);
      final instance2 = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);
      instance2.setNewId(1);

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => instance2);

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update single model instance', () async {
      final HappinessReportRepository repo =
          HappinessReportRepositoryImplementation(
              datasource, 'x_happiness_report', userDetails,);
      final instance = HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',);

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => instance);

      expect(
        () async => repo.update(instance),
        returnsNormally,
      );
      expect(
        await repo.update(instance),
        instance,
      );
    });
  });

  group('HappinessReportRepositoryImplementation GetTeamDailyReports tests', () {
    test('returns empty list when given empty employee id list', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'))).thenAnswer((realInvocation) async => []);

      expect(await repo.getTeamDailyReports(), <HappinessReportModel>[]);
    });

    test('returns only daily reports of given employee ids', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails);

      final reports = [
        TestModel(),
        EmptyModel(),
        HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 0,
            sadnessLevel: 0,
            angerLevel: 0,
            fearLevel: 0,
            careForSelf: '',
            careForOthers: '',
            insight: '',)
      ];
      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getTeamDailyReports(), [reports.last]);
    });
  });
  //
  group('HappinessReportRepositoryImplementation GetTeamWeeklyReports tests', () {
    test('returns empty list when given empty employee id list', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'))).thenAnswer((realInvocation) async => []);

      expect(await repo.getTeamWeeklyReports(), <HappinessReportModel>[]);
    });

    test('returns only weekly reports of given employee ids', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails);

      final reports = [
        TestModel(),
        EmptyModel(),
        HappinessReportModel.newWeeklyReport(
            employeeId: 1, happinessLevel: 0, careForSelf: '', insight: '',)
      ];
      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getTeamWeeklyReports(), [reports.last]);
    });
  });

  group('HappinessReportRepositoryImplementation getDailyStreak tests', () {
    test('returns 0 when there are no reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'), limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 0);
    });

    test('streak breaks when yesterday\'s report is not filled out', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate reports for the past three days excluding yesterday's report
      final twoDaysAgo = DateTime(2023, 6, 15).subtract(Duration(days: 2));
      var reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(DateTime(2023, 6, 15)), // Today's report
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(twoDaysAgo), // Day before yesterday's report
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports[1]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 2))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be 0 as yesterday's report is missing
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 1);
    });

    test('streak breaks when a weekday report is missing, despite weekend reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate reports for the past three days excluding a weekday report, but including weekend
      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = List.generate(3, (index) =>
          HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            careForSelf: 'Care self',
            careForOthers: 'Care others',
            insight: 'My insight',
            date: Helper.formatter.format(yesterday.subtract(Duration(days: index))),
          )
      );

      // Remove the weekday report and leave only the weekend ones
      reports.removeWhere((report) {
        var reportDay = Helper.formatter.parse(report.date).weekday;
        return reportDay != DateTime.saturday && reportDay != DateTime.sunday;
      });

      // Mock datasource for the remaining reports and an empty one for the missing weekday
      for (var i = 0; i < reports.length; i++) {
        when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: i))
            .thenAnswer((realInvocation) async => [reports[i]]);
      }
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: reports.length))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be 0 as a weekday report is missing
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 0);
    });

    test('streak continues when all consecutive reports are available', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate reports for the past three days including today's report
      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = List.generate(3, (index) =>
          HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            careForSelf: 'Care self',
            careForOthers: 'Care others',
            insight: 'My insight',
            date: Helper.formatter.format(yesterday.subtract(Duration(days: index))),
          )
      );

      // Mock datasource for all the reports
      for (var i = 0; i < reports.length; i++) {
        when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: i))
            .thenAnswer((realInvocation) async => [reports[i]]);
      }
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 3))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be equal to the number of reports
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), reports.length);
    });

    test('streak continues with weekend reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate reports for the past five days including weekend reports
      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = <HappinessReportModel>[];

      for (int i = 0; i < 5; i++) {
        reports.add(HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(yesterday.subtract(Duration(days: i))),
        ));
      }

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports[1]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 2))
          .thenAnswer((realInvocation) async => [reports[2]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 3))
          .thenAnswer((realInvocation) async => [reports[3]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 4))
          .thenAnswer((realInvocation) async => [reports[4]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 5))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be equal to the number of reports
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), reports.length);
    });

    test('streak breaks with missing reports on weekdays and weekends', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate reports for the past fourteen days excluding all weekday and weekend reports
      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = List.generate(14, (index) =>
          HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            careForSelf: 'Care self',
            careForOthers: 'Care others',
            insight: 'My insight',
            date: Helper.formatter.format(yesterday.subtract(Duration(days: index))),
          )
      );

      // Remove all weekday and weekend reports
      reports.removeWhere((report) {
        var reportDay = Helper.formatter.parse(report.date).weekday;
        return reportDay != DateTime.saturday && reportDay != DateTime.sunday;
      });

      // Mock datasource for the remaining reports and an empty one for the missing weekdays and weekends
      for (var i = 0; i < reports.length; i++) {
        when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: i))
            .thenAnswer((realInvocation) async => [reports[i]]);
      }
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: reports.length))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be equal to the number of reports
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 0);
    });

    test('streak continues when weekday reports are present after a weekend without reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate reports for the past five days excluding the weekend reports
      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = <HappinessReportModel>[];

      for (int i = 0; i < 5; i++) {
        reports.add(HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(yesterday.subtract(Duration(days: i))),
        ));
      }

      // Remove the weekend reports
      reports.removeWhere((report) {
        var reportDay = Helper.formatter.parse(report.date).weekday;
        return reportDay == DateTime.saturday || reportDay == DateTime.sunday;
      });

      // Mock datasource for the remaining reports and an empty one for the missing weekends
      for (var i = 0; i < reports.length; i++) {
        when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: i))
            .thenAnswer((realInvocation) async => [reports[i]]);
      }
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: reports.length))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be equal to the number of weekday reports
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), reports.length);
    });

    test('streak breaks when today\'s report is not filled', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 2));
      var reports = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(yesterday),
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => []);

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [reports]);

      // The streak should be 0 as today's report is missing
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 0);
    });

    test('streak continues when today\'s report is filled', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      final yesterday = DateTime(2023, 6, 15).subtract(Duration(days: 1));
      var reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(DateTime(2023, 6, 15)), // Today's report
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(yesterday), // Yesterday's report
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports[1]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be 2 as today and yesterday's reports are both present
      expect(await repo.getDailyStreak(DateTime(2023, 6, 15)), 2);
    });
  });

  group('HappinessReportRepositoryImplementation getLongestDailyStreak tests', () {
    test('returns 0 when there are no daily reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getLongestDailyStreak(), 0);
    });

    test('returns correct longest streak when there are consecutive daily reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 5 reports with consecutive dates
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final reports = List.generate(5, (index) =>
          HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            careForSelf: 'Care self',
            careForOthers: 'Care others',
            insight: 'My insight',
            date: Helper.formatter.format(yesterday.subtract(Duration(days: index))),
          )
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.toList());

      expect(await repo.getLongestDailyStreak(), reports.length);
    });

    test('stops counting the streak when there is a gap between reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 3 reports with a gap of one day between the first and second report
      final threeDaysAgo = DateTime(2023, 6, 15).subtract(Duration(days: 3));
      final reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(DateTime(2023, 6, 15).subtract(Duration(days: 1))), // Yesterday
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: Helper.formatter.format(threeDaysAgo), // Three days ago
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.toList());

      expect(await repo.getLongestDailyStreak(), 1);
    });

    test('breaks the streak if a weekday is missed but continues if a weekend is missed', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 4 reports with one weekday (Tuesday) and one weekend (Sunday) day skipped
      final reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '08-06-2023', // Last Monday
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '09-06-2023', // Previous Friday
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '12-06-2023', // Previous Thursday
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '13-06-2023', // Previous Wednesday
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.reversed.toList());

      expect(await repo.getLongestDailyStreak(), 4);
    });

    test('continues the streak when a report is made on Friday and the next one is on Monday', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate 2 reports with one made on Friday and the next one made on Monday
      final reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '05-06-2023', // Monday (DD-MM-YYYY)
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '02-06-2023', // Previous Friday (DD-MM-YYYY)
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.toList());

      expect(await repo.getLongestDailyStreak(), 2);
    });

    test('continues the streak if a report was made on any weekday, then skipped on weekend and the next one is on Monday', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate 2 reports with one made on Thursday and the next one made on Monday
      final reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '05-06-2023', // Monday (DD-MM-YYYY)
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '02-06-2023', // Previous Friday (DD-MM-YYYY)
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.toList());

      expect(await repo.getLongestDailyStreak(), 2);
    });

    test('continues the streak if a report was made on any weekday, then the next one is on Sunday', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      // Generate 2 reports with one made on Saturday and the next one made on Sunday
      final reports = [
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '04-06-2023', // Sunday (DD-MM-YYYY)
        ),
        HappinessReportModel.newDailyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: '03-06-2023', // Saturday (DD-MM-YYYY)
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports.toList());

      expect(await repo.getLongestDailyStreak(), 2);
    });

    test('does not count non-consecutive days within the same week as a streak', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      final mondayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 5)), // Monday
      );
      final wednesdayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 7)), // Wednesday
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [mondayReport, wednesdayReport]);

      expect(await repo.getLongestDailyStreak(), 1);
    });

    test('counts consecutive days spanning multiple weeks as a streak', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      final fridayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 2)), // Friday
      );
      final saturdayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 3)), // Saturday
      );
      final mondayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 5)), // Monday
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [fridayReport, saturdayReport, mondayReport]);

      expect(await repo.getLongestDailyStreak(), 3);
    });

    test('does not count days spanning multiple weeks with a missing Monday as a streak', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,
      );

      final fridayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 2)), // Friday
      );
      final tuesdayReport = HappinessReportModel.newDailyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: Helper.formatter.format(DateTime(2023, 6, 6)), // Tuesday
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [fridayReport, tuesdayReport]);

      expect(await repo.getLongestDailyStreak(), 1);
    });
  });

  group('HappinessReportRepositoryImplementation getWeeklyStreak tests', () {
    test('returns 0 when there are no weekly reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'),   fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getWeeklyStreak(DateTime.now()), 0);
    });

    test('returns correct streak when there are consecutive weekly reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 3 weekly reports with consecutive week numbers
      final reports = List.generate(3, (index) =>
          HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',
            date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7 * index))),
          )
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports[1]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 2))
          .thenAnswer((realInvocation) async => [reports[2]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 3))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getWeeklyStreak(DateTime.now()), reports.length);
    });

    test('stops counting the streak when there is a gap between reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 3 weekly reports with a gap of one week between the first and second report
      final twoWeeksAgo = DateTime.now().subtract(Duration(days: 7));
      final reports = [
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 0))), // Last week
        ),
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(twoWeeksAgo), // Two weeks ago
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1)).thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [reports[0]]);
      // Streak should only count the first report
      expect(await repo.getWeeklyStreak(DateTime.now()), 1);
    });

    test('returns 1 when there is a single weekly report', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails,);

      final report = HappinessReportModel.newWeeklyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        insight: 'My insight',
        date: Helper.formatter.format(DateTime.now()),
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [report]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => [report]);

      expect(await repo.getWeeklyStreak(DateTime.now()), 1);
    });

    test('returns correct streak when reports are non-consecutive', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails,);

      // Generate 2 weekly reports with non-consecutive week numbers
      final reports = List.generate(2, (index) =>
          HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',
            date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7 * (index*2)))),
          )
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be 1, as the reports are not consecutive
      expect(await repo.getWeeklyStreak(DateTime.now()), 1);
    });

    test('handles year boundaries correctly', () async {
      final HappinessReportRepository repo = HappinessReportRepositoryImplementation(datasource, 'x_happiness_report', userDetails,);

      // Generate 2 weekly reports, one at the end of the year and one at the start of the next year
      final lastYear = DateTime(DateTime.now().year - 1, 12, 31);
      final thisYear = DateTime(DateTime.now().year, 1, 7);

      final reports = [
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(thisYear),
        ),
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(lastYear),
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 0))
          .thenAnswer((realInvocation) async => [reports[0]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 1))
          .thenAnswer((realInvocation) async => [reports[1]]);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'),  limit: 1, offset: 2))
          .thenAnswer((realInvocation) async => []);
      when(datasource.fetchAll(any, domain: anyNamed('domain'),  fields: anyNamed('fields'), order: anyNamed('order'), ))
          .thenAnswer((realInvocation) async => reports);

      // The streak should be 2, as the reports are consecutive weeks spanning a year boundary
      expect(await repo.getWeeklyStreak(DateTime(DateTime.now().year, 1, 7)), 2);
    });
  });

  group('HappinessReportRepositoryImplementation getLongestWeeklyStreak tests', () {
    test('returns 0 when there are no weekly reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => []);

      expect(await repo.getLongestWeeklyStreak(), 0);
    });

    test('returns correct longest streak when there are consecutive weekly reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 3 weekly reports with consecutive week numbers
      final reports = List.generate(3, (index) =>
          HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',
            date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7 * index))),
          )
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getLongestWeeklyStreak(), reports.length);
    });

    test('returns the longest streak when there are non-consecutive reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 4 weekly reports with a gap of one week between the first and second report
      final threeWeeksAgo = DateTime.now().subtract(Duration(days: 7 * 3));
      final reports = [
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(DateTime.now()), // This week
        ),
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7))), // Last week
        ),
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(threeWeeksAgo), // Three weeks ago
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      // The longest streak is 2, not 3, because there is a gap between the first and second report.
      expect(await repo.getLongestWeeklyStreak(), 2);
    });

    test('returns 1 when there is only one weekly report', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 4 weekly reports with a gap of one week between the first and second report
      final reports = [
        HappinessReportModel.newWeeklyReport(
          employeeId: 1,
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          insight: 'My insight',
          date: Helper.formatter.format(DateTime.now()), // This week
        ),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getLongestWeeklyStreak(), 1);
    });

    test('returns correct streak when there are discontinuous weekly reports', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 4 weekly reports with a gap of one week between the first and second report

      final week1Report = HappinessReportModel.newWeeklyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        insight: 'My insight',
        date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7 * 3))), // Week 1
      );
      final week3Report = HappinessReportModel.newWeeklyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        insight: 'My insight',
        // Report properties...
        date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7))), // Week 3
      );
      final week4Report = HappinessReportModel.newWeeklyReport(
        employeeId: 1,
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        insight: 'My insight',
        // Report properties...
        date: Helper.formatter.format(DateTime.now()), // Week 4
      );

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => [week1Report, week3Report, week4Report]);

      expect(await repo.getLongestWeeklyStreak(), 2);
    });

    test('returns correct streak when reports are in reverse order', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      // Generate 3 weekly reports with consecutive week numbers
      final reports = List.generate(3, (index) =>
          HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',
            // Report properties...
            date: Helper.formatter.format(DateTime.now().subtract(Duration(days: 7 * (2 - index)))), // Latest week first
          )
      ).reversed.toList();  // Reverse the order to make it earliest first

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getLongestWeeklyStreak(), reports.length);
    });
  });

  group('HappinessReportRepositoryImplementation getCurrentWeekDailyStreak tests', () {
    test('returns correct streak for current week', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      final reports = [
        HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15))),
        HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15).subtract(Duration(days: 1)))),
        HappinessReportModel.newDailyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15).subtract(Duration(days: 8)))),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((realInvocation) async => reports);

      expect(await repo.getCurrentWeekDailyStreak(DateTime(2023, 6, 15)), 2);
    });

    test('returns 0 when there are no daily reports in current week', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((_) async => []);

      expect(await repo.getCurrentWeekDailyStreak(DateTime.now()), 0);
    });
  });

  group('HappinessReportRepositoryImplementation getCurrentMonthWeeklyStreak tests', () {
    test('returns correct streak for current month', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      final reports = [
        HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15))),
        HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15).subtract(Duration(days: 7)))),
        HappinessReportModel.newWeeklyReport(
            employeeId: 1,
            happinessLevel: 1,
            sadnessLevel: 2,
            angerLevel: 3,
            fearLevel: 4,
            insight: 'My insight',date: Helper.formatter.format(DateTime(2023, 6, 15).subtract(Duration(days: 35)))),
      ];

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((_) async => reports);

      expect(await repo.getCurrentMonthWeeklyStreak(DateTime(2023, 6, 15)), 2);
    });

    test('returns 0 when there are no weekly reports in current month', () async {
      final HappinessReportRepository repo =
      HappinessReportRepositoryImplementation(
        datasource, 'x_happiness_report', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain'), fields: anyNamed('fields'), order: anyNamed('order')))
          .thenAnswer((_) async => []);

      expect(await repo.getCurrentMonthWeeklyStreak(DateTime.now()), 0);
    });
  });

}
