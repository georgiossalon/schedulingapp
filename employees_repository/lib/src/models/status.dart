import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Status {
  final String description;
  final String designation;
  final String employee;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime status_date;

  Status({
    this.description,
    this.designation,
    this.employee,
    this.end_shift,
    this.id,
    this.reason,
    this.start_shift,
    this.status_date,
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
    String description,
    String designation,
    String employee,
    String end_shift,
    String id,
    String reason,
    String start_shift,
    DateTime status_date,
  }) {
    return Status(
      description: description ?? this.description,
      designation: designation ?? this.designation,
      employee: employee ?? this.employee,
      end_shift: end_shift ?? this.end_shift,
      id: id ?? this.id,
      reason: reason ?? this.reason,
      start_shift: start_shift ?? this.start_shift,
      status_date: status_date ?? this.status_date,
    );
  }

  @override
  int get hashCode {
    return description.hashCode ^
        designation.hashCode ^
        employee.hashCode ^
        end_shift.hashCode ^
        id.hashCode ^
        reason.hashCode ^
        start_shift.hashCode ^
        status_date.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Status &&
        o.description == description &&
        o.designation == designation &&
        o.employee == employee &&
        o.end_shift == end_shift &&
        o.id == id &&
        o.reason == reason &&
        o.start_shift == start_shift &&
        o.status_date == status_date;
  }

  @override
  String toString() {
    return 'Status {description: $description, designation: $designation, employee: $employee, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, statusDate: $status_date }';
  }

  StatusEntity toEntity() {
    return StatusEntity(
      description: description,
      designation: designation,
      employee: employee,
      end_shift: end_shift,
      id: id,
      reason: reason,
      start_shift: start_shift,
      status_date: status_date,
    );
  }

  static Status fromEntity(StatusEntity entity) {
    return Status(
      description: entity.description,
      designation: entity.designation,
      employee: entity.employee,
      end_shift: entity.end_shift,
      id: entity.id,
      reason: entity.reason,
      start_shift: entity.start_shift,
      status_date: entity.status_date,
    );
  }
}
