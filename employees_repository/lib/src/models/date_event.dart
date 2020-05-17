import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class DateEvent {
  final String description;
  final String designation;
  final String employeeName;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime dateEvent_date;
  final String parentId;

  DateEvent({
    this.description,
    this.designation,
    this.employeeName,
    this.end_shift,
    this.id,
    this.reason,
    this.start_shift,
    this.dateEvent_date,
    this.parentId
  });

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    if (timestamp != null) {
      DateTime dateTimeHiringDate =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
          dateTimeHiringDate.day, 12);
    }
  }

  DateEvent copyWith({
    String description,
    String designation,
    String employeeName,
    String end_shift,
    String id,
    String reason,
    String start_shift,
    DateTime dateEvent_date,
    String parentId,
  }) {
    return DateEvent(
      description: description ?? this.description,
      designation: designation ?? this.designation,
      employeeName: employeeName ?? this.employeeName,
      end_shift: end_shift ?? this.end_shift,
      id: id ?? this.id,
      reason: reason ?? this.reason,
      start_shift: start_shift ?? this.start_shift,
      dateEvent_date: dateEvent_date ?? this.dateEvent_date,
      parentId: parentId ?? this.parentId
    );
  }

  @override
  int get hashCode {
    return description.hashCode ^
        designation.hashCode ^
        employeeName.hashCode ^
        end_shift.hashCode ^
        id.hashCode ^
        reason.hashCode ^
        start_shift.hashCode ^
        dateEvent_date.hashCode ^
        parentId.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DateEvent &&
        o.description == description &&
        o.designation == designation &&
        o.employeeName == employeeName &&
        o.end_shift == end_shift &&
        o.id == id &&
        o.reason == reason &&
        o.start_shift == start_shift &&
        o.dateEvent_date == dateEvent_date &&
        o.parentId == parentId;
  }

  @override
  String toString() {
    return 'DateEvent {description: $description, designation: $designation, employee: $employeeName, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, dateEventDate: $dateEvent_date, parentId: $parentId }';
  }

  DateEventEntity toEntity() {
    return DateEventEntity(
      description: description,
      designation: designation,
      employeeName: employeeName,
      end_shift: end_shift,
      id: id,
      reason: reason,
      start_shift: start_shift,
      dateEvent_date: dateEvent_date,
      parentId: parentId
    );
  }

  static DateEvent fromEntity(DateEventEntity entity) {
    return DateEvent(
      description: entity.description,
      designation: entity.designation,
      employeeName: entity.employeeName,
      end_shift: entity.end_shift,
      id: entity.id,
      reason: entity.reason,
      start_shift: entity.start_shift,
      dateEvent_date: entity.dateEvent_date,
      parentId: entity.parentId
    );
  }
}
