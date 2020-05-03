import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';

class UnavailabilityEntity extends Equatable {
  final DateTime unavailabilityDate;
  final String start_shift;
  final String end_shift;
  final String reason;
  final String description;
  
  const UnavailabilityEntity({
    this.unavailabilityDate,
    this.start_shift,
    this.end_shift,
    this.reason,
    this.description,
  });

  @override
  Map<String,Object> toJson() {
    return {
      'unavailability_date': unavailabilityDate,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description
    };
  }

  List<Object> get props => [
    unavailabilityDate,
    start_shift,
    end_shift,
    reason,
    description
  ];

  @override
  String toString() {
    return 'UnavailabilityEntity(unavailabilityDate: $unavailabilityDate, start_shift: $start_shift, end_shift: $end_shift, reason: $reason, description: $description)';
  }
  
  static UnavailabilityEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;
  
    return UnavailabilityEntity(
      unavailabilityDate: date,
      start_shift: json['start_shift'] as String,
      end_shift: json['end_shift'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
    );
  }

  static UnavailabilityEntity fromSnapshot (DocumentSnapshot snap) {
    return UnavailabilityEntity(
      unavailabilityDate: snap.data['unavailability_date'],
      start_shift: snap.data['start_shift'],
      end_shift: snap.data['end_shift'],
      reason: snap.data['reason'],
      description: snap.data['description'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'unavailabilityDate': unavailabilityDate?.millisecondsSinceEpoch,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description,
    };
  }

}
