// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:happiness_app/domain/models/happiness_report_model.dart';

/// This is an abstract class that defines the contract for any [HappinessReportModel] repository.
abstract class HappinessReportRepository {
  /// Returns a [Future] that completes with a [List] of all daily [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getAllDailyReports();

  /// Returns a [Future] that completes with a [List] of all weekly [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getAllWeeklyReports();

  /// Returns a [Future] that completes with a [HappinessReportModel] object that has the specified [id].
  Future<HappinessReportModel> get(int id);

  /// Returns a [Future] that completes with a [HappinessReportModel] object that has been created successfully.
  ///
  /// The [dailyIntrospection] parameter should be a [HappinessReportModel] object that contains all the necessary properties for creating a new introspection.
  Future<HappinessReportModel> create(HappinessReportModel dailyIntrospection);

  /// Returns a [Future] that completes with a [HappinessReportModel] value indicating whether the update operation was successful or not.
  ///
  /// The [dailyIntrospection] parameter should be a [HappinessReportModel] object that contains the updated properties.
  Future<HappinessReportModel> update(HappinessReportModel dailyIntrospection);

  /// Returns a [Future] that completes with a [bool] value indicating whether the delete operation was successful or not.
  ///
  /// The [id] parameter should be an [int] representing the ID of the [HappinessReportModel] object that needs to be deleted.
  Future<bool> delete(int id);

  /// Returns a [Future] that completes with a [List] of n daily [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getDailyReports(int n, int? offset);

  /// Returns a [Future] that completes with a [List] of n weekly [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getWeeklyReports(int n, int? offset);

  /// Returns a [Future] that completes with a [List] holding the last daily [HappinessReportModel].
  Future<List<HappinessReportModel>> getLastDailyReport();

  /// Returns a [Future] that completes with a [List] holding the last weekly [HappinessReportModel].
  Future<List<HappinessReportModel>> getLastWeeklyReport();

  /// Returns a [Future] that completes with a [List] of all daily [HappinessReportModel] objects,
  /// created by employees which are team members of the current user.
  Future<List<HappinessReportModel>> getTeamDailyReports();

  /// Returns a [Future] that completes with a [List] of all weekly [HappinessReportModel] objects.
  /// created by employees which are team members of the current user.
  Future<List<HappinessReportModel>> getTeamWeeklyReports();

  /// Returns a [Future] that completes with a [List] of all daily [HappinessReportModel] objects,
  /// created by the current user for a date.
  Future<HappinessReportModel?> getReportByDate(String date, bool isDaily);

  /// Returns a [Future] that completes with a [List] of all daily [HappinessReportModel] objects,
  /// created by the current user for a week number.
  Future<HappinessReportModel?> getReportByWeekNumber(int weekNumber, int year);
}
