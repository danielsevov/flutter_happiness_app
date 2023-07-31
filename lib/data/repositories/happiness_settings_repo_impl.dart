// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';

class HappinessSettingsRepositoryImplementation
    implements HappinessSettingsRepository {
  HappinessSettingsRepositoryImplementation(
      this._datasource, this._modelName, this.userDetails,);
  final UserDetailsState userDetails;
  final Datasource _datasource;
  final String _modelName;

  @override

  /// Returns a [Future] that completes with a [HappinessSettingsModel] value indicating whether the update operation was successful or not.
  ///
  /// The [notificationsSettings] parameter should be a [HappinessSettingsModel] object that contains the updated properties.
  Future<HappinessSettingsModel> update(
    HappinessSettingsModel notificationsSettings,
  ) async {
    final model = await _datasource.update(_modelName, notificationsSettings);
    if (model.runtimeType != HappinessSettingsModel ||
        model.id != notificationsSettings.id) {
      throw RepositoryException(
        'The datasource connector failed to update the given model instance, so an EmptyModel was returned.',
      );
    }
    return model as HappinessSettingsModel;
  }

  @override

  /// Returns a [Future] that completes with a [HappinessSettingsModel] object that has the specified [employeeId].
  Future<HappinessSettingsModel> getForEmployee(int employeeId) async {
    final jsonList = await _datasource.fetchAll(_modelName, domain: [
      ['x_employee_id', '=', employeeId]
    ],);
    jsonList.removeWhere(
        (element) => element.runtimeType != HappinessSettingsModel,);
    final list = jsonList.map((e) => e as HappinessSettingsModel).toList();

    if (list.isEmpty) {
      throw RepositoryException(
        'The datasource connector failed to fetch the given model instance, so an EmptyModel was returned.',
      );
    }

    return list[0];
  }

  /// Returns a [Future] that completes with a [HappinessSettingsModel] object that has the specified [id].
  Future<HappinessSettingsModel> get(int id) async {
    final model = await _datasource.fetch(_modelName, id);
    if (model.runtimeType != HappinessSettingsModel || model.id != id) {
      final newModel = await _datasource.create(
        _modelName,
        HappinessSettingsModel.newSettings(
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
          employeeId: userDetails.currentEmployeeId,
          canShare: false,
          locale: 'en',
          timeOfTheDay: '16:00',
          weeklyReviewDayOfWeek: Day.friday,
        ),
      );

      if (newModel.runtimeType != HappinessSettingsModel) {
        throw RepositoryException(
          'The datasource connector failed to persist the given model instance, so an EmptyModel was returned.',
        );
      }
      return newModel as HappinessSettingsModel;
    }
    return model as HappinessSettingsModel;
  }

  @override

  /// Returns a [Future] that completes with a [HappinessSettingsModel] object, owned by the current user.
  Future<HappinessSettingsModel> getMySettings() async {
    final jsonList = await _datasource.fetchAll(_modelName, domain: [
      ['x_employee_id', '=', userDetails.currentEmployeeId]
    ],);

    jsonList.removeWhere(
        (element) => element.runtimeType != HappinessSettingsModel,);
    final list = jsonList.map((e) => e as HappinessSettingsModel).toList();

    if (list.isEmpty) {
      final newModel = await _datasource.create(
        _modelName,
        HappinessSettingsModel.newSettings(
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
          employeeId: userDetails.currentEmployeeId,
          canShare: false,
          locale: 'en',
          timeOfTheDay: '16:00',
          weeklyReviewDayOfWeek: Day.friday,
        ),
      );

      if (newModel.runtimeType != HappinessSettingsModel) {
        throw RepositoryException(
          'The datasource connector failed to persist the given model instance, so an EmptyModel was returned.',
        );
      }
      return newModel as HappinessSettingsModel;
    }

    return list[0];
  }
}
