import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/model.dart';

/// An abstract class defining the interface for a datasource.
abstract class Datasource {
  /// Fetches a list of all model instances of
  /// the given type from the local storage.
  ///
  /// - [modelName]: The type of model.
  ///
  /// Returns a Future that resolves to a list of Model instances.
  Future<List<Model>> fetchAll(String modelName,
      {List<String>? fields, List<dynamic>? domain, int? limit, int? offset, String? order,});

  /// Fetches a model instance of the given type
  /// from the local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to fetch.
  ///
  /// Returns a Future that resolves to a Model instance if fetch is successful
  /// or [EmptyModel] if the fetch fails.
  Future<Model> fetch(String modelName, int modelId, {List<String>? fields});

  /// Creates a new model instance of the given type in local storage.
  ///
  /// - [modelName]: The type of model to create.
  /// - [modelInstance]: The new model instance to create.
  ///
  /// Returns a Future that resolves to the new model instance
  /// if the creation was successful,
  /// or an [EmptyModel] if the creation failed.
  Future<Model> create(String modelName, Model modelInstance);

  /// Updates a model instance of the given type from the local storage
  /// by a given ID.
  ///
  /// - [modelName]: The type of model to create.
  /// - [updatedModelInstance]: The updated model instance.
  ///
  /// Returns a Future that resolves to a Model
  /// instance if the update is successful
  /// or an [EmptyModel] if the update fails.
  Future<Model> update(String modelName, Model updatedModelInstance);

  /// Deletes a model instance of the given type in local storage by a given ID.
  ///
  /// - [modelName]: The type of model.
  /// - [modelId]: The id of the model instance to delete.
  ///
  /// Returns a Future that resolves to a boolean value,
  /// indicating if the deletion was successful.
  Future<bool> delete(String modelName, int modelId);
}
