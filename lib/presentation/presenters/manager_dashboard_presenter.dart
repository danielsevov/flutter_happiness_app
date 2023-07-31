// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_setters_to_change_properties

import 'dart:developer';

import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/domain/repositories/user_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/base_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/views/pages/manager_dashboard_page_view.dart';

class ManagerDashboardPresenter extends BasePresenter {

  /// Simple constructor
  ManagerDashboardPresenter();
  ManagerDashboardPageView? _view;
  List<HappinessReportModel> _reportList = [];

  late final HappinessReportRepository happinessReportRepository;
  late final UserRepository userRepository;
  late HappinessSettingsModel settings;

  /// Function to attach repositories
  void attachRepositories(
      HappinessReportRepository reportRepository, UserRepository userRepo,) {
    happinessReportRepository = reportRepository;
    userRepository = userRepo;
    super.repositoriesAttached = true;
  }

  /// Function to attach a view to the presenter
  void attach(ManagerDashboardPageView view) {
    _view = view;
  }

  /// Function to detach the view from the presenter
  void detach() {
    _view = null;
  }

  /// Function used to fetch the list of reports and list of users,
  /// which are needed by the view to visualize the team happiness data
  Future<void> fetchData({required bool fetchDaily}) async {
    _view?.setInProgress(true);

    final team = await userRepository.getTeamMembers();
    team.sort((a, b) => a.name!.compareTo(b.name!));

    try {
      if (fetchDaily) {
        _reportList = await happinessReportRepository.getTeamDailyReports();

        if (_reportList.isNotEmpty) {

          // Sort reports by their date in descending order
          _reportList.sort((a, b) {
            final dateA = Helper.formatter.parse(a.date);
            final dateB = Helper.formatter.parse(b.date);
            return dateB.compareTo(dateA);
          });

          // Group reports by employee ID
          final reportsByEmployee = <int, List<HappinessReportModel>>{};
          for (final report in _reportList) {
            if (reportsByEmployee.containsKey(report.employeeId)) {
              reportsByEmployee[report.employeeId]!.add(report);
            } else {
              reportsByEmployee[report.employeeId] = [report];
            }
          }

          // Create a list of HappinessReport widgets for each employee with ranking
          final reportWidgetList = <HappinessReport>[];
          reportsByEmployee.forEach((employeeId, reports) {
            reportWidgetList.addAll(reports
                .mapIndexed((index, report) => HappinessReport(
              report: report,
              rank: index + 1,
            ),)
                .toList(),);
          });

          // Merge reports with the same date into a single HappinessReport instance
          final mergedList = mergeReportsByDate(reportWidgetList);

          var idList = reportWidgetList.map((e) => e.report.employeeId).toList();
          team.removeWhere((element) => !idList.contains(element.id));

          _view?.notifyDataFetched(reportWidgetList, team, mergedList);
        } else {
          _view?.notifyNoReportsFound();
        }
      } else {
        _reportList = await happinessReportRepository.getTeamWeeklyReports();

        // Sort reports by their date in descending order
        _reportList.sort((a, b) {
          final dateA = Helper.formatter.parse(a.date);
          final dateB = Helper.formatter.parse(b.date);
          return dateB.compareTo(dateA);
        });

        // Group reports by employee ID
        if (_reportList.isNotEmpty) {
          final reportsByEmployee = <int, List<HappinessReportModel>>{};
          for (final report in _reportList) {
            if (reportsByEmployee.containsKey(report.employeeId)) {
              reportsByEmployee[report.employeeId]!.add(report);
            } else {
              reportsByEmployee[report.employeeId] = [report];
            }
          }

          // Create a list of HappinessReport widgets for each employee with ranking
          final reportWidgetList = <HappinessReport>[];
          reportsByEmployee.forEach((employeeId, reports) {
            reportWidgetList.addAll(reports
                .mapIndexed((index, report) => HappinessReport(
              report: report,
              rank: index + 1,
            ),)
                .toList(),);
          });

          // Merge reports with the same date into a single HappinessReport instance
          final mergedList = mergeReportsByDate(reportWidgetList);

          var idList = reportWidgetList.map((e) => e.report.employeeId).toList();
          team.removeWhere((element) => !idList.contains(element.id));

          _view?.notifyDataFetched(reportWidgetList, team, mergedList);
        } else {
          _view?.notifyNoReportsFound();
        }
      }
    } catch (e) {
      log('ManagerDashboardPresenter FetchReports: $e');
      _view?.notifyFetchFailed();
    }

    _view?.setInProgress(false);
  }

  /// Function used for merging all reports in a list
  /// with the same date into single report instance
  List<HappinessReport> mergeReportsByDate(List<HappinessReport> reports) {
    final reportsByDate = <String, List<HappinessReport>>{};

    for (final report in reports) {
      if (reportsByDate.containsKey(report.report.date)) {
        reportsByDate[report.report.date]!.add(report);
      } else {
        reportsByDate[report.report.date] = [report];
      }
    }

    final mergedReports = <HappinessReport>[];

    reportsByDate.forEach((date, reportsForDate) {
      final count = reportsForDate.length;
      var totalHappiness = 0;
      var totalSadness = 0;
      var totalAnger = 0;
      var totalFear = 0;

      for (final report in reportsForDate) {
        totalHappiness += report.report.happinessLevel.toInt();
        totalSadness += report.report.sadnessLevel.toInt();
        totalAnger += report.report.angerLevel.toInt();
        totalFear += report.report.fearLevel.toInt();
      }

      final mergedReport = HappinessReport(report: HappinessReportModel.empty(
        happinessLevel: totalHappiness / count,
        sadnessLevel: totalSadness / count,
        angerLevel: totalAnger / count,
        fearLevel: totalFear / count,
        date: date,
      ), rank: 0,);

      mergedReports.add(mergedReport);
    });

    return mergedReports;
  }
}

extension ListExtension<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E element) f) {
    return asMap().entries.map((entry) => f(entry.key, entry.value)).toList();
  }
}
