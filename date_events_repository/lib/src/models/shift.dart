import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Shift {
  final String designation;
  final String employee;
  final String end_shift;
  final int local_DB_ID;
  final DateTime shift_date;
  final String start_shift;
  final String id;
  Shift({
    this.designation,
    this.employee,
    this.end_shift,
    this.local_DB_ID,
    this.shift_date,
    this.start_shift,
    this.id,
  });

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }

  Shift copyWith({
    String designation,
    String employee,
    String end_shift,
    int local_DB_ID,
    DateTime shift_date,
    String start_shift,
    String id,
  }) {
    return Shift(
      designation: designation ?? this.designation,
      employee: employee ?? this.employee,
      end_shift: end_shift ?? this.end_shift,
      local_DB_ID: local_DB_ID ?? this.local_DB_ID,
      shift_date: shift_date ?? this.shift_date,
      start_shift: start_shift ?? this.start_shift,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode {
    return designation.hashCode ^
        employee.hashCode ^
        end_shift.hashCode ^
        local_DB_ID.hashCode ^
        shift_date.hashCode ^
        start_shift.hashCode ^
        id.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Shift &&
        o.designation == designation &&
        o.employee == employee &&
        o.end_shift == end_shift &&
        o.local_DB_ID == local_DB_ID &&
        o.shift_date == shift_date &&
        o.start_shift == start_shift &&
        o.id == id;
  }

  @override
  String toString() {
    return 'Shift(designation: $designation, employee: $employee, end_shift: $end_shift, local_DB_ID: $local_DB_ID, shift_date: $shift_date, start_shift: $start_shift, id: $id)';
  }

  ShiftEntity toEntity() {
    return ShiftEntity(
      designation,
      employee,
      end_shift,
      local_DB_ID,
      shift_date,
      start_shift,
      id,
    );
  }

  static Shift fromEntity (ShiftEntity entity) {
    return Shift(
      designation: entity.designation,
      employee: entity.employee,
      end_shift: entity.end_shift,
      local_DB_ID: entity.local_DB_ID,
      shift_date: entity.shift_date,
      start_shift: entity.start_shift,
      id: entity.id,
    );
  }
}
