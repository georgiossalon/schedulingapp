import 'dart:convert';

import 'package:employees_repository/employees_repository.dart';

import '../entities/entities.dart';

class Designations {
  final List<String> designations;
  final String currentDesignation; // for when I am creating a new one
  final String id;
  Designations({
    this.designations,
    this.currentDesignation,
    this.id,
  });

  Designations copyWith({
    String designation,
    String id,
    String currentDesignation,
  }) {
    return Designations(
      designations: designation ?? this.designations,
      currentDesignation: currentDesignation ?? this.currentDesignation,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'designation': designations,
      'id': id,
    };
  }

  static Designations fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Designations(
      designations: map['designation'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  static Designations fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Designation(designation: $designations, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Designations && o.designations == designations && o.id == id;
  }

  @override
  int get hashCode => designations.hashCode ^ id.hashCode;

  DesignationEntity toEntity() {
    return DesignationEntity(
      designations: designations,
      id: id,
    );
  }

  static Designations fromEntity(DesignationEntity entity) {
    return Designations(
      designations: entity.designations,
      id: entity.id,
    );
  }
}
