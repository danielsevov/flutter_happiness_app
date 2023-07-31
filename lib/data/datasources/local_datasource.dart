// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_slow_async_io, avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:happiness_app/data/datasources/datasource.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/model.dart';
import 'package:happiness_app/helper.dart';
import 'package:path_provider/path_provider.dart';

/// A datasource implementation for a local storage.
class LocalDatasource implements Datasource {

  /// Returns the singleton instance of [LocalDatasource].
  factory LocalDatasource() {
    return _singleton;
  }

  /// Private constructor for creating a singleton instance.
  LocalDatasource._internal();

  static final LocalDatasource _singleton = LocalDatasource._internal();

  /// A private String variable that holds the name of the storage file.
  final String _storageFileName = 'data.json';

  /// Clears the data storage file
  // Future<bool> clearFile() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/$_storageFileName');
  //   try {
  //     await file.delete();
  //     return true;
  //   } catch (e) {
  //     log('LocalDatasource ClearFile: $e');
  //     return false;
  //   }
  // }

  /// Reads a list of models of a given type from local storage.
  /// Returns an empty list if the storage file doesn't exist.
  ///
  /// - [modelName]: The type of model to read.
  ///
  /// Returns a Future that resolves to a list of [Model].
  Future<List<Model>> _readModelsFromStorage(String modelName) async {
    // Get directory for app documents
    final dir = await getApplicationDocumentsDirectory();
    // Create file object from directory and storage file name
    final file = File('${dir.path}/$_storageFileName');
    // Check if file exists
    if (await file.exists()) {
      // Read JSON data from file
      final json = await file.readAsString();

      // Try to decode JSON data as a list of models of the given type
      try {
        final jsonData =
        (jsonDecode(json) as Map )[modelName] as List<dynamic>;
        // Map the JSON data to a list of model objects

        return jsonData
            .map((data) => Helper.getModelFromJson(modelName, data))
            .toList();
      }
      // If decoding fails, return an empty list
      catch (e) {
        log('LocalDatasource ReadFile: $e');
        return [];
      }
    }
    // If file does not exist, return an empty list
    return [];
  }

