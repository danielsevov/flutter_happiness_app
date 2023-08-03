// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/views/pages/settings_page_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'settings_presenter_test.mocks.dart';

@GenerateMocks([HappinessSettingsRepository, SettingsPageView])
void main() {

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));

    // Register the MethodChannel with the Flutter engine for testing
    const MethodChannel('dexterous.com/flutter/local_notifications')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'cancelAll') {

      }
      if (methodCall.method == 'zonedSchedule') {

      }
      return null;
    });
  });


  group('Settings Presenter tests', ()
  {
    test('SettingsPresenter constructor test', () {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      presenter.attachRepositories(repo);

      expect(presenter, isA<SettingsPresenter>());
      expect(presenter.repositoriesAttached, true);
    });

    test('SettingsPresenter attach and detach view test', () {
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      expect(() async => presenter.attach(view), returnsNormally);
      expect(() async => presenter.detach(), returnsNormally);
    });
  });

  // Tests for fetchSettings and changeLocale

  group('fetchSettings and changeLocale tests', () {
    test('SettingsPresenter fetchSettings test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      final instance = HappinessSettingsModel.newSettings(monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.getMySettings()).thenAnswer((_) async => instance);

      await presenter.fetchSettings();

      verify(repo.getMySettings()).called(1);
      verify(view.notifySettingsImported(instance)).called(1);
    });

    test('SettingsPresenter fetchSettings failure test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      when(repo.getMySettings()).thenThrow(Exception('Failed to fetch settings'));

      expect(() async => presenter.fetchSettings(), throwsException);

      verify(repo.getMySettings()).called(1);
      verifyNever(view.notifySettingsImported(any));
    });

    test('SettingsPresenter changeLocale test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      final instance = HappinessSettingsModel.newSettings(monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, employeeId: 1, canShare: false, locale: 'es', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);
      final instance2 = HappinessSettingsModel.newSettings(monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.update(any)).thenAnswer((_) async => instance);

      when(repo.getMySettings()).thenAnswer((_) async => instance2);

      await presenter.fetchSettings();

      await presenter.changeLocaleSettings('es');

      verify(repo.update(instance)).called(1);
      verify(view.notifySettingsImported(instance2)).called(2);
    });

    test('SettingsPresenter changeLocale failure test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      when(repo.update(any)).thenThrow(Exception(''));

      final instance = HappinessSettingsModel.newSettings(monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.getMySettings()).thenAnswer((_) async => instance);

      await presenter.fetchSettings();

      expect(() async => presenter.changeLocaleSettings('es'), throwsException);

      verify(repo.update(instance)).called(1);
      verify(view.notifySettingsImported(instance)).called(1);

      instance.locale = 'es';
      verifyNever(view.notifySettingsImported(instance));
    });

    test('SettingsPresenter changeNotifications test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      final instance = HappinessSettingsModel.newSettings(monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);
      final instance2 = HappinessSettingsModel.newSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, timeOfTheDay: '14:00', employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.update(any)).thenAnswer((_) async => instance);

      when(repo.getMySettings()).thenAnswer((_) async => instance2);

      await presenter.fetchSettings();

      await presenter.changeNotificationsSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, timeOfTheDay: '14:00', saturday: false, sunday: false, weeklyDayOfTheWeek: Day.friday, );

      verify(repo.update(instance2)).called(1);
      verify(view.notifySettingsImported(instance2)).called(2);
    });

    test('SettingsPresenter changeNotifications failure test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      when(repo.update(any)).thenThrow(Exception(''));

      final instance = HappinessSettingsModel.newSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.getMySettings()).thenAnswer((_) async => instance);

      await presenter.fetchSettings();

      expect(() async => presenter.changeNotificationsSettings(monday: false, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: false, sunday: false, weeklyDayOfTheWeek: Day.friday, ), throwsException);

      verify(repo.update(instance)).called(1);
      verify(view.notifySettingsImported(instance)).called(1);

      instance.monday = false;
      verifyNever(view.notifySettingsImported(instance));
    });

    test('SettingsPresenter changeDatSettings test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      final instance = HappinessSettingsModel.newSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, employeeId: 1, canShare: false, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);
      final instance2 = HappinessSettingsModel.newSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, employeeId: 1, canShare: true, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.update(any)).thenAnswer((_) async => instance);

      when(repo.getMySettings()).thenAnswer((_) async => instance2);

      await presenter.fetchSettings();

      await presenter.changeDataSettings(canShare: true);

      verify(repo.update(instance2)).called(1);
      verify(view.notifySettingsImported(instance2)).called(1);
    });

    test('SettingsPresenter changeDatSettings failure test', () async {
      final repo = MockHappinessSettingsRepository();
      final presenter = SettingsPresenter();
      final view = MockSettingsPageView();

      presenter.attachRepositories(repo);
      presenter.attach(view,);

      when(repo.update(any)).thenThrow(Exception(''));

      final instance = HappinessSettingsModel.newSettings(monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, employeeId: 1, canShare: true, locale: 'en', saturday: false, sunday: false, weeklyReviewDayOfWeek: Day.friday,);

      when(repo.getMySettings()).thenAnswer((_) async => instance);

      await presenter.fetchSettings();

      expect(() async => presenter.changeDataSettings(canShare: false), throwsException);

      verify(repo.update(instance)).called(1);
      verify(view.notifySettingsImported(instance)).called(1);

      instance.canShare = false;
      verifyNever(view.notifySettingsImported(instance));
    });

  });

  group('Utils', () {
    test('convertStringToDay converts "Monday" to Day.monday', () {
      expect(Helper.convertStringToDay('Monday'), equals(Day.monday));
    });

    test('convertStringToDay returns Day.friday for invalid input', () {
      expect(Helper.convertStringToDay('Invalid'), equals(Day.friday));
    });

    test('convertDayToString converts Day.tuesday to "Tuesday"', () {
      expect(Helper.convertDayToString(Day.tuesday), equals('Tuesday'));
    });
  });
}
