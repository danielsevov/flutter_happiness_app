// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_setters_to_change_properties

import 'dart:developer';

import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/base_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/views/pages/daily_history_page_view.dart';

class DailyIntrospectionHistoryPresenter extends BasePresenter {

  /// Simple constructor
  DailyIntrospectionHistoryPresenter();
  DailyIntrospectionHistoryPageView? _view;
  List<HappinessReportModel> _reportList = [];

  late final HappinessReportRepository _happinessReportRepository;
  late HappinessSettingsModel settings;

  /// Function to attach repositories
  void attachRepositories(
      HappinessReportRepository happinessReportRepository,) {
    _happinessReportRepository = happinessReportRepository;
    super.repositoriesAttached = true;
  }

  /// Function to attach a view to the presenter
  void attach(DailyIntrospectionHistoryPageView view) {
    _view = view;
  }

  /// Function to detach the view from the presenter
  void detach() {
    _view = null;
  }

  /// Function used for fetching all daily introspection reports.
  Future<void> fetchReports({int? pageLimit, int? currentPageIndex, required bool fetchDaily}) async {
    _view?.setInProgress(true);

    // try fetching all reports
    try {
      //await _happinessReportRepository.delete(67);

      bool hasMoreReports = false;
      if(fetchDaily) {
        if(pageLimit != null && pageLimit > 0) {
          _reportList = await _happinessReportRepository.getDailyReports(pageLimit + 1, pageLimit * (currentPageIndex ?? 0));
          if(_reportList.length > pageLimit) {
            _reportList.removeLast();
            hasMoreReports = true;
          }
        }
        else {
          _reportList = await _happinessReportRepository.getAllDailyReports();
          print(_reportList);
        }

        print(_reportList);

        // if there are reports, create report widgets from them
        if(_reportList.isNotEmpty) {
          final dailyIntrospectionWidgetList = _reportList
              .mapIndexed((index, report) => HappinessReport(report: report, rank: index + 1 + (pageLimit ?? 0) * (currentPageIndex ?? 0),))
              .toList();

          _reportList.sort((a, b) {
            final dateA = Helper.formatter.parse(a.date);
            final dateB = Helper.formatter.parse(b.date);
            return dateA.compareTo(dateB);
          });

          // pass the report widgets to the view
          _view?.notifyReportsFetched(dailyIntrospectionWidgetList.toList(), hasMoreReports);
        }
        // if report list is empty notify the view
        else {
          _view?.notifyNoReportsFound();
        }
      }
      else {
        if(pageLimit != null && pageLimit > 0) {
          _reportList = await _happinessReportRepository.getWeeklyReports(pageLimit + 1, pageLimit * (currentPageIndex ?? 0));
          if(_reportList.length > pageLimit) {
            _reportList.removeLast();
            hasMoreReports = true;
          }
        }
        else {
          _reportList = await _happinessReportRepository.getAllWeeklyReports();
        }

        // if there are reports, create report widgets from them
        if(_reportList.isNotEmpty) {
          final dailyIntrospectionWidgetList = _reportList
              .mapIndexed((index, report) => HappinessReport(report: report, rank: index + 1 + (pageLimit ?? 0) * (currentPageIndex ?? 0),))
              .toList();

          _reportList.sort((a, b) {
            final dateA = Helper.formatter.parse(a.date);
            final dateB = Helper.formatter.parse(b.date);
            return dateA.compareTo(dateB);
          });

          // pass the report widgets to the view
          _view?.notifyReportsFetched(dailyIntrospectionWidgetList.toList(), hasMoreReports);
        }
        // if report list is empty notify the view
        else {
          _view?.notifyNoReportsFound();
        }
      }

    }
    // if fetch failed notify the view
    catch (e) {
      log('DailyHistoryPresenter FetchReports: $e');
      _view?.notifyFetchFailed(e.toString());
    }

    _view?.setInProgress(false);
  }
}

extension ListExtension<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E element) f) {
    return asMap().entries.map((entry) => f(entry.key, entry.value)).toList();
  }
}