  /// Writes a list of models of a given type to local storage.
  ///
  /// - [modelName]: The type of model to write.
  /// - [models]: The list of models to write.
  ///
  /// Returns a Future that resolves to a [bool] indicating whether the write was successful.
  Future<bool> _writeModelsToStorage(
      String modelName, List<Model> models,) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_storageFileName');
    if (await file.exists()) {
      // Read existing data from file
      final json = await file.readAsString();
      final jsonData = jsonDecode(json) as Map<String, dynamic>;
      var existingData = <dynamic>[];

      // If existing data for model exists, get it
      if (jsonData.containsKey(modelName)) {
        existingData = jsonData[modelName] as List<dynamic>;
      }

      // Remove existing data that will be overwritten by new data
      final newIds = models.map((model) => model.id).toList();
      existingData.removeWhere((data) => newIds.contains((data as Map )['id']));

      // Merge new data with existing data
      final List<dynamic> newData = models.map((model) => model.toJson()).toList();
      final mergedData = List<dynamic>.from(existingData)..addAll(newData);
      jsonData[modelName] = mergedData;

      // Write merged data back to file
      try {
        file.writeAsStringSync(jsonEncode(jsonData));
        return true;
      } catch (e) {
        log('LocalDatasource WriteExistingFile: $e');
        return false;
      }
    } else {
      // File does not exist, write new data
      final json = <String, List<dynamic>>{
        modelName: models.map((model) => model.toJson()).toList()
      };
      try {
        file.writeAsStringSync(jsonEncode(json));
        return true;
      } catch (e) {
        log('LocalDatasource WriteNewFile: $e');
        return false;
      }
    }
  }

  @override

  /// Creates a new model instance of the given type in local storage.
  ///
  /// - [modelName]: The type of model to create.
  /// - [modelInstance]: The new model instance to create.
  ///
  /// Returns a Future that resolves to the new [Model] instance if the creation was successful,
  /// or an [EmptyModel] if the creation failed.
  Future<Model> create(String modelName, Model modelInstance) async {
    final models = await _readModelsFromStorage(modelName);
    // Generate and assign a unique ID for the model instance
    final newId = models.isNotEmpty ? (models.last.id!) + 1 : 1;
    modelInstance.setNewId(newId);
    models.add(modelInstance);

    // Try writing the models
    final success = await _writeModelsToStorage(modelName, models);
    return success ? modelInstance : EmptyModel();
  }

  @override

  /// Deletes a model instance of the given type in local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to delete.
  ///
  /// Returns a Future that resolves to a [bool] value, indicating if the deletion was successful.
  Future<bool> delete(String modelName, int modelId) async {
    // Get the application documents directory
    final dir = await getApplicationDocumentsDirectory();
    // Get the storage file from the directory
    final file = File('${dir.path}/$_storageFileName');

    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON data from the file
      final json = await file.readAsString();
      // Decode the JSON data into a Map object
      final jsonData = jsonDecode(json) as Map<String, dynamic>;
      // Get the list of model data for the specified model name
      final modelsData = jsonData[modelName] ?? <Model>[];

      // Find the index of the model data with the specified ID
      final index =
          modelsData.indexWhere((modelData) => (modelData as Map )['id'] == modelId);
      // If the model data was found, remove it from the list
      if (index != -1) {
        modelsData.removeAt(index);
        // Update the JSON data with the modified model list
        jsonData[modelName] = modelsData;
        try {
          // Write the updated JSON data back to the file
          file.writeAsStringSync(jsonEncode(jsonData));
          return true; // Return true to indicate successful deletion
        } catch (e) {
          log('LocalDatasource Delete: $e'); // Log any errors that occur during file write
        }
      }
    }
    return false; // Return false to indicate unsuccessful deletion
  }

  @override

  /// Fetches a model instance of the given type from the local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to fetch.
  ///
  /// Returns a Future that resolves to a [Model] instance if fetch is successful
  /// or [EmptyModel] if the fetch fails.
  Future<Model> fetch(String modelName, int modelId, {List<String>? fields}) async {
    // Fetch all models of the searched type from storage
    final models = await _readModelsFromStorage(modelName);
    // Find the one with the matching ID
    final index = models.indexWhere((model) => model.id == modelId);
    // If found return the model instance, otherwise return an empty model
    if (index != -1) {
      return models[index];
    }
    return EmptyModel();
  }

  @override

  /// Fetches a list of all model instances of the given type from the local storage.
  ///
  /// - [modelName]: The type of model.
  ///
  /// Returns a Future that resolves to a list of [Model] instances.
  Future<List<Model>> fetchAll(String modelName,
      {List<String>? fields, List<dynamic>? domain, int? limit, int? offset, String? order,}) async {
    // Fetch and return all models from the searched type
    final models = await _readModelsFromStorage(modelName);
    return models;
  }

  @override

  /// Updates a model instance of the given type from the local storage by a given ID.
  ///
  /// - [modelName]: The type of model to create.
  /// - [updatedModelInstance]: The updated model instance.
  ///
  /// Returns a Future that resolves to a [Model] instance if the update is successful
  /// or an [EmptyModel] if the update fails.
  Future<Model> update(String modelName, Model updatedModelInstance) async {
    // Read all models of the given type from storage
    final models = await _readModelsFromStorage(modelName);
    // Find the index of the model to update by matching its ID and type
    final index = models.indexWhere((model) =>
        model.id == updatedModelInstance.id &&
        model.runtimeType == updatedModelInstance.runtimeType,);
    // If the model to update was found
    if (index != -1) {
      // Replace the old model instance with the updated one
      models[index] = updatedModelInstance;
      // Write all models of the given type back to storage
      final success = await _writeModelsToStorage(modelName, models);
      // Return the updated model if the write operation was successful, otherwise return an empty model
      return success ? updatedModelInstance : EmptyModel();
    }
    // Return an empty model if the model to update was not found
    return EmptyModel();
  }
}
