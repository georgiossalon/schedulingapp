import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';

import '../entities/entities.dart';

class Designation {
  final String designation;
  final String id;
  final String chosenDesignationForEreignis;
  Designation({
    this.designation,
    this.id,
    this.chosenDesignationForEreignis
  });

  Designation copyWith({
    String designation,
    String id,
    String chosenDesignationForEreignis,
  }) {
    return Designation(
      designation: designation ?? this.designation,
      id: id ?? this.id,
      chosenDesignationForEreignis: chosenDesignationForEreignis ?? this.chosenDesignationForEreignis
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'designation': designation,
      'id': id,
    };
  }

  static Designation fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Designation(
      designation: map['designation'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  static Designation fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Designation(designation: $designation, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Designation && o.designation == designation && o.id == id;
  }

  @override
  int get hashCode => designation.hashCode ^ id.hashCode;

  DesignationEntity toEntity() {
    return DesignationEntity(
      designation: designation,
      id: id,
    );
  }

  static Designation fromEntity(DesignationEntity entity) {
    return Designation(
      designation: entity.designation,
      id: entity.id,
    );
  }
}
