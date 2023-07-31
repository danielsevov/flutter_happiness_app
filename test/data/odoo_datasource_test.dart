// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, cascade_invocations, unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/datasources/odoo_datasource.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'odoo_datasource_test.mocks.dart';

@GenerateMocks([OdooClient])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OdooDatasource odooDatasource;
  late MockOdooClient mockOdooClient;
  var userDetailsState = UserDetailsState(0, 0, 0, false);
  void updateFunction(UserDetailsState userDetails) {
    userDetailsState = userDetails;
  }

  setUp(() {
    mockOdooClient = MockOdooClient();
    odooDatasource = OdooDatasource();
    odooDatasource.client = mockOdooClient;
  });

  group('OdooDatasource Constructor tests', () {
    test('OdooDatasource constructor test', () async {
      expect(odooDatasource.runtimeType, OdooDatasource);
    });

    test('OdooDatasource singleton test', () async {
      final datasource = OdooDatasource();
      expect(datasource, odooDatasource);
    });
  });

  group('OdooDatasource tests', () {

    /// Init test
    test('Init datasource', () async {
      // Set up mocks
      final mockOdooClient = MockOdooClient();

      // Simulate responses
      final completeSession = {
        'uid': 1,
        'partner_id': 1,
        'company_id': 1,
        'username': 'testuser',
        'partner_display_name': 'Test User',
        'user_context': {'lang': 'en_US', 'tz': 'UTC'},
        'is_system': false,
        'db': 'test_db',
        'server_version': '15.0',
      };

      final hrEmployeeList = [
        {
          'id': 1,
          'user_id': 1,
          'name': 'Test Employee',
          'department_id': [1, 'Test Department'],
        },
      ];

      final hrDepartmentList = [
        {
          'id': 1,
          'manager_id': 1,
        },
      ];

      // Stub API calls
      when(mockOdooClient.callRPC('/web/session/get_session_info', 'call', any)).thenAnswer((_) async => completeSession);
      when(mockOdooClient.callKw(argThat(containsPair('model', 'hr.employee')))).thenAnswer((_) async => hrEmployeeList);
      when(mockOdooClient.callKw(argThat(containsPair('model', 'hr.department')))).thenAnswer((_) async => hrDepartmentList);

      // Instantiate the class with the mock client
      final odooDatasource = OdooDatasource();
      odooDatasource.client = mockOdooClient;

      // Call the initDatasource method
      await odooDatasource.initDatasource('test_session_id',
              (String url, OdooSession session){
        return mockOdooClient;
      }, updateFunction,);
    });

      test('Init datasource', () async {
        // Set up mocks
        final mockOdooClient = MockOdooClient();

        // Simulate responses
        final completeSession = {
          'uid': 1,
          'partner_id': 1,
          'company_id': 1,
          'username': 'testuser',
          'partner_display_name': 'Test User',
          'user_context': {'lang': 'en_US', 'tz': 'UTC'},
          'is_system': false,
          'db': 'test_db',
          'server_version': '15.0',
        };

        final hrEmployeeList = [
          {
            'id': 1,
            'user_id': 1,
            'name': 'Test Employee',
            'department_id': [1, 'Test Department'],
          },
        ];

        final hrDepartmentList = [
          {
            'id': false,
          },
        ];

        // Stub API calls
        when(mockOdooClient.callRPC('/web/session/get_session_info', 'call', any)).thenAnswer((_) async => completeSession);
        when(mockOdooClient.callKw(any)).thenAnswer((_) async => hrEmployeeList);
        when(mockOdooClient.callKw(argThat(containsPair('model', 'hr.department')))).thenAnswer((_) async => hrDepartmentList);

        // Instantiate the class with the mock client
        final odooDatasource = OdooDatasource();
        odooDatasource.client = mockOdooClient;

        // Call the initDatasource method
        await odooDatasource.initDatasource('test_session_id',
                (String url, OdooSession session){
              return mockOdooClient;
            }, updateFunction,);
    });

    test('Init datasource', () async {
      // Set up mocks
      final mockOdooClient = MockOdooClient();

      // Simulate responses
      final completeSession = {
        'uid': 1,
        'partner_id': 1,
        'company_id': 1,
        'username': 'testuser',
        'partner_display_name': 'Test User',
        'user_context': {'lang': 'en_US', 'tz': 'UTC'},
        'is_system': false,
        'db': 'test_db',
        'server_version': '15.0',
      };

      final hrEmployeeList = [
        {
          'id': 1,
          'user_id': 1,
          'name': 'Test Employee',
          'department_id': false,
        },
      ];

      final hrDepartmentList = [
        {
          'id': 1,
          'manager_id': 1,
        },
      ];

      // Stub API calls
      when(mockOdooClient.callRPC('/web/session/get_session_info', 'call', any)).thenAnswer((_) async => completeSession);
      when(mockOdooClient.callKw(any)).thenAnswer((_) async => hrEmployeeList);
      when(mockOdooClient.callKw(argThat(containsPair('model', 'hr.department')))).thenAnswer((_) async => hrDepartmentList);

      // Instantiate the class with the mock client
      final odooDatasource = OdooDatasource();
      odooDatasource.client = mockOdooClient;

      // Call the initDatasource method
      await odooDatasource.initDatasource('test_session_id',
              (String url, OdooSession session){
            return mockOdooClient;
          }, updateFunction,);
    });

    test('Init datasource', () async {
      // Set up mocks
      final mockOdooClient = MockOdooClient();

      // Simulate responses
      final completeSession = {
        'uid': 1,
        'partner_id': 1,
        'company_id': 1,
        'username': 'testuser',
        'partner_display_name': 'Test User',
        'user_context': {'lang': 'en_US', 'tz': 'UTC'},
        'is_system': false,
        'db': 'test_db',
        'server_version': '15.0',
      };

      final hrEmployeeList = [
        {
          'id': 1,
          'user_id': 1,
          'name': 'Test Employee',
          'department_id': false,
        },
      ];

      final hrDepartmentList = <dynamic>[];

      // Stub API calls
      when(mockOdooClient.callRPC('/web/session/get_session_info', 'call', any)).thenAnswer((_) async => completeSession);
      when(mockOdooClient.callKw(any)).thenAnswer((_) async => hrEmployeeList);
      when(mockOdooClient.callKw(argThat(containsPair('model', 'hr.department')))).thenAnswer((_) async => hrDepartmentList);

      // Instantiate the class with the mock client
      final odooDatasource = OdooDatasource();
      odooDatasource.client = mockOdooClient;

      // Call the initDatasource method
      await odooDatasource.initDatasource('test_session_id',
              (String url, OdooSession session){
            return mockOdooClient;
          }, updateFunction,);
    });

    /// Create test
    test('Create and persist single model instance', () async {
      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'create',
        'args': [TestModel.initialized(id : 1, note : 'This is model 1').toJson()],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
        }
      }),).thenAnswer((realInvocation) async => 1);

      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'read',
        'args': [1],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
          'fields': null,
        }
      }),).thenAnswer((realInvocation) async => [TestModel.initialized(id : 1, note : 'This is model 1').toJson()]);

      expect(await odooDatasource.create('x_test_model', TestModel.initialized(id : 1, note : 'This is model 1')), TestModel.initialized(id : 1, note : 'This is model 1'));
    });

    /// Fetch test
    test('Fetch single model instance', () async {
      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'read',
        'args': [1],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
          'fields': null,
        }
      }),).thenAnswer((realInvocation) async => [TestModel.initialized(id : 1, note : 'This is model 1').toJson()]);

      when(mockOdooClient.callKw({
        'model': 'idk',
        'method': 'read',
        'args': [2],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
          'fields': null,
        }
      }),).thenAnswer((realInvocation) async => [EmptyModel().toJson()]);

      expect(await odooDatasource.fetch('x_test_model', 1), TestModel.initialized(id : 1, note : 'This is model 1'));
      expect((await odooDatasource.fetch('idk', 2)).runtimeType, EmptyModel);
    });

    /// FetchAll test
    test('Fetch single model instance', () async {
      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'search_read',
        'args': <dynamic>[],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
          'domain': null,
          'fields': null,
          'limit': 0,
          'offset': 0,
          'order': 'id desc',
        }
      }),).thenAnswer((realInvocation) async => [TestModel.initialized(id : 1, note : 'This is model 1').toJson()]);

      expect((await odooDatasource.fetchAll('x_test_model')).first, TestModel.initialized(id : 1, note : 'This is model 1'));
    });

    /// Delete test
    test('Delete single model instance', () async {
      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'unlink',
        'args': [1],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
        },
      }),).thenAnswer((realInvocation) async => true);

      expect(await odooDatasource.delete('x_test_model', 1), true);
    });

    /// Update test
    test('Update single model instance', () async {
      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'read',
        'args': [1],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
          'fields': null,
        }
      }),).thenAnswer((realInvocation) async => [TestModel.initialized(id : 1, note : 'This is model 1').toJson()]);

      when(mockOdooClient.callKw({
        'model': 'x_test_model',
        'method': 'write',
        'args': [
          [1],
          TestModel.initialized(id : 1, note : 'This is model 1').toJson(),
        ],
        'kwargs': {
          'context': {
            'allowed_company_ids': [1],
          },
        },
      }),).thenAnswer((realInvocation) async => [1]);

      expect(await odooDatasource.update('x_test_model', TestModel.initialized(id : 1, note : 'This is model 1')), TestModel.initialized(id : 1, note : 'This is model 1'));
    });
  });
}
