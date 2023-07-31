// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, avoid_slow_async_io

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/datasources/local_datasource.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalDatasource Constructor tests', () {
    test('LocalDatasource constructor test', () async {
      final datasource = LocalDatasource();
      expect(datasource.runtimeType, LocalDatasource);
    });

    test('LocalDatasource singleton test', () async {
      final datasource = LocalDatasource();
      final datasource2 = LocalDatasource();
      expect(datasource, datasource2);
    });
  });

  group('LocalDatasource Create tests', () {
    setUp(() async {
      // Delete the file if it already exists
      final file = File('./data.json');
      if (await file.exists()) {
        await file.delete();
      }

      // Set a mock implementation for the method calls made on this channel
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return '.';
      });
    });

    /// Create tests

    test('Create and persist single model instance', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 1, note : 'This is model 1'));

      expect((await datasource.fetchAll('x_test_model')).length, 1);
    });

    test('Create model instance with automatic ID', () async {
      final datasource = LocalDatasource();
      final storedInstance = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect(storedInstance.id, 1);
    });

    test('Create multiple model instances with automatic ID', () async {
      final datasource = LocalDatasource();
      final storedInstance = await datasource.create('x_test_model', TestModel.initialized(id : 0, note : 'This is model 1'));
      final storedInstance2 = await datasource.create('x_test_model', TestModel.initialized(id : 0, note : 'This is model 2'));
      final storedInstance3 = await datasource.create('x_test_model', TestModel.initialized(id : 0, note : 'This is model 3'));

      expect(storedInstance.id, 1);
      expect(storedInstance2.id, 2);
      expect(storedInstance3.id, 3);
    });

    test('Create and persist single uninitialized model instance', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel());

      expect((await datasource.fetchAll('x_test_model')).length, 1);
    });

    test('Create and persist two different models instances', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel());
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      await datasource.create('x_test_model', TestModel());
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      await datasource.create('x_test_model', TestModel());

      expect((await datasource.fetchAll('x_test_model')).length, 3);
      expect((await datasource.fetchAll('x_happiness_report')).length, 2);

      final intro1 = await datasource.fetch('x_happiness_report', 1) as HappinessReportModel;
      final intro2 = await datasource.fetch('x_happiness_report', 2) as HappinessReportModel;

      expect(intro1.date, Helper.formatter.format(DateTime.now()));
      expect(intro2.date, Helper.formatter.format(DateTime.now()));
    });

    test('Create and persist partial model instance', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', date: Helper.formatter.format(DateTime.now()), employeeId: 0));

      expect((await datasource.fetchAll('x_happiness_report')).length, 2);

      final intro1 = await datasource.fetch('x_happiness_report', 1) as HappinessReportModel;
      final intro2 = await datasource.fetch('x_happiness_report', 2) as HappinessReportModel;

      expect(intro1.date, Helper.formatter.format(DateTime.now()));
      expect(intro1.careForOthers, null);
      expect(intro1.careForSelf, null);
      expect(intro1.insight, null);

      expect(intro2.date, Helper.formatter.format(DateTime.now()));
      expect(intro2.careForOthers, 'Care others');
      expect(intro2.careForSelf, 'Care self');
      expect(intro2.insight, null);
    });
  });

  group('LocalDatasource Fetch & FetchAll tests', () {
    setUp(() async {
      // Delete the file if it already exists
      final file = File('./data.json');
      if (await file.exists()) {
        await file.delete();
      }

      // Set a mock implementation for the method calls made on this channel
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return '.';
      });
    });

    /// Fetch tests

    test('Fetch non-existent model instance', () async {
      final datasource = LocalDatasource();
      expect((await datasource.fetch('x_test_model', 1)).runtimeType, EmptyModel);
    });

    test('Fetch different type model instance', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect((await datasource.fetch('Something', 1)).runtimeType, EmptyModel);
    });

    test('Create and Fetch single model instance', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect(await datasource.fetch('x_test_model', stored.id!), stored);
    });

    test('Create and Fetch multiple model instances', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final stored2 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 2'));
      final stored3 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 3'));

      expect(await datasource.fetch('x_test_model', stored.id!), stored);
      expect(await datasource.fetch('x_test_model', stored2.id!), stored2);
      expect(await datasource.fetch('x_test_model', stored3.id!), stored3);
    });

    test('Create and Fetch multiple different model instances', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final stored2 = await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      final stored3 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 2'));
      final stored4 = await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, date: Helper.formatter.format(DateTime.now()), employeeId: 0));

      expect(await datasource.fetch('x_test_model', 1), stored);
      expect(await datasource.fetch('x_happiness_report', 1), stored2);
      expect(await datasource.fetch('x_test_model', 2), stored3);
      expect(await datasource.fetch('x_happiness_report', 2), stored4);
    });

    /// FetchAll tests

    test('FetchAll non-existent model instance', () async {
      final datasource = LocalDatasource();
      expect((await datasource.fetchAll('x_test_model')).length, 0);
    });

    test('FetchAll different type model instance', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect((await datasource.fetchAll('Something')).length, 0);
    });

    test('Create and FetchAll single model instance', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect((await datasource.fetchAll('x_test_model')).first, stored);
    });

    test('Create and FetchAll multiple model instances', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final stored2 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 2'));
      final stored3 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 3'));

      final list = await datasource.fetchAll('x_test_model');

      expect(list[0], stored);
      expect(list[1], stored2);
      expect(list[2], stored3);
    });

    test('Create and FetchAll multiple different model instances', () async {
      final datasource = LocalDatasource();
      final stored = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final stored2 = await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      final stored3 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 2'));

      final list = await datasource.fetchAll('x_test_model');

      expect(list.contains(stored), true);
      expect(list.contains(stored2), false);
      expect(list.contains(stored3), true);
    });
  });

  group('LocalDatasource Delete tests', () {
    setUp(() async {
      // Delete the file if it already exists
      final file = File('./data.json');
      if (await file.exists()) {
        await file.delete();
      }

      // Set a mock implementation for the method calls made on this channel
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return '.';
      });
    });

    /// Delete tests

    test('Delete non-existent single model instance', () async {
      final datasource = LocalDatasource();

      expect(await datasource.delete('x_test_model', 1), false);
    });

    test('Delete single model instance with wrong id', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect(await datasource.delete('x_test_model', 2), false);
    });

    test('Delete single model instance with right id', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect(await datasource.delete('x_test_model', 1), true);
    });

    test('Delete single model instance with right id but wrong type', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect(await datasource.delete('Something', 1), false);
    });

    test('Delete single model instance with right id and right type', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));

      expect((await datasource.fetchAll('x_test_model')).length, 1);
      expect(await datasource.delete('x_test_model', 1), true);
      expect((await datasource.fetchAll('x_test_model')).length, 0);
      expect(await datasource.delete('x_test_model', 1), false);

      expect((await datasource.fetchAll('x_happiness_report')).length, 1);
      expect(await datasource.delete('x_happiness_report', 1), true);
      expect((await datasource.fetchAll('x_happiness_report')).length, 0);
      expect(await datasource.delete('x_happiness_report', 1), false);
    });
  });

  group('LocalDatasource Update tests', () {
    setUp(() async {
      // Delete the file if it already exists
      final file = File('./data.json');
      if (await file.exists()) {
        await file.delete();
      }

      // Set a mock implementation for the method calls made on this channel
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return '.';
      });
    });

    /// Update tests

    test('Update non-existent single model instance', () async {
      final datasource = LocalDatasource();

      expect((await datasource.update('x_test_model', TestModel())).runtimeType, EmptyModel);
    });

    test('Update single model instance with wrong type', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));

      expect((await datasource.update('Something', TestModel.initialized(id : 1, note : 'New note'))).runtimeType, EmptyModel);
    });

    test('Update single model instance with wrong id', () async {
      final datasource = LocalDatasource();
      final storedInstance = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final updatedInstance = TestModel.initialized(id : 2, note : 'New note');

      expect((await datasource.update('x_test_model', updatedInstance)).runtimeType, EmptyModel);
      expect(await datasource.fetch('x_test_model', 1), storedInstance);
    });

    test('Update single model instance with right id', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final updatedInstance = TestModel.initialized(id : 1, note : 'New note');

      expect(await datasource.update('x_test_model', updatedInstance), updatedInstance);
      expect(await datasource.fetch('x_test_model', 1), updatedInstance);
    });

    test('Update single partial model instance with right id', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      final updatedInstance = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0);
      updatedInstance.setNewId(1);

      expect(await datasource.update('x_happiness_report', updatedInstance), updatedInstance);
      expect(await datasource.fetch('x_happiness_report', 1), updatedInstance);
    });

    test('Update multiple model instances', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final storedInstance2 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final updatedInstance = TestModel.initialized(id : 1, note : 'New note 1');
      final updatedInstance3 = TestModel.initialized(id : 3, note : 'New note 3');

      expect(await datasource.update('x_test_model', updatedInstance), updatedInstance);
      expect(await datasource.update('x_test_model', updatedInstance3), updatedInstance3);

      expect(await datasource.fetch('x_test_model', 1), updatedInstance);
      expect(await datasource.fetch('x_test_model', 2), storedInstance2);
      expect(await datasource.fetch('x_test_model', 3), updatedInstance3);
    });

    test('Update multiple different model instances', () async {
      final datasource = LocalDatasource();
      await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final storedInstance2 = await datasource.create('x_happiness_report', HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: Helper.formatter.format(DateTime.now()), employeeId: 0));
      final storedInstance3 = await datasource.create('x_test_model', TestModel.initialized(id : 10, note : 'This is model 1'));
      final updatedInstance = TestModel.initialized(id : 1, note : 'New note 1');

      expect(await datasource.update('x_test_model', updatedInstance), updatedInstance);
      expect(await datasource.fetch('x_test_model', 1), updatedInstance);

      expect((await datasource.update('x_happiness_report', updatedInstance)).runtimeType, EmptyModel);
      expect(await datasource.fetch('x_happiness_report', 1), storedInstance2);

      expect(await datasource.fetch('x_test_model', 2), storedInstance3);

      updatedInstance.setNewId(2);
      expect(await datasource.update('x_test_model', updatedInstance), updatedInstance);

      expect(await datasource.fetch('x_test_model', 2), updatedInstance);
    });
  });
}
