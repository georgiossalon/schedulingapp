import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final DateTime statusDate;
  final String start_shift;
  final String end_shift;
  final String reason;
  final String description;
  final String id;
  
  const StatusEntity({
    this.statusDate,
    this.start_shift,
    this.end_shift,
    this.reason,
    this.description,
    this.id,
  });

  @override
  Map<String,Object> toJson() {
    return {
      'status_date': statusDate,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description,
      'id': id,
    };
  }

  List<Object> get props => [
    statusDate,
    start_shift,
    end_shift,
    reason,
    description,
    id
  ];

  @override
  String toString() {
    return 'StatusEntity { statusDate: $statusDate, start_shift: $start_shift, end_shift: $end_shift, reason: $reason, description: $description, id: $id)';
  }
  
  static StatusEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;
  
    return StatusEntity(
        statusDate: date,
      start_shift: json['start_shift'] as String,
      end_shift: json['end_shift'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
      id: json['id'] as String
    );
  }

  static StatusEntity fromSnapshot (DocumentSnapshot snap) {
    return StatusEntity(
        statusDate: snap.data['status_date'],
      start_shift: snap.data['start_shift'],
      end_shift: snap.data['end_shift'],
      reason: snap.data['reason'],
      description: snap.data['description'],
      id: snap.documentID
    );
  }

  Map<String, Object> toDocument() {
    return {
      'statusDate': statusDate?.millisecondsSinceEpoch,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description,
    };
  }

}
