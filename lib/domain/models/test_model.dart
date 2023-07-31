// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:happiness_app/domain/models/model.dart';

class TestModel implements Model {

  TestModel();

  TestModel.initialized({this.id, this.note});

  @override
  TestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    note = json['x_note'] as String?;
  }
  @override
  int? id;
  String? note;

  @override
  void setNewId(int newId) {
    id = newId;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'x_note': note,
      };

  @override
  String toString() {
    return 'TestModel{id: $id, note: $note}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          note == other.note;

  @override
  int get hashCode => id.hashCode ^ note.hashCode;
}
