// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_positional_boolean_parameters

import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';

/// API to the ManagerDashboardPageView page view widget.
/// Describes the methods of the page view implementation.
abstract class ManagerDashboardPageView {
  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress);

  /// Function to notify there were no happiness reports found.
  void notifyNoReportsFound();

  /// Function to notify there was a problem fetching the happiness reports.
  void notifyFetchFailed();

  /// Function to notify that all reports have been fetched and can be displayed.
  void notifyDataFetched(List<HappinessReport> reportWidgets, List<UserModel> team, List<HappinessReport> mergedList);
}
