// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_positional_boolean_parameters
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';

/// API to the DailyIntrospectionHistory page view widget.
/// Describes the methods of the page view implementation.
abstract class DailyIntrospectionHistoryPageView {
  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress);

  /// Function to notify there were no daily introspection reports found.
  void notifyNoReportsFound();

  /// Function to notify there was a problem fetching the daily introspection reports.
  void notifyFetchFailed(String errorMessage);

  /// Function to notify that all daily reports have been fetched and can be displayed.
  void notifyReportsFetched(List<HappinessReport> reportWidgets, bool hasMoreReports);
}
