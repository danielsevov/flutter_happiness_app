// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, unrelated_type_equality_checks

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// EmptyModel tests

  group('Empty Model tests', () {
    test('EmptyModel constructor test', () async {
      final model = EmptyModel();
      expect(model.runtimeType, EmptyModel);
      expect(model.id, 0);
    });

    test('EmptyModel setNewId does not change ID test', () async {
      final model = EmptyModel();
      model.setNewId(1);
      expect(model.id, 0);
    });

    test('EmptyModel toString() test', () async {
      final model = EmptyModel();
      expect(model.toString(), 'EmptyModel{id: 0}');
    });

    test('EmptyModel toJson() test', () async {
      final model = EmptyModel();
      expect(model.toJson(), {'id': 0});
    });
  });

  /// TestModel tests

  group('Test Model tests', () {
    test('TestModel constructor test', () async {
      final model = TestModel();
      expect(model.runtimeType, TestModel);
      expect(model.id, null);
    });

    test('TestModel setNewId test', () async {
      final model = TestModel();
      model.setNewId(1);
      expect(model.id, 1);
    });

    test('TestModel toString() test', () async {
      final model = TestModel.initialized(id : 1, note : 'My note');
      expect(model.toString(), 'TestModel{id: 1, note: My note}');
    });

    test('TestModel toJson() test', () async {
      final model = TestModel.initialized(id : 1, note : 'My note');
      expect(model.toJson(), {'id': 1, 'x_note' : 'My note'});
    });

    test('TestModel fromJson() test', () async {
      final model = TestModel.initialized(id : 1, note : 'My note');
      final fromJsonModel = TestModel.fromJson({'id': 1, 'x_note' : 'My note'});
      expect(model, fromJsonModel);
    });

    test('TestModel == test', () async {
      final model = TestModel.initialized(id : 1, note : 'My note');
      final modelSame = TestModel.initialized(id : 1, note : 'My note');
      final modelDifferent = TestModel.initialized(id : 2, note : 'My note');
      final modelDifferent2 = TestModel.initialized(id : 1, note : 'My note is this');
      final modelDifferent3 = HappinessReportModel.newDailyReport(happinessLevel: 0, sadnessLevel: 0, angerLevel: 0, fearLevel: 0, careForSelf: '', careForOthers: '', insight: '', employeeId: 0);
      final fromJsonModel = TestModel.fromJson({'id': 1, 'x_note' : 'My note'});

      expect(model == model, true);
      expect(model == modelSame, true);
      expect(model == modelDifferent, false);
      expect(model == modelDifferent2, false);
      expect(model == modelDifferent3, false);
      expect(model == fromJsonModel, true);
    });

    test('TestModel hashcode test', () async {
      final model = TestModel.initialized(id : 1, note : 'My note');
      final modelSame = TestModel.initialized(id : 1, note : 'My note');
      final modelDifferent = TestModel.initialized(id : 2, note : 'My note');
      final modelDifferent2 = TestModel.initialized(id : 1, note : 'My note is this');
      final modelDifferent3 = HappinessReportModel.newDailyReport(happinessLevel: 0, sadnessLevel: 0, angerLevel: 0, fearLevel: 0, careForSelf: '', careForOthers: '', insight: '', employeeId: 0);
      final fromJsonModel = TestModel.fromJson({'id': 1, 'x_note' : 'My note'});

      expect(model.hashCode == model.hashCode, true);
      expect(model.hashCode == modelSame.hashCode, true);
      expect(model.hashCode == null.hashCode, false);
      expect(model.hashCode == modelDifferent.hashCode, false);
      expect(model.hashCode == modelDifferent2.hashCode, false);
      expect(model.hashCode == modelDifferent3.hashCode, false);
      expect(model.hashCode == fromJsonModel.hashCode, true);
    });
  });

  /// HappinessReportModel tests

  group('Daily Introspection tests', () {
    test('HappinessReportModel constructor daily test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 0, sadnessLevel: 0, angerLevel: 0, fearLevel: 0, careForSelf: '', careForOthers: '', insight: '', employeeId: 0);
      expect(model.runtimeType, HappinessReportModel);
      expect(model.id, null);
      expect(model.isDailyReport, true);
    });

    test('HappinessReportModel constructor weekly test', () async {
      final model = HappinessReportModel.newWeeklyReport(happinessLevel: 0, sadnessLevel: 0, angerLevel: 0, fearLevel: 0, insight: '', employeeId: 0);
      expect(model.runtimeType, HappinessReportModel);
      expect(model.id, null);
      expect(model.isDailyReport, false);
    });

    test('HappinessReportModel constructor empty test', () async {
      final model = HappinessReportModel.empty();
      expect(model.runtimeType, HappinessReportModel);
      expect(model.id, null);
    });

    test('HappinessReportModel setNewId test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 0, sadnessLevel: 0, angerLevel: 0, fearLevel: 0, careForSelf: '', careForOthers: '', insight: '', employeeId: 0);
      model.setNewId(1);
      expect(model.id, 1);
    });

    test('HappinessReportModel toString() test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      expect(model.toString(), 'HappinessReportModel{id: null, employeeId: 0, isDailyReport: true, happinessLevel: 1.0, sadnessLevel: 2.0, angerLevel: 3.0, fearLevel: 4.0, careForSelf: Care self, careForOthers: Care others, insight: My insight, date: Date 1}');
    });

    test('HappinessReportModel toJson() test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', employeeId: 0, date: Helper.formatter.format(DateTime.now()));
      expect(model.toJson(), {
        'id': null,
        'x_employee_id': 0,
        'x_is_daily_report': true,
        'x_level_happiness': 1,
        'x_level_sadness': 2,
        'x_level_anger': 3,
        'x_level_fear': 4,
        'x_care_for_self': 'Care self',
        'x_care_for_others': 'Care others',
        'x_insight': 'My insight',
        'x_date': DateFormat('yyyy-MM-dd').format(DateTime.now())
      });
    });

    test('HappinessReportModel fromJson() test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', employeeId: 0);
      final fromJsonModel = HappinessReportModel.fromJson({
        'id': null,
        'x_employee_id': [0],
        'x_is_daily_report': true,
        'x_level_happiness': 1,
        'x_level_sadness': 2,
        'x_level_anger': 3,
        'x_level_fear': 4,
        'x_care_for_self': 'Care self',
        'x_care_for_others': 'Care others',
        'x_insight': 'My insight'
      });

      model.date = Helper.formatter.format(DateTime.now());
      expect(model, fromJsonModel);
    });

    test('HappinessReportModel == test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelSame = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent = HappinessReportModel.newDailyReport(happinessLevel: 2, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent2 = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 3, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent3 = TestModel();
      final fromJsonModel = HappinessReportModel.fromJson({
        'id': null,
        'x_employee_id': [0],
        'x_is_daily_report': true,
        'x_level_happiness': 1,
        'x_level_sadness': 2,
        'x_level_anger': 3,
        'x_level_fear': 4,
        'x_care_for_self': 'Care self',
        'x_care_for_others': 'Care others',
        'x_insight': 'My insight'
      });

      expect(model == model, true);
      expect(model == modelSame, true);
      expect(model == modelDifferent, false);
      expect(model == modelDifferent2, false);
      expect(model == modelDifferent3, false);
      expect(model == fromJsonModel, false);
    });

    test('HappinessReportModel hashcode test', () async {
      final model = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelSame = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent = HappinessReportModel.newDailyReport(happinessLevel: 2, sadnessLevel: 2, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent2 = HappinessReportModel.newDailyReport(happinessLevel: 1, sadnessLevel: 3, angerLevel: 3, fearLevel: 4, careForSelf: 'Care self', careForOthers: 'Care others', insight: 'My insight', date: 'Date 1', employeeId: 0);
      final modelDifferent3 = TestModel();
      final fromJsonModel = HappinessReportModel.fromJson({
        'id': null,
        'x_employee_id': [0],
        'x_is_daily_report': true,
        'x_level_happiness': 1,
        'x_level_sadness': 2,
        'x_level_anger': 3,
        'x_level_fear': 4,
        'x_care_for_self': 'Care self',
        'x_care_for_others': 'Care others',
        'x_insight': 'My insight'
      });

      expect(model.hashCode == model.hashCode, true);
      expect(model.hashCode == modelSame.hashCode, true);
      expect(model.hashCode == null.hashCode, false);
      expect(model.hashCode == modelDifferent.hashCode, false);
      expect(model.hashCode == modelDifferent2.hashCode, false);
      expect(model.hashCode == modelDifferent3.hashCode, false);
      expect(model.hashCode == fromJsonModel.hashCode, false);
    });
  });


  group('HappinessSettingsModel tests', () {
    late HappinessSettingsModel happinessSettings;

    setUp(() {
      happinessSettings = HappinessSettingsModel.newSettings(
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
    });

    test('creates a new HappinessSettingsModel object', () {
      expect(happinessSettings, isA<HappinessSettingsModel>());
    });

    test('sets the ID property', () {
      happinessSettings.setNewId(9);
      expect(happinessSettings.id, equals(9));
    });

    test('sets the correct employeeId property', () {
      expect(happinessSettings.employeeId, equals(1));
    });

    test('sets the correct canShare property', () {
      expect(happinessSettings.canShare, isTrue);
    });

    test('toJson returns the correct value', () {
      expect(
        happinessSettings.toJson(),
        equals({
          'id': null,
          'x_can_share': true,
          'x_locale': null,
          'x_notification_monday': false,
          'x_notification_tuesday': false,
          'x_notification_wednesday': false,
          'x_notification_thursday': false,
          'x_notification_friday': false,
          'x_notification_saturday': false,
          'x_notification_sunday': false,
          'x_notification_time': null,
          'x_weekly_notification_day': 'Friday',
          'x_weekly_notification_time': null,
          'x_employee_id': 1
        }),
      );
    });

    test('fromJson creates a HappinessSettingsModel object with the correct properties', () {
      final json = <String, dynamic>{
        'id': 1,
        'x_can_share': false,
        'x_locale': null,
        'x_notification_monday': false,
        'x_notification_tuesday': false,
        'x_notification_wednesday': false,
        'x_notification_thursday': false,
        'x_notification_friday': false,
        'x_notification_saturday': false,
        'x_notification_sunday': false,
        'x_notification_time': null,
        'x_employee_id': 1,
      };

      final result = HappinessSettingsModel.fromJson(json);

      expect(result.id, equals(1));
      expect(result.canShare, isFalse);
      expect(result.employeeId, equals(1));
      expect(result.monday, isFalse);
      expect(result.tuesday, isFalse);
      expect(result.wednesday, isFalse);
      expect(result.thursday, isFalse);
      expect(result.friday, isFalse);
      expect(result.saturday, isFalse);
      expect(result.sunday, isFalse);
    });

    test('toString returns the correct value', () {
      final result = happinessSettings.toString();

      expect(
        result,
        equals(
          'HappinessSettingsModel{id: null, employeeId: 1, locale: null, canShare: true, monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: false, sunday: false, timeOfTheDay: null, weeklyReviewDayOfWeek: Friday, weeklyReviewTimeOfTheDay: null}',
        ),
      );
    });

    test('operator == returns true for equal objects', () {
      final other = HappinessSettingsModel.newSettings(
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

      expect(happinessSettings == other, isTrue);
    });

    test('hashCode returns the correct value', () {
      final expectedHashCode = HappinessSettingsModel.newSettings(
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
      ).hashCode;

      expect(happinessSettings.hashCode, equals(expectedHashCode));
    });
  });


  /// User Model tests
  group('UserModel tests', () {
    late UserModel user;

    setUp(() {
      final json = <String, dynamic>{'id': 2, 'name': 'Jane Doe',};
      user = UserModel.fromJson(json);
      user.id = 1;
      user.name = 'John Doe';
    });

    test('creates a new UserModel object', () {
      expect(user, isA<UserModel>());
    });

    test('sets the ID property', () {
      user.setNewId(2);
      expect(user.id, equals(2));
    });

    test('sets the correct name property', () {
      expect(user.name, equals('John Doe'));
    });

    test('toJson returns the correct value', () {
      expect(user.toJson(), equals({'id': 1, 'name': 'John Doe',}));
    });

    test('fromJson creates a UserModel object with the correct properties', () {
      final json = <String, dynamic>{'id': 2, 'name': 'Jane Doe',};

      final result = UserModel.fromJson(json);

      expect(result.id, equals(2));
      expect(result.name, equals('Jane Doe'));
    });

    test('toString returns the correct value', () {
      final result = user.toString();

      expect(result, equals('UserModel{id: 1, name: John Doe}'));
    });

    test('operator == returns true for equal objects', () {
      final json = <String, dynamic>{'id': 1, 'name': 'Jane Doe',};
      final other = UserModel.fromJson(json);
      other.id = 1;
      other.name = 'John Doe';

      expect(user == other, isTrue);
    });

    test('operator == returns false for objects with different properties', () {
      final json = <String, dynamic>{'id': 1, 'name': 'Jane Doe',};
      final other = UserModel.fromJson(json);
      other.id = 2;
      other.name = 'Jane Doe';

      expect(user == other, isFalse);
    });

    test('hashCode returns the correct value', () {
      final json = <String, dynamic>{'id': 1, 'name': 'Jane Doe',};
      final otherUser = UserModel.fromJson(json);
      otherUser.id = 1;
      otherUser.name = 'John Doe';

      expect(user.hashCode, otherUser.hashCode);
    });
  });
}
