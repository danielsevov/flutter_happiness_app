// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/domain/repositories/user_repo.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';

class UserRepositoryImplementation implements UserRepository {
  UserRepositoryImplementation(this._datasource, this._modelName, this.userDetails);
  final UserDetailsState userDetails;
  final Datasource _datasource;
  final String _modelName;

  @override

  /// Returns a [Future] that completes with a [List] of [UserModel] objects.
  Future<List<UserModel>> getTeamMembers({int? userId}) async {
    if (!userDetails
        .currentIsManager) return [];
    final jsonList = await _datasource.fetchAll(
      _modelName,
      fields: ['id', 'name', 'parent_id'],
      domain: [
        [
          'parent_id.id',
          '=',
          userDetails
              .currentEmployeeId
        ],
      ],
    );
    jsonList.removeWhere((element) => element.runtimeType != UserModel);
    return jsonList.map((e) => e as UserModel).toList();
  }

  @override

  /// Returns a [Future] that completes with a [UserModel] object that has the specified [employeeId].
  Future<UserModel> get(int employeeId) async {
    final model = await _datasource.fetch(
      _modelName,
      employeeId,
      fields: ['id', 'name', 'parent_id'],
    );
    if (model.runtimeType != UserModel || model.id != employeeId) {
      throw RepositoryException(
        'The datasource connector failed to read the given model instance, so an EmptyModel was returned.',
      );
    }
    return model as UserModel;
  }
}
