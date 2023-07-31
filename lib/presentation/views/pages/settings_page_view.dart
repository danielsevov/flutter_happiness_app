// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_positional_boolean_parameters

import 'package:happiness_app/domain/models/happiness_settings_model.dart';

/// API to the SettingsPageView page view widget.
/// Describes the methods of the page view implementation.
abstract class SettingsPageView {
  /// Function to notify the user that settings have been fetched.
  void notifySettingsImported(HappinessSettingsModel settings);

  /// Function to notify the user that settings could not be fetched.
  void notifySettingsNotFetched();

  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress);
}
