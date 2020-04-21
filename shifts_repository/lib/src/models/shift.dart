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
  final String firestore_id;
  Shift({
    this.designation,
    this.employee,
    this.end_shift,
    this.local_DB_ID,
    this.shift_date,
    this.start_shift,
    this.firestore_id,
  });

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }
  // Shift(
  //   this.designation,
  //   this.employee,
  //   this.end_shift,
  //   this.local_DB_ID,
  //   this.shift_date,
  //   this.start_shift,
  //   this.id,
  // );
  // Shift copyWith({
  //   String designation,
  //   String employee,
  //   String end_shift,
  //   String local_DB_ID,
  //   String shift_date,
  //   String start_shift,
  //   String id,
  // }) {
  //   return Shift(
  //     designation ?? this.designation,
  //     employee ?? this.employee,
  //     end_shift ?? this.end_shift,
  //     local_DB_ID ?? this.local_DB_ID,
  //     shift_date ?? this.shift_date,
  //     start_shift ?? this.start_shift,
  //     id ?? this.id,
  //   );
  // }

  // @override
  // int get hashCode =>
  //   designation.hashCode ^ employee.hashCode ^ end_shift.hashCode ^ local_DB_ID.hashCode ^ shift_date.hashCode ^ start_shift.hashCode ^ id.hashCode;

  Shift copyWith({
    String designation,
    String employee,
    String end_shift,
    int local_DB_ID,
    String shift_date,
    String start_shift,
    String firestore_id,
  }) {
    return Shift(
      designation: designation ?? this.designation,
      employee: employee ?? this.employee,
      end_shift: end_shift ?? this.end_shift,
      local_DB_ID: local_DB_ID ?? this.local_DB_ID,
      shift_date: shift_date ?? this.shift_date,
      start_shift: start_shift ?? this.start_shift,
      firestore_id: firestore_id ?? this.firestore_id,
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
        firestore_id.hashCode;
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
        o.firestore_id == firestore_id;
  }

  @override
  String toString() {
    return 'Shift(designation: $designation, employee: $employee, end_shift: $end_shift, local_DB_ID: $local_DB_ID, shift_date: $shift_date, start_shift: $start_shift, id: $firestore_id)';
  }

  ShiftEntity toEntity() {
    return ShiftEntity(
      designation,
      employee,
      end_shift,
      local_DB_ID,
      shift_date,
      start_shift,
      firestore_id,
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
      firestore_id: entity.firestore_id,
    );
  }
}
