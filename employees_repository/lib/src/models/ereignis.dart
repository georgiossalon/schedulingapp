import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Ereignis {
  final String description;
  final String designation;
  final String employeeName;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime ereignis_date;
  final String parentId;

  Ereignis({
    this.description,
    this.designation,
    this.employeeName,
    this.end_shift,
    this.id,
    this.reason,
    this.start_shift,
    this.ereignis_date,
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

  Ereignis copyWith({
    String description,
    String designation,
    String employeeName,
    String end_shift,
    String id,
    String reason,
    String start_shift,
    DateTime ereignis_date,
    String parentId,
  }) {
    return Ereignis(
      description: description ?? this.description,
      designation: designation ?? this.designation,
      employeeName: employeeName ?? this.employeeName,
      end_shift: end_shift ?? this.end_shift,
      id: id ?? this.id,
      reason: reason ?? this.reason,
      start_shift: start_shift ?? this.start_shift,
      ereignis_date: ereignis_date ?? this.ereignis_date,
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
        ereignis_date.hashCode ^
        parentId.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Ereignis &&
        o.description == description &&
        o.designation == designation &&
        o.employeeName == employeeName &&
        o.end_shift == end_shift &&
        o.id == id &&
        o.reason == reason &&
        o.start_shift == start_shift &&
        o.ereignis_date == ereignis_date &&
        o.parentId == parentId;
  }

  @override
  String toString() {
    return 'Ereignis {description: $description, designation: $designation, employee: $employeeName, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, ereignisDate: $ereignis_date, parentId: $parentId }';
  }

  EreignisEntity toEntity() {
    return EreignisEntity(
      description: description,
      designation: designation,
      employeeName: employeeName,
      end_shift: end_shift,
      id: id,
      reason: reason,
      start_shift: start_shift,
      ereignis_date: ereignis_date,
      parentId: parentId
    );
  }

  static Ereignis fromEntity(EreignisEntity entity) {
    return Ereignis(
      description: entity.description,
      designation: entity.designation,
      employeeName: entity.employeeName,
      end_shift: entity.end_shift,
      id: entity.id,
      reason: entity.reason,
      start_shift: entity.start_shift,
      ereignis_date: entity.ereignis_date,
      parentId: entity.parentId
    );
  }
}
