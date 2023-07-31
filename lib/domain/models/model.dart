/// Abstract class for defining data models.
abstract class Model {
  /// Getter for the model id.
  int? get id;

  /// Function used for assigning new id to the instance.
  void setNewId(int newId);

  /// Function used for transforming a model object to a JSON map.
  /// Returns a JSON map representation of the model object.
  Map<String, dynamic> toJson();
}
