// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_equals_and_hash_code_on_mutable_classes, avoid_dynamic_calls

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_app/domain/models/model.dart';
import 'package:happiness_app/helper.dart';

/// Model class for the users happiness app settings.
class HappinessSettingsModel implements Model {
  HappinessSettingsModel.newSettings({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.employeeId,
    required this.canShare,
    required this.weeklyReviewDayOfWeek,
    this.timeOfTheDay,
    this.weeklyReviewTimeOfTheDay,
    this.locale,
  });

  @override
  HappinessSettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    employeeId = json['x_employee_id'] is List
        ? json['x_employee_id'][0] as int
        : json['x_employee_id'] as int;
    canShare = json['x_can_share'] as bool;
    monday = json['x_notification_monday'] as bool;
    tuesday = json['x_notification_tuesday'] as bool;
    wednesday = json['x_notification_wednesday'] as bool;
    thursday = json['x_notification_thursday'] as bool;
    friday = json['x_notification_friday'] as bool;
    saturday = json['x_notification_saturday'] as bool;
    sunday = json['x_notification_sunday'] as bool;
    try {
      locale = json['x_locale'] as String;
    } catch (e) {
      locale = 'en';
    }
    try {
      timeOfTheDay = json['x_notification_time'] as String;
    } catch (e) {
      timeOfTheDay = '16:00';
    }
    try {
      weeklyReviewTimeOfTheDay = json['x_weekly_notification_time'] as String;
    } catch (e) {
      weeklyReviewTimeOfTheDay = '16:00';
    }
    try {
      weeklyReviewDayOfWeek = Helper.convertStringToDay(
          json['x_weekly_notification_day'] as String,);
    } catch (e) {
      weeklyReviewDayOfWeek = Day.friday;
    }
  }
  @override
  int? id;

  // The ID of the owner of the entry.
  late int employeeId;

  // preferred locale string
  late String? locale;

  // indicator if daily introspection data can be shared with others
  late bool canShare;

  // indicator if monday is selected by the user
  late bool monday;

  // indicator if tuesday is selected by the user
  late bool tuesday;

  // indicator if wednesday is selected by the user
  late bool wednesday;

  // indicator if thursday is selected by the user
  late bool thursday;

  // indicator if friday is selected by the user
  late bool friday;

  // indicator if saturday is selected by the user
  late bool saturday;

  // indicator if sunday is selected by the user
  late bool sunday;

  // optional time of the day selection indicating when to display the daily reminder during the day
  String? timeOfTheDay;

  // indicator showing day of the week for the weekly review notification
  late Day weeklyReviewDayOfWeek;

  // optional time of the day selection indicating when to display the weekly reminder during the day
  String? weeklyReviewTimeOfTheDay;

  @override
  void setNewId(int newId) {
    id = newId;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'x_can_share': canShare,
        'x_locale': locale,
        'x_notification_monday': monday,
        'x_notification_tuesday': tuesday,
        'x_notification_wednesday': wednesday,
        'x_notification_thursday': thursday,
        'x_notification_friday': friday,
        'x_notification_saturday': saturday,
        'x_notification_sunday': sunday,
        'x_notification_time': timeOfTheDay,
        'x_weekly_notification_day':
            Helper.convertDayToString(weeklyReviewDayOfWeek),
        'x_weekly_notification_time': weeklyReviewTimeOfTheDay,
        'x_employee_id': employeeId,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HappinessSettingsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          employeeId == other.employeeId &&
          locale == other.locale &&
          canShare == other.canShare &&
          monday == other.monday &&
          tuesday == other.tuesday &&
          wednesday == other.wednesday &&
          thursday == other.thursday &&
          friday == other.friday &&
          saturday == other.saturday &&
          sunday == other.sunday &&
          timeOfTheDay == other.timeOfTheDay &&
          weeklyReviewDayOfWeek == other.weeklyReviewDayOfWeek &&
          weeklyReviewTimeOfTheDay == other.weeklyReviewTimeOfTheDay;

  @override
  int get hashCode =>
      id.hashCode ^
      employeeId.hashCode ^
      locale.hashCode ^
      canShare.hashCode ^
      monday.hashCode ^
      tuesday.hashCode ^
      wednesday.hashCode ^
      thursday.hashCode ^
      friday.hashCode ^
      saturday.hashCode ^
      sunday.hashCode ^
      timeOfTheDay.hashCode ^
      weeklyReviewDayOfWeek.hashCode ^
      weeklyReviewTimeOfTheDay.hashCode;

  @override
  String toString() {
    return 'HappinessSettingsModel{id: $id, employeeId: $employeeId, locale: $locale, canShare: $canShare, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, timeOfTheDay: $timeOfTheDay, weeklyReviewDayOfWeek: ${Helper.convertDayToString(weeklyReviewDayOfWeek)}, weeklyReviewTimeOfTheDay: $weeklyReviewTimeOfTheDay}';
  }
}
