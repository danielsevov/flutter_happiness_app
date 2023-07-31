// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';

class HappinessReportRepositoryImplementation
    implements HappinessReportRepository {
  HappinessReportRepositoryImplementation(
      this._datasource, this._modelName, this.userDetails,);
  final UserDetailsState userDetails;
  final Datasource _datasource;
  final String _modelName;

  @override

  /// Returns a [Future] that completes with a [List] of daily [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getAllDailyReports() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', true],
        ['x_employee_id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  /// Returns a [Future] that completes with a [List] of n daily [HappinessReportModel] objects.
  @override
  Future<List<HappinessReportModel>> getDailyReports(int n, int? offset) async {
    final jsonList = await _datasource.fetchAll(_modelName,
        domain: [
          ['x_is_daily_report', '=', true],
          ['x_employee_id', '=', userDetails.currentEmployeeId],
        ],
        order: 'x_date desc',
        limit: n,
        offset: offset,);
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  /// Returns a [Future] that completes with a [List] of n weekly [HappinessReportModel] objects.
  @override
  Future<List<HappinessReportModel>> getWeeklyReports(
      int n, int? offset,) async {
    final jsonList = await _datasource.fetchAll(_modelName,
        domain: [
          ['x_is_daily_report', '=', false],
          ['x_employee_id', '=', userDetails.currentEmployeeId],
        ],
        order: 'x_date desc',
        limit: n,
        offset: offset,);
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  /// Returns a [Future] that completes with a [List] holding the last daily [HappinessReportModel].
  @override
  Future<List<HappinessReportModel>> getLastDailyReport() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', true],
        ['x_employee_id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
      limit: 1,
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  /// Returns a [Future] that completes with a [List] holding the last weekly [HappinessReportModel].
  @override
  Future<List<HappinessReportModel>> getLastWeeklyReport() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', false],
        ['x_employee_id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
      limit: 1,
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  @override

  /// Returns a [Future] that completes with a [List] of weekly [HappinessReportModel] objects.
  Future<List<HappinessReportModel>> getAllWeeklyReports() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', false],
        ['x_employee_id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  @override

  /// Returns a [Future] that completes with a [HappinessReportModel] object that has the specified [id].
  Future<HappinessReportModel> get(int id) async {
    final model = await _datasource.fetch(_modelName, id);
    if (model.runtimeType != HappinessReportModel || model.id != id) {
      throw RepositoryException(
        'The datasource connector failed to read the given model instance, so an EmptyModel was returned.',
      );
    }
    return model as HappinessReportModel;
  }

  @override

  /// Returns a [Future] that completes with a [HappinessReportModel] object that has been created successfully.
  ///
  /// The [happinessReport] parameter should be a [HappinessReportModel] object that contains all the necessary properties for creating a new introspection.
  Future<HappinessReportModel> create(
    HappinessReportModel happinessReport,
  ) async {
    final model = await _datasource.create(_modelName, happinessReport);
    if (model.runtimeType != HappinessReportModel) {
      throw RepositoryException(
        'The datasource connector failed to persist the given model instance, so an EmptyModel was returned.',
      );
    }
    return model as HappinessReportModel;
  }

  @override

  /// Returns a [Future] that completes with a [HappinessReportModel] value indicating whether the update operation was successful or not.
  ///
  /// The [happinessReport] parameter should be a [HappinessReportModel] object that contains the updated properties.
  Future<HappinessReportModel> update(
    HappinessReportModel happinessReport,
  ) async {
    final model = await _datasource.update(_modelName, happinessReport);

    if (model.runtimeType != HappinessReportModel ||
        model.id != happinessReport.id) {
      throw RepositoryException(
        'The datasource connector failed to update the given model instance, so an EmptyModel was returned.',
      );
    }
    return model as HappinessReportModel;
  }

  @override

  /// Returns a [Future] that completes with a [bool] value indicating whether the delete operation was successful or not.
  ///
  /// The [id] parameter should be an [int] representing the ID of the [HappinessReportModel] object that needs to be deleted.
  Future<bool> delete(int id) async {
    final isSuccess = await _datasource.delete(_modelName, id);
    if (!isSuccess) {
      throw RepositoryException(
        'The datasource connector failed to update the given model instance, so an EmptyModel was returned.',
      );
    }
    return isSuccess;
  }

  @override

  /// Returns a [Future] that completes with a [List] of all daily [HappinessReportModel] objects,
  /// created by employees which are team members of the current user.
  Future<List<HappinessReportModel>> getTeamDailyReports() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', true],
        ['x_employee_id.parent_id.id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  @override
  /// Returns a [Future] that completes with a [List] of all weekly [HappinessReportModel] objects.
  /// created by employees which are team members of the current user.
  Future<List<HappinessReportModel>> getTeamWeeklyReports() async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', false],
        ['x_employee_id.parent_id.id', '=', userDetails.currentEmployeeId],
      ],
      order: 'x_date desc',
    );
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    var reports = jsonList.map((e) => e as HappinessReportModel).toList();
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return reports;
  }

  @override
  /// Returns a [Future] that completes with a daily [HappinessReportModel] object,
  /// created by the current user for a date.
  Future<HappinessReportModel?> getReportByDate(String date, bool isDaily) async {
    final jsonList = await _datasource.fetchAll(
      _modelName,
      domain: [
        ['x_is_daily_report', '=', isDaily],
        ['x_date', '=', date],
      ],
      order: 'x_date desc',
    );
    print(jsonList);
    jsonList
        .removeWhere((element) => element.runtimeType != HappinessReportModel);
    return jsonList.isEmpty ? null : jsonList.map((e) => e as HappinessReportModel).toList().first;
  }

  @override
  /// Returns a [Future] that completes with a weekly [HappinessReportModel] object,
  /// created by the current user for a week number.
  Future<HappinessReportModel?> getReportByWeekNumber(int weekNumber, int year) async {
    // Define the start of the year
    DateTime startDate = DateTime(year, 1, 4); // 4th Jan is guaranteed to be in week 1 according to ISO 8601

    // If the start date isn't a Monday, move to the previous Monday
    while (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    // Define the week's range
    DateTime weekStartDate = startDate.add(Duration(days: (weekNumber - 1) * 7));
    List<DateTime> weekDates = List.generate(7, (index) => weekStartDate.add(Duration(days: index)));

    // Fetch report for each date in the week's range
    for (DateTime date in weekDates) {
      String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      HappinessReportModel? report = await getReportByDate(dateString, false);
      if (report != null) {
        return report;
      }
    }

    // If no report was found for the week, return null
    return null;
  }

}
