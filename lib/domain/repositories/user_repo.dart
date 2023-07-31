// ignore_for_file: lines_longer_than_80_chars

import 'package:happiness_app/domain/models/user_model.dart';

/// This is an abstract class that defines the contract for any [UserModel] repository.
/// Only reading is allowed as we don't want to change the already existing user data.
abstract class UserRepository {
  /// Returns a [Future] that completes with a [List] of [UserModel] objects.
  Future<List<UserModel>> getTeamMembers();

  /// Returns a [Future] that completes with a [UserModel] object that has the specified [employeeId].
  Future<UserModel> get(int employeeId);
}
