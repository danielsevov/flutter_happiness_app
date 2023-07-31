// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/exceptions/repo_exception.dart';
import 'package:happiness_app/data/repositories/user_repo_impl.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/domain/repositories/user_repo.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'user_repo_test.mocks.dart';

@GenerateMocks([Datasource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final datasource = MockDatasource();
  var userDetails = UserDetailsState(0, 0, 0, false);

  setUpAll(() {
    userDetails = UserDetailsState(0, 0, 0, false);
  });


  test('UserRepositoryImplementation constructor test', () async {
    final UserRepository repo =
        UserRepositoryImplementation(datasource, 'res.users', userDetails);
    expect(repo.runtimeType, UserRepositoryImplementation);
  });

  group('UserRepositoryImplementation Get & GetAll tests', () {
    /// Get tests

    test('Get non-existent model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(datasource.fetch(any, any, fields: anyNamed('fields')))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get wrong type model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(datasource.fetch(any, any, fields: anyNamed('fields')))
          .thenAnswer((realInvocation) async => TestModel());

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get wrong id model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(datasource.fetch(any, any, fields: anyNamed('fields')))
          .thenAnswer((realInvocation) async => EmptyModel());

      expect(
        () async => repo.get(1),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('Get right id model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);
      final instance = UserModel.fromJson(
        {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
      );
      instance.setNewId(1);

      when(datasource.fetch(any, any, fields: anyNamed('fields')))
          .thenAnswer((realInvocation) async => instance);

      expect(
        () async => repo.get(1),
        returnsNormally,
      );
    });

    test('Get right id partial model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);
      final instance = UserModel.fromJson(
        {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
      );
      instance.setNewId(1);

      when(datasource.fetch(any, any, fields: anyNamed('fields')))
          .thenAnswer((realInvocation) async => instance);

      final createdInstance = await repo.get(1);
      expect(createdInstance.name, 'Test User');
    });

    /// GetAll tests

    test('GetAll non-existent model instance', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer((realInvocation) async => []);

      expect(await repo.getTeamMembers(), <UserModel>[]);
    });

    test('GetAll wrong type model instances', () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer((realInvocation) async => [TestModel(), EmptyModel()]);

      expect(await repo.getTeamMembers(), <UserModel>[]);
    });

    test(
        'GetAll mixed wrong and right type model instances fetch failed due to user is not a manager',
        () async {
      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetails);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          TestModel(),
          EmptyModel(),
          UserModel.fromJson({'name': 'Test User', 'id': 1})
        ],
      );

      expect(await repo.getTeamMembers(), <UserModel>[]);
    });

    test('GetAll mixed wrong and right type model instances', () async {
      // Create a UserDetailsState instance
      final userDetailsState = UserDetailsState(0, 0, 0, true);

      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetailsState);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          TestModel(),
          EmptyModel(),
          UserModel.fromJson({'name': 'Test User', 'id': 1})
        ],
      );

      expect(await repo.getTeamMembers(), [
        UserModel.fromJson({'name': 'Test User', 'id': 1})
      ]);
    });

    test(
        'GetAll right type model instances fetch failed due to user is not a manager',
        () async {
          final userDetailsState = UserDetailsState(0, 0, 0, false);

      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetailsState);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          ),
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          ),
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          )
        ],
      );

      expect((await repo.getTeamMembers()).length, 0);
    });

    test('GetAll right type model instances', () async {
      final userDetailsState = UserDetailsState(0, 0, 0, true);

      final UserRepository repo =
          UserRepositoryImplementation(datasource, 'res.users', userDetailsState);

      when(
        datasource.fetchAll(
          any,
          domain: anyNamed('domain'),
          fields: anyNamed('fields'),
        ),
      ).thenAnswer(
        (realInvocation) async => [
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          ),
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          ),
          UserModel.fromJson(
            {'name': 'Test User', 'id': 1, 'email': 'email@email.com'},
          )
        ],
      );

      expect((await repo.getTeamMembers()).length, 3);
    });
  });
}
