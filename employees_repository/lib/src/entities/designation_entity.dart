import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DesignationEntity extends Equatable {
  final String designation;
  final String id;
  DesignationEntity({
    this.designation,
    this.id,
  });

  DesignationEntity copyWith({
    String designation,
    String id,
  }) {
    return DesignationEntity(
      designation: designation ?? this.designation,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'designation': designation,
    };
  }

  static DesignationEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap == null) return null;
  
    return DesignationEntity(
      designation: snap['designation'],
      id: snap.documentID,
    );
  }

  String toJson() => json.encode(toDocument());

  static DesignationEntity fromJson(String source) => fromSnapshot(json.decode(source));

  @override
  String toString() => 'DesignationEntity(designation: $designation, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DesignationEntity &&
      o.designation == designation &&
      o.id == id;
  }

  @override
  int get hashCode => designation.hashCode ^ id.hashCode;

  @override
  List<Object> get props => [
    designation,
    id,
  ];
}
