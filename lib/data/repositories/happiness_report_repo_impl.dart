// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'dart:math';

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

  bool hasNewWriteDaily = true;
  bool hasNewWriteWeekly = true;
  List<HappinessReportModel> dailyReportCache = [];
  List<HappinessReportModel> weeklyReportCache = [];

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

    hasNewWriteDaily = false;
    dailyReportCache = jsonList.map((e) => e as HappinessReportModel).toList();
    dailyReportCache.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return dailyReportCache;
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

    hasNewWriteWeekly = false;
    weeklyReportCache = jsonList.map((e) => e as HappinessReportModel).toList();
    weeklyReportCache.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));
    return weeklyReportCache;
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

    if (happinessReport.isDailyReport) {
      hasNewWriteDaily = true;
    } else {
      hasNewWriteWeekly = true;
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

    if (happinessReport.isDailyReport) {
      hasNewWriteDaily = true;
    } else {
      hasNewWriteWeekly = true;
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

  /// Returns a [Future] that completes with an [int] value indicating
  /// the number of consecutive days the user has completed a daily report.
  /// The [today] parameter should be a [DateTime] object representing the current date.
  @override
  Future<int> getDailyStreak(DateTime today) async {
    var reportList = hasNewWriteDaily ? (await getAllDailyReports()) : dailyReportCache
      ..sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));

    var streak = 0;
    var currentDateWithoutTime = DateTime(today.year, today.month, today.day);

    var index = 0;

    // Start an infinite loop that breaks when no reports are left or when streak is broken
    while (true) {

      if(index >= reportList.length) {
        return streak;
      }

      // Fetching daily reports with given limit and offset
      final reports = [reportList[index]];

      // If no reports were found, end streak calculation and return the current streak count
      if (reports.isEmpty) {
        return streak;
      }

      // Extracting the first (and only) report from the fetched list
      var report = reports.first;

      // Parsing the report's date
      var reportDate = Helper.formatter.parse(report.date);

      // If the report's date matches the current date being considered, increment streak count and move to the previous day
      if (currentDateWithoutTime == reportDate) {
        streak++;
        index++;
        currentDateWithoutTime = currentDateWithoutTime.subtract(Duration(days: 1));
      }
      // If the current date is a weekend or it is today's date, don't break the streak and simply move to the previous day
      else if (currentDateWithoutTime.weekday == DateTime.saturday ||
          currentDateWithoutTime.weekday == DateTime.sunday ||
          currentDateWithoutTime == DateTime(today.year, today.month, today.day)) {
        currentDateWithoutTime = currentDateWithoutTime.subtract(Duration(days: 1));
      }
      // If the report's date does not match the current date, and the date is not a weekend or today, break the streak and return current streak count
      else {
        return streak;
      }
    }
  }


  /// Returns a [Future] that completes with an [int] value indicating the number of consecutive weeks the user has completed a weekly report.
  /// The [today] parameter should be a [DateTime] object representing the current date.
  @override
  Future<int> getWeeklyStreak(DateTime today) async {
    var reportList = hasNewWriteWeekly ? (await getAllWeeklyReports()) : weeklyReportCache
      ..sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));

    var streak = 0;  // Initial streak count is 0.
    var currentDate = DateTime(today.year, today.month, today.day);  // Get the current date.
    var currentWeek = Helper.getWeekNumber(currentDate);  // Get the current week number.

    var index = 0;

    // Infinite loop until streak is broken or no more reports.
    while (true) {
      if(index >= reportList.length) {
        return streak;
      }

      // Fetch a batch of reports.
      final reports = [reportList[index]];

      if (reports.isEmpty) {
        // No more reports left, break the loop.
        return streak;
      }

      // Get the first (and only) report from the fetched list
      var report = reports.first;

      var reportWeek = Helper.getWeekNumber(Helper.formatter.parse(report.date));  // Get the report's week number.

      // If the current week matches the report week, increment the streak and move to the previous week.
      if (reportWeek == currentWeek) {
        streak++;
        currentDate = currentDate.subtract(Duration(days: 7));
        currentWeek = Helper.getWeekNumber(currentDate);
        index++;
      }
      // If current week report is still not filled, don't break the streak until the week has completely passed
      else if (currentWeek == Helper.getWeekNumber(DateTime.now())) {
        currentDate = currentDate.subtract(Duration(days: 7));
        currentWeek = Helper.getWeekNumber(currentDate);
      }
      // If the current week does not match the report week, streak is broken. Return the streak count.
      else {
        return streak;
      }
    }
  }

  /// Returns a [Future] that completes with an [int] value indicating the longest number of consecutive days the user has completed a daily report.
  @override
  Future<int> getLongestDailyStreak() async {
    var longestStreak = 0;
    var currentStreak = 0;
    DateTime? previousReportDate;

    // Ensure reports are ordered in ascending order of date
    var reports = hasNewWriteDaily ? (await getAllDailyReports()) : dailyReportCache
      ..sort((a, b) => Helper.formatter.parse(a.date).compareTo(Helper.formatter.parse(b.date)));

    for (var report in reports) {
      var reportDate = Helper.formatter.parse(report.date);
      var reportDateWithoutTime = DateTime(reportDate.year, reportDate.month, reportDate.day);

      if (previousReportDate != null) {
        var diff = reportDateWithoutTime.difference(previousReportDate).inDays;

        if (diff == 1) {
          currentStreak++;
        } else if (diff <= 3 && previousReportDate.weekday == DateTime.friday && reportDateWithoutTime.weekday != DateTime.saturday) {
          // The streak continues if a report was made on Friday and the next one is on Monday (diff = 3), or Sunday (diff = 2)
          currentStreak++;
        } else if (diff == 2 && previousReportDate.weekday != DateTime.friday && reportDateWithoutTime.weekday == DateTime.monday) {
          // Edge case: the streak continues if a report was made on any weekday, then skipped on weekend and the next one is on Monday (diff = 2)
          currentStreak++;
        } else {
          longestStreak = max(longestStreak, currentStreak);  // Update longest streak before resetting
          currentStreak = 1;  // Reset streak but count the current report as start of a new streak
        }
      } else {
        currentStreak = 1; // If this is the first report, start the streak count at 1
      }

      previousReportDate = reportDateWithoutTime;
    }

    // In case the longest streak is still ongoing when the loop ends, update longestStreak one last time
    longestStreak = max(longestStreak, currentStreak);

    return longestStreak;
  }


  /// Returns a [Future] that completes with an [int] value indicating the longest
  /// number of consecutive weeks the user has completed a weekly report.
  @override
  Future<int> getLongestWeeklyStreak() async {
    var longestStreak = 0;
    var tempStreak = 0;
    int? currentWeek;

    var reports = hasNewWriteWeekly ? (await getAllWeeklyReports()) : weeklyReportCache;

    // Sort reports by date in descending order (latest first)
    reports.sort((a, b) => Helper.formatter.parse(b.date).compareTo(Helper.formatter.parse(a.date)));

    for (var report in reports) {
      var reportWeek = Helper.getWeekNumber(Helper.formatter.parse(report.date));

      // Check if it's the next week
      if (currentWeek != null && reportWeek == currentWeek - 1) {
        tempStreak++;
      } else {
        // Reset the streak count if it's not the next week
        tempStreak = 1;
      }

      // Update the longest streak
      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }

      currentWeek = reportWeek;
    }

    return longestStreak;
  }

  /// Returns a [Future] that completes with an [int] value indicating the
  /// number of days the user has completed a daily report in the current week.
  @override
  Future<int> getCurrentWeekDailyStreak(DateTime today) async {
    var reports = hasNewWriteDaily ? (await getAllDailyReports()) : dailyReportCache;
    return reports.where((element) => Helper.getWeekNumber(Helper.formatter.parse(element.date)) == Helper.getWeekNumber(today)).length;
  }

  /// Returns a [Future] that completes with an [int] value indicating the
  /// number of weeks the user has completed a weekly report in the current month.
  @override
  Future<int> getCurrentMonthWeeklyStreak(DateTime today) async {
    var reports = hasNewWriteWeekly ? (await getAllWeeklyReports()) : weeklyReportCache;
    return reports.where((element) => Helper.formatter.parse(element.date).month == today.month).length;
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
