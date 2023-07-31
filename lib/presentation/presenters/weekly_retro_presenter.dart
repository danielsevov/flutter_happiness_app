// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_setters_to_change_properties

import 'dart:developer';

import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/base_presenter.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/views/pages/weekly_retro_page_view.dart';

class WeeklyRetrospectionPresenter extends BasePresenter {
  /// Simple constructor
  WeeklyRetrospectionPresenter(
    this.userDetails,
  );

  final UserDetailsState userDetails;
  WeeklyRetrospectionPageView? _view;

  late final HappinessReportRepository _happinessReportRepository;
  HappinessReportModel? currentWeekReport;

  /// Function to attach repositories
  void attachRepositories(
    HappinessReportRepository happinessReportRepository,
  ) {
    _happinessReportRepository = happinessReportRepository;
    super.repositoriesAttached = true;
  }

  /// Function to attach a view to the presenter
  void attach(WeeklyRetrospectionPageView view) {
    _view = view;
  }

  /// Function to detach the view from the presenter
  void detach() {
    _view = null;
  }

  /// Function to fetch the report for today if there is one already
  Future<void> fetchReport(int weekNumber, int year) async {
    _view!.setInProgress(true);

    currentWeekReport = (await _happinessReportRepository.getReportByWeekNumber(weekNumber, year));

    if(currentWeekReport != null) {
      _view!.notifyReportFetched(currentWeekReport!);
    }

    _view!.setInProgress(false);
  }

  /// Function used for saving the changes made to the Weekly Retrospection report.
  Future<void> saveChanges(
    int weeklyRating,
    String? feedback,
    String? insight,
      int weekNumber,
      int year,
  ) async {
    _view?.setInProgress(true);

    if (currentWeekReport == null) {
      // prepare the report
      final report = HappinessReportModel.newWeeklyReport(
        happinessLevel: weeklyRating.toDouble(),
        careForSelf: feedback,
        date: Helper.formatter.format(Helper.getMondayOfTheWeekByNumber(weekNumber, year)),
        insight: insight,
        employeeId: userDetails
            .currentEmployeeId,
      );

      // try persisting the report to the datasource
      try {
        await _happinessReportRepository.create(report);

        // if successful notify the view
        _view?.notifySaved();
      }
      // if fails notify the view
      catch (e) {
        log('WeeklyRetrospectionPresenter SaveChanges: $e');
        _view?.notifyNotSaved();
      }
    } else {
      // prepare the report
      currentWeekReport?.happinessLevel = weeklyRating.toDouble();
      currentWeekReport?.careForSelf = feedback;
      currentWeekReport?.insight = insight;

      // try persisting the report to the datasource
      try {
        await _happinessReportRepository.update(currentWeekReport!);

        // if successful notify the view
        _view?.notifySaved();
      }
      // if fails notify the view
      catch (e) {
        log('WeeklyRetrospectionPresenter SaveChanges: $e');
        _view?.notifyNotSaved();
      }
    }

    _view?.setInProgress(false);
  }
}
