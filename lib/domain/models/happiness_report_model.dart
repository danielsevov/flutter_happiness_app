// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_equals_and_hash_code_on_mutable_classes, avoid_dynamic_calls

import 'package:happiness_app/domain/models/model.dart';
import 'package:happiness_app/helper.dart';
import 'package:intl/intl.dart';

/// Model class for happiness report data.
class HappinessReportModel implements Model {

  @override
  /// Constructor that creates a new instance of [HappinessReportModel] from JSON data.
  /// Takes a [Map<String, dynamic>] parameter [json] and initializes the properties
  /// of the [HappinessReportModel] object with its values.
  HappinessReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    employeeId = json['x_employee_id'] is List ? json['x_employee_id'][0] as int : json['x_employee_id'] as int;
    isDailyReport = json['x_is_daily_report'] as bool;
    try {
      date = Helper.formatter.format(DateTime.parse(json['x_date'] as String));
    }
    catch (e){
      date = Helper.formatter.format(DateTime.now());
    }
    happinessLevel = (json['x_level_happiness'] as int).toDouble();
    sadnessLevel = (json['x_level_sadness']  as int).toDouble();
    angerLevel = (json['x_level_anger']  as int).toDouble();
    fearLevel = (json['x_level_fear']  as int).toDouble();
    careForSelf = json['x_care_for_self'].runtimeType == String ? json['x_care_for_self'] as String : null;
    careForOthers = json['x_care_for_others'].runtimeType == String ? json['x_care_for_others'] as String : null;
    insight = json['x_insight'].runtimeType == String ? json['x_insight'] as String : null;
  }

  HappinessReportModel.newDailyReport(
      {required this.happinessLevel,
        required this.sadnessLevel,
      required this.angerLevel,
      required this.fearLevel,
       this.careForSelf,
       this.careForOthers,
       this.insight,
      required this.employeeId,
      this.isDailyReport = true,
      this.date = '',});

  HappinessReportModel.newWeeklyReport(
      {required this.happinessLevel,
        this.sadnessLevel = 0,
        this.angerLevel = 0,
        this.fearLevel = 0,
        this.careForSelf,
        this.insight,
        required this.employeeId,
        this.isDailyReport = false,
        this.date = '',});

  HappinessReportModel.empty(
      {this.happinessLevel = 0,
        this.sadnessLevel = 0,
        this.angerLevel = 0,
        this.fearLevel = 0,
        this.careForSelf = '',
        this.careForOthers = '',
        this.insight = '',
        this.employeeId = 0,
        this.isDailyReport = true,
        this.date = '',});

  // The ID of the daily introspection entry.
  @override
  int? id;

  // The ID of the employee owner of the daily introspection entry.
  late int employeeId;

  // Indicator if this is a weekly or daily report.
  late bool isDailyReport;

  // The happiness level of the daily introspection entry.
  late double happinessLevel;

  // The sadness level of the daily introspection entry.
  late double sadnessLevel;

  // The anger level of the daily introspection entry.
  late double angerLevel;

  // The fear level of the daily introspection entry.
  late double fearLevel;

  // The self-care activities performed by the owner of the daily introspection entry.
  String? careForSelf;

  // The care activities performed for others by the owner of the daily introspection entry.
  String? careForOthers;

  // The insights gained by the owner of the daily introspection entry.
  String? insight;

  // The date of the daily introspection entry.
  late String date;

  @override
  void setNewId(int newId) {
    id = newId;
  }

  @override
  /// Function that converts a [HappinessReportModel] object to a [Map<String, dynamic>]
  /// representation that can be used for JSON encoding.
  Map<String, dynamic> toJson() => {
        'id': id,
        'x_employee_id': employeeId,
        'x_is_daily_report': isDailyReport,
        'x_level_happiness': happinessLevel.toInt(),
        'x_level_sadness': sadnessLevel.toInt(),
        'x_level_anger': angerLevel.toInt(),
        'x_level_fear': fearLevel.toInt(),
        'x_care_for_self': careForSelf,
        'x_care_for_others': careForOthers,
        'x_insight': insight,
        'x_date': DateFormat('yyyy-MM-dd').format(Helper.formatter.parse(date)),
      };


  @override
  String toString() {
    return 'HappinessReportModel{id: $id, employeeId: $employeeId, isDailyReport: $isDailyReport, happinessLevel: $happinessLevel, sadnessLevel: $sadnessLevel, angerLevel: $angerLevel, fearLevel: $fearLevel, careForSelf: $careForSelf, careForOthers: $careForOthers, insight: $insight, date: $date}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HappinessReportModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          employeeId == other.employeeId &&
          isDailyReport == other.isDailyReport &&
          happinessLevel == other.happinessLevel &&
          sadnessLevel == other.sadnessLevel &&
          angerLevel == other.angerLevel &&
          fearLevel == other.fearLevel &&
          careForSelf == other.careForSelf &&
          careForOthers == other.careForOthers &&
          insight == other.insight &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      employeeId.hashCode ^
      isDailyReport.hashCode ^
      happinessLevel.hashCode ^
      sadnessLevel.hashCode ^
      angerLevel.hashCode ^
      fearLevel.hashCode ^
      careForSelf.hashCode ^
      careForOthers.hashCode ^
      insight.hashCode ^
      date.hashCode;
}
