// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, avoid_slow_async_io, deprecated_member_use

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/data/repositories/happiness_settings_repo_impl.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'happiness_settings_repo_test.mocks.dart';

@GenerateMocks([Datasource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final datasource = MockDatasource();
  var userDetails = UserDetailsState(0, 0, 0, false);

  setUpAll(() {
    userDetails = UserDetailsState(0, 0, 0, false);
  });

  test('HappinessSettingsRepositoryImplementation constructor test', () async {
    final HappinessSettingsRepository repo =
        HappinessSettingsRepositoryImplementation(
            datasource, 'x_happiness_settings', userDetails,);
    expect(repo.runtimeType, HappinessSettingsRepositoryImplementation);
  });

  group('HappinessSettingsRepositoryImplementation GetAll tests', () {
    /// GetAll tests

    test('GetAll non-existent model instance', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer((realInvocation) async => []);

      expect(() async => repo.getForEmployee(1), throwsException);
    });

    test('GetAll wrong type model instances', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer((realInvocation) async => [TestModel(), EmptyModel()]);

      expect(() async => repo.getForEmployee(1), throwsException);
    });

    test('GetAll mixed wrong and right type model instances', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          TestModel(),
          EmptyModel(),
          HappinessSettingsModel.newSettings(
            canShare: true,
            employeeId: 1,
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
            sunday: false,
            timeOfTheDay: '16:00',
            weeklyReviewDayOfWeek: Day.friday,
          )
        ],
      );

      expect(
        await repo.getForEmployee(1),
        HappinessSettingsModel.newSettings(
          canShare: true,
          employeeId: 1,
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
          timeOfTheDay: '16:00',
          weeklyReviewDayOfWeek: Day.friday,
        ),
      );
    });

    test('GetAll right type model instances', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          HappinessSettingsModel.newSettings(
            canShare: true,
            employeeId: 1,
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
            sunday: false,
            weeklyReviewDayOfWeek: Day.friday,
          ),
          HappinessSettingsModel.newSettings(
            canShare: true,
            employeeId: 1,
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
            sunday: false,
            weeklyReviewDayOfWeek: Day.friday,
          ),
          HappinessSettingsModel.newSettings(
            canShare: true,
            employeeId: 1,
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
            sunday: false,
            weeklyReviewDayOfWeek: Day.friday,
          )
        ],
      );

      final settings = await repo.getForEmployee(1);
      expect(settings, isA<HappinessSettingsModel>());
    });
  });

  group('HappinessSettingsRepositoryImplementation Update tests', () {
    /// Update tests

    test('Update non-existent single model instance', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);
      final instance = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        weeklyReviewDayOfWeek: Day.friday,
      );

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update wrong type single model instance', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);
      final instance = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        weeklyReviewDayOfWeek: Day.friday,
      );

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update wrong id single model instance', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);
      final instance = HappinessSettingsModel.newSettings(
        canShare: false,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        weeklyReviewDayOfWeek: Day.friday,
      );
      final instance2 = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        weeklyReviewDayOfWeek: Day.friday,
      );
      instance2.setNewId(1);

      when(datasource.update(any, any))
          .thenAnswer((realInvocation) async => instance2);

      expect(
        () async => repo.update(instance),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Update single model instance', () async {
      final HappinessSettingsRepository repo =
          HappinessSettingsRepositoryImplementation(
              datasource, 'x_happiness_settings', userDetails,);
      final instance = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        weeklyReviewDayOfWeek: Day.friday,
      );

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

  // Additional tests for HappinessSettingsRepositoryImplementation

  group('HappinessSettingsRepositoryImplementation get and getMySettings tests',
      () {
    test('Get non-existent model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);
      const id = 1;

      when(datasource.fetch(any, any)).thenAnswer((_) async => EmptyModel());

      when(datasource.create(any, any))
          .thenThrow(RepositoryException('Error creating the instance'));

      expect(() async => repo.get(id), throwsA(isA<RepositoryException>()));
    });

    test('Get wrong type model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);
      const id = 1;

      when(datasource.fetch(any, any)).thenAnswer((_) async => TestModel());

      when(datasource.create(any, any))
          .thenThrow(RepositoryException('Error creating the instance'));

      expect(() async => repo.get(id), throwsA(isA<RepositoryException>()));
    });

    test('Get wrong type model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);
      const id = 1;

      when(datasource.fetch(any, any)).thenAnswer((_) async => TestModel());

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      expect(() async => repo.get(id), throwsA(isA<RepositoryException>()));
    });

    test('Get existing model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);
      const id = 1;
      final instance = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        timeOfTheDay: '16:00',
        weeklyReviewDayOfWeek: Day.friday,
      );

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => instance);

      when(datasource.fetch(any, any)).thenAnswer((_) async => instance);

      final result = await repo.get(id);
      expect(result, instance);
    });

    test('getMySettings non-existent model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain')))
          .thenAnswer((_) async => []);

      when(datasource.create(any, any))
          .thenThrow(RepositoryException('Error creating the instance'));

      expect(
        () async => repo.getMySettings(),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('getMySettings wrong type model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);

      when(datasource.fetchAll(any, domain: anyNamed('domain')))
          .thenAnswer((_) async => [TestModel()]);

      when(datasource.create(any, any))
          .thenThrow(RepositoryException('Error creating the instance'));

      expect(
        () async => repo.getMySettings(),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('getMySettings wrong type model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => TestModel());

      when(datasource.fetchAll(any, domain: anyNamed('domain')))
          .thenAnswer((_) async => [TestModel()]);

      expect(
        () async => repo.getMySettings(),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('getMySettings existing model instance', () async {
      final repo = HappinessSettingsRepositoryImplementation(
          datasource, 'x_happiness_settings', userDetails,);
      final instance = HappinessSettingsModel.newSettings(
        canShare: true,
        employeeId: 1,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        timeOfTheDay: '16:00',
        weeklyReviewDayOfWeek: Day.friday,
      );

      when(datasource.create(any, any))
          .thenAnswer((realInvocation) async => instance);

      when(datasource.fetchAll(any, domain: anyNamed('domain')))
          .thenAnswer((_) async => [instance]);

      final result = await repo.getMySettings();
      expect(result, instance);
    });
  });

  group('Repository + Datasource tests', () {
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
  });
}
