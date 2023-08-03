// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_dynamic_calls

import 'dart:developer';

import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/data/datasources/initializable_datasource.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

/// A datasource implementation for Odoo.
class OdooDatasource implements Datasource, InitDatasource {
  /// Returns the singleton instance of [OdooDatasource].
  factory OdooDatasource() {
    return _singleton;
  }

  /// Private constructor for creating a singleton instance.
  OdooDatasource._internal();

  final odooUrl = 'https://testhappinessapp.odoo.com:443';
  late OdooClient client;
  late OdooClient Function(String url, OdooSession session) createOdooClient;

  static final OdooDatasource _singleton = OdooDatasource._internal();

  @override
  Future<void> initDatasource(
      String sessionId,
      OdooClient Function(String url, OdooSession session)? function,
      void Function(UserDetailsState) updateUserDetailsState,) async {
    createOdooClient = function ??
        (String url, OdooSession session) {
          return OdooClient(url, session);
        };

    // create temporary session to fetch the full session details
    final tempSession = OdooSession(
      id: sessionId,
      userId: 0,
      partnerId: 0,
      companyId: 0,
      userLogin: '',
      userName: '',
      userLang: '',
      userTz: '',
      isSystem: false,
      dbName: '',
      serverVersion: '',
    );

    // establish connection using the current sessionId for authentication
    final tempClient = createOdooClient(odooUrl, tempSession);
    final completeSession = await tempClient.callRPC(
      '/web/session/get_session_info',
      'call',
      <dynamic, dynamic>{},
    );

    // extract the full session data
    final session = OdooSession(
      id: sessionId,
      userId: (completeSession as Map)['uid'] as int,
      partnerId: completeSession['partner_id'] as int,
      companyId: completeSession['company_id'] as int,
      userLogin: completeSession['username'] as String,
      userName: completeSession['partner_display_name'] as String,
      userLang: (completeSession['user_context'] as Map)['lang'] as String,
      userTz: (completeSession['user_context'] as Map)['tz'] as String,
      isSystem: completeSession['is_system'] as bool,
      dbName: completeSession['db'] as String,
      serverVersion: completeSession['server_version'] as String,
    );

    // extract user id and configure odoo client
    final userId = completeSession['uid'] as int;
    client = createOdooClient(odooUrl, session);

    // fetch employee data
    final list = await client.callKw({
      'model': 'hr.employee',
      'method': 'search_read',
      'args': <dynamic>[],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
        'domain': [
          ['user_id', '=', userId]
        ],
        'fields': ['id', 'user_id', 'name', 'department_id'],
        'limit': 0, // retrieve all records
      }
    }) as List<dynamic>;

    var employeeId = 0;
    var departmentId = 0;
    var isManager = false;

    // if user is employee extract employee id and department id
    if (list.isNotEmpty) {
      employeeId = list[0]['id'] as int;

      try {
        departmentId = list[0]['department_id'][0] as int;
        isManager = false;
      } catch (e) {
        log('Init Odoo source: Extract department data: $e');

        // fetch department data
        final list2 = await client.callKw({
          'model': 'hr.department',
          'method': 'search_read',
          'args': <dynamic>[],
          'kwargs': {
            'context': {
              'allowed_company_ids': [1],
            },
            'domain': [
              ['manager_id', '=', employeeId]
            ],
            'fields': ['id', 'manager_id'],
            'limit': 0, // retrieve all records
          }
        }) as List<dynamic>;

        if (list2.isEmpty) {
          isManager = false;
        } else {
          // check if current user is manager of the department
          departmentId = list2[0]['id'] as int;
          isManager = true;
        }
      }
    }

    // update the current user data
    updateUserDetailsState.call(UserDetailsState(userId, employeeId, departmentId, isManager));
  }

  @override

  /// Creates a new model instance of the given type in local storage.
  ///
  /// - [modelName]: The type of model to create.
  /// - [modelInstance]: The new model instance to create.
  ///
  /// Returns a Future that resolves to the new model instance if the creation was successful,
  /// or an [EmptyModel] if the creation failed.
  Future<Model> create(String modelName, Model modelInstance) async {
    final id = await client.callKw({
      'model': modelName,
      'method': 'create',
      'args': [modelInstance.toJson()],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
      }
    }) as int;

    return fetch(modelName, id);
  }

  @override

  /// Deletes a model instance of the given type in local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to delete.
  ///
  /// Returns a Future that resolves to a boolean value, indicating if the deletion was successful.
  Future<bool> delete(String modelName, int modelId) async {
    await client.callKw({
      'model': modelName,
      'method': 'unlink',
      'args': [modelId],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
      },
    });
    return true;
  }

  @override

  /// Fetches a model instance of the given type from the local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to fetch.
  ///
  /// Returns a Future that resolves to a Model instance if fetch is successful
  /// or [EmptyModel] if the fetch fails.
  Future<Model> fetch(String modelName, int modelId,
      {List<String>? fields}) async {
    final list = await client.callKw({
      'model': modelName,
      'method': 'read',
      'args': [modelId],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
        'fields': fields,
      }
    }) as List<dynamic>;

    try {
      final modelList =
          list.map((e) => Helper.getModelFromJson(modelName, e)).toList();
      return modelList[0];
    } catch (e) {
      return EmptyModel();
    }
  }

  @override

  /// Fetches a list of all model instances of the given type from the local storage.
  ///
  /// - [modelName]: The type of model.
  ///
  /// Returns a Future that resolves to a list of Model instances.
  Future<List<Model>> fetchAll(
    String modelName, {
    List<String>? fields,
    List<dynamic>? domain,
    int? limit,
    int? offset,
        String? order,
  }) async {
    final list = await client.callKw({
      'model': modelName,
      'method': 'search_read',
      'args': <dynamic>[],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
        'domain': domain,
        'fields': fields,
        'limit': limit ?? 0, // if 0 retrieve all records
        'offset': offset ?? 0, // if 0 start from the first record
        'order': order ?? 'id desc',
      }
    }) as List<dynamic>;

    final modelList =
        list.map((e) => Helper.getModelFromJson(modelName, e)).toList();
    return modelList;
  }

  @override

  /// Updates a model instance of the given type from the local storage by a given ID.
  ///
  /// - [modelName]: The type of model to create.
  /// - [updatedModelInstance]: The updated model instance.
  ///
  /// Returns a Future that resolves to a Model instance if the update is successful
  /// or an [EmptyModel] if the update fails.
  Future<Model> update(String modelName, Model modelInstance) async {
    await client.callKw({
      'model': modelName,
      'method': 'write',
      'args': [
        [modelInstance.id],
        modelInstance.toJson(),
      ],
      'kwargs': {
        'context': {
          'allowed_company_ids': [1],
        },
      },
    });

    return fetch(modelName, modelInstance.id!);
  }
}
