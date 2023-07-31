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
}
