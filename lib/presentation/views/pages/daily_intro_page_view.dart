// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_positional_boolean_parameters

import 'package:happiness_app/domain/models/happiness_report_model.dart';

/// API to the DailyIntrospection page view widget.
/// Describes the methods of the page view implementation.
abstract class DailyIntrospectionPageView {
  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress);

  /// Function to notify there was a problem saving the report.
  void notifyNotSaved();

  /// Function to notify the template is saved
  void notifySaved();

  /// Function to notify that today's report has been fetched
  void notifyReportFetched(HappinessReportModel todaysReport);
}
