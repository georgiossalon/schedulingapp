import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DesignationEntity extends Equatable {
  final List<String> designations;
  final String id;
  DesignationEntity({
    this.designations,
    this.id,
  });

  DesignationEntity copyWith({
    String designation,
    String id,
  }) {
    return DesignationEntity(
      designations: designation ?? this.designations,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'designations': designations,
    };
  }

  static DesignationEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap == null) return null;
  
    return DesignationEntity(
      designations:  List.from(snap['designations']),
      id: snap.documentID,
    );
  }

  String toJson() => json.encode(toDocument());

  static DesignationEntity fromJson(String source) => fromSnapshot(json.decode(source));

  @override
  String toString() => 'DesignationEntity{ designation: $designations}';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DesignationEntity &&
      o.designations == designations &&
      o.id == id;
  }

  @override
  int get hashCode => designations.hashCode ^ id.hashCode;

  @override
  List<Object> get props => [
    designations,
    id,
  ];
}
