// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:happiness_app/domain/models/model.dart';

class UserModel implements Model {

  @override
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
  }
  @override
  int? id;
  String? name;

  @override
  void setNewId(int newId) {
    id = newId;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
