// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:happiness_app/domain/models/happiness_settings_model.dart';

/// This is an abstract class that defines the contract for any [HappinessSettingsModel] repository.
/// The repository provides Create, Update, Read functionality, but leaves out the Delete as settings
/// should not be deleted but rather updated based on the user preferences.
abstract class HappinessSettingsRepository {
  /// Returns a [Future] that completes with a [HappinessSettingsModel] object that has the specified [employeeId].
  Future <HappinessSettingsModel> getForEmployee(int employeeId);

  /// Returns a [Future] that completes with a [HappinessSettingsModel] object, owned by the current user.
  Future <HappinessSettingsModel> getMySettings();

  /// Returns a [Future] that completes with a [HappinessSettingsModel] value indicating whether the update operation was successful or not.
  ///
  /// The [dailyIntrospection] parameter should be a [HappinessSettingsModel] object that contains the updated properties.
  Future<HappinessSettingsModel> update(HappinessSettingsModel dailyIntrospection);
}
