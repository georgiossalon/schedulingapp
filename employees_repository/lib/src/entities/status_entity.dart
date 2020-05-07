import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final DateTime status_date;
  final String start_shift;
  final String end_shift;
  final String reason;
  final String description;
  final String id;

  const StatusEntity({
    this.status_date,
    this.start_shift,
    this.end_shift,
    this.reason,
    this.description,
    this.id,
  });

  @override
  Map<String, Object> toJson() {
    return {
      'status_date': status_date,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description,
      'id': id,
    };
  }

  List<Object> get props =>
      [status_date, start_shift, end_shift, reason, description, id];

  @override
  String toString() {
    return 'StatusEntity { statusDate: $status_date, start_shift: $start_shift, end_shift: $end_shift, reason: $reason, description: $description, id: $id)';
  }

  static StatusEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;

    return StatusEntity(
        status_date: date,
        start_shift: json['start_shift'] as String,
        end_shift: json['end_shift'] as String,
        reason: json['reason'] as String,
        description: json['description'] as String,
        id: json['id'] as String);
  }

  static StatusEntity fromSnapshot(DocumentSnapshot snap) {
    return StatusEntity(
        status_date: convertingFirestoreDateToDateTime(
            snap.data['status_date'] as Timestamp),
        start_shift: snap.data['start_shift'],
        end_shift: snap.data['end_shift'],
        reason: snap.data['reason'],
        description: snap.data['description'],
        id: snap.documentID);
  }

  Map<String, Object> toDocument() {
    return {
      'status_date': status_date,
      'start_shift': start_shift,
      'end_shift': end_shift,
      'reason': reason,
      'description': description,
    };
  }

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }
}
