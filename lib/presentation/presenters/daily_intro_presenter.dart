// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_setters_to_change_properties

import 'dart:developer';

import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/base_presenter.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/views/pages/daily_intro_page_view.dart';
import 'package:intl/intl.dart';

class DailyIntrospectionPresenter extends BasePresenter {
  /// Simple constructor
  DailyIntrospectionPresenter(
    this.userDetails,
  );
  DailyIntrospectionPageView? _view;
  final UserDetailsState userDetails;

  late final HappinessReportRepository _happinessReportRepository;
  HappinessReportModel? todaysReport;

  /// Function to attach repositories
  void attachRepositories(
    HappinessReportRepository happinessReportRepository,
  ) {
    _happinessReportRepository = happinessReportRepository;
    super.repositoriesAttached = true;
  }

  /// Function to attach a view to the presenter
  void attach(DailyIntrospectionPageView view) {
    _view = view;
  }

  /// Function to detach the view from the presenter
  void detach() {
    _view = null;
  }

  /// Function to fetch the report for today if there is one already
  Future<void> fetchReport(String date) async {
    todaysReport = null;

    _view!.setInProgress(true);

      todaysReport = (await _happinessReportRepository.getReportByDate(date, true));
      if(todaysReport != null) {
        _view!.notifyReportFetched(todaysReport!);
      }

    _view!.setInProgress(false);
  }

  /// Function used for saving the changes made to the daily introspection report.
  Future<void> saveChanges(
    double happinessLevel,
    double sadnessLevel,
    double angerLevel,
    double fearLevel,
    String? accomplishments,
    String? contributions,
    String? insight,
      String date,
  ) async {
    _view?.setInProgress(true);

    if (todaysReport == null) {
      // prepare the report
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: happinessLevel,
        sadnessLevel: sadnessLevel,
        angerLevel: angerLevel,
        fearLevel: fearLevel,
        careForSelf: accomplishments,
        careForOthers: contributions,
        insight: insight,
        date: Helper.formatter.format(DateFormat('yyyy-MM-dd').parse(date)),
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
        log('DailyIntroPresenter SaveChanges: $e');
        _view?.notifyNotSaved();
      }
    } else {
      // prepare the report
      todaysReport?.happinessLevel = happinessLevel;
      todaysReport?.sadnessLevel = sadnessLevel;
      todaysReport?.fearLevel = fearLevel;
      todaysReport?.angerLevel = angerLevel;

      todaysReport?.insight = insight;
      todaysReport?.careForOthers = contributions;
      todaysReport?.careForSelf = accomplishments;

      // try persisting the report to the datasource
      try {
        await _happinessReportRepository.update(todaysReport!);

        // if successful notify the view
        _view?.notifySaved();
      }
      // if fails notify the view
      catch (e) {
        log('DailyIntroPresenter SaveChanges: $e');
        _view?.notifyNotSaved();
      }
    }

    _view?.setInProgress(false);
  }
}
