// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

/// UserDetailsState object is a holder of the user details,
/// which are shared among multiple pages and widgets.
/// It is used in combination with the Riverpod package
/// to allow widgets to look up the app state
/// object in the widget tree and to access it when needed.
class UserDetailsState {
  UserDetailsState(this.currentUserId, this.currentEmployeeId,
      this.currentDepartmentId, this.currentIsManager);

  // current user id
  final int currentUserId;
  final int currentEmployeeId;
  final int currentDepartmentId;
  final bool currentIsManager;

  @override
  String toString() {
    return 'UserDetailsState{currentUserId: $currentUserId,'
        ' currentEmployeeId: $currentEmployeeId,'
        ' currentDepartmentId: $currentDepartmentId,'
        ' currentIsManager: $currentIsManager}';
  }
}
