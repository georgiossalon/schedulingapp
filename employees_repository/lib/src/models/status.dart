import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Status {
  final DateTime statusDate;
  final String start_shift;
  final String end_shift;
  final String reason;
  final String description;
  final String id;
  
  Status({
    this.statusDate,
    this.start_shift,
    this.end_shift,
    this.reason,
    this.description,
    this.id
  });

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    if (timestamp != null) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
    }
  }

  Status copyWith({
    DateTime unavailabilityDate,
    String start_shift,
    String end_shift,
    String reason,
    String description,
    int id,
  }) {
    return Status(
      statusDate: statusDate ?? this.statusDate,
      start_shift: start_shift ?? this.start_shift,
      end_shift: end_shift ?? this.end_shift,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode {
    return statusDate.hashCode ^
      start_shift.hashCode ^
      end_shift.hashCode ^
      reason.hashCode ^
      description.hashCode ^
      id.hashCode;
  }
 
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Status &&
      o.statusDate == statusDate &&
      o.start_shift == start_shift &&
      o.end_shift == end_shift &&
      o.reason == reason &&
      o.description == description &&
      o.id == id;
  }
  
  @override
  String toString() {
    return 'Status( statusDate: $statusDate, start_shift: $start_shift, end_shift: $end_shift, reason: $reason, description: $description, id: $id)';
  }

  StatusEntity toEntity() {
    return StatusEntity(
      statusDate: statusDate,
      start_shift: start_shift, 
      end_shift: end_shift,
      reason: reason, 
      description: description,
      id: id,
    );
  }

  static Status fromEntity(StatusEntity entity) {
    return Status(
        statusDate: entity.statusDate,
      start_shift: entity.start_shift,
      end_shift: entity.end_shift,
      reason: entity.reason,
      description: entity.description,
      id: entity.id
    );
  }

}
