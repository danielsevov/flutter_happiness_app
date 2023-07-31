import 'package:happiness_app/domain/models/model.dart';

/// Empty model class.
class EmptyModel implements Model {

  EmptyModel();
  // The ID of the daily introspection entry.
  @override
  final int id = 0;

  @override
  /// Function used for assigning new id to the instance.
  void setNewId(int newId) {}

  @override
  /// Function used for transforming a model object to a JSON map.
  /// Returns a JSON map representation of the model object.
  Map<String, dynamic> toJson() => {
        'id': id,
      };

  @override
  String toString() {
    return 'EmptyModel{id: $id}';
  }
}
