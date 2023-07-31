// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';


void main() {
  group('userDetailsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('UserDetailsState constructor should set fields correctly', () {
      const userId = 1;
      const employeeId = 1001;
      const departmentId = 101;
      const isManager = true;
      final state = UserDetailsState(userId, employeeId, departmentId, isManager);

      expect(state.currentUserId, equals(userId));
      expect(state.currentEmployeeId, equals(employeeId));
      expect(state.currentDepartmentId, equals(departmentId));
      expect(state.currentIsManager, equals(isManager));
    });

    test('should provide a UserDetailsState object', () {
      final state = container.read(userDetailsStateProvider);
      expect(state, isA<UserDetailsState>());
    });

    test('should update the state when userDetails is changed', () {
      const newUserId = 0;
      const newEmployeeId = 0;
      const newDepartmentId = 0;
      const newIsManager = false;

      container.listen(
        userDetailsStateProvider,
            (state, newState) {
          expect(newState.currentUserId, equals(newUserId));
          expect(newState.currentEmployeeId, equals(newEmployeeId));
          expect(newState.currentDepartmentId, equals(newDepartmentId));
          expect(newState.currentIsManager, equals(newIsManager));
        },
        fireImmediately: true,
      );

      container
          .read(userDetailsStateProvider.notifier)
          .update((state) => UserDetailsState(
          newUserId, newEmployeeId, newDepartmentId, newIsManager));
    });

    test(
        'UserDetailsState toString should return correct string representation',
            () {
          const userId = 1;
          const employeeId = 1001;
          const departmentId = 101;
          const isManager = true;
          final state =
          UserDetailsState(userId, employeeId, departmentId, isManager);

          expect(
            state.toString(),
            'UserDetailsState{currentUserId: $userId, currentEmployeeId: $employeeId, currentDepartmentId: $departmentId, currentIsManager: $isManager}',
          );
        });
  });
}

