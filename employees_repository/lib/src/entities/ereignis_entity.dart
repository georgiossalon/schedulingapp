
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EreignisEntity extends Equatable {
  final String description;
  final String designation;
  final String employee;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime ereignis_date;
  final String parentId;

  const EreignisEntity({
    this.description,
    this.designation,
    this.employee,
    this.end_shift,
    this.id,
    this.reason,
    this.start_shift,
    this.ereignis_date,
    this.parentId
  });

  // @override
  // Map<String, Object> toJson() {
  //   return {
  //     'ereignis_date': ereignis_date,
  //     'start_shift': start_shift,
  //     'end_shift': end_shift,
  //     'reason': reason,
  //     'description': description,
  //     'id': id,
  //   };
  // }

  //todo implement two methods one for a shift and one for DayOff
  //! be careful! I do not know if the group querry is going to work then
  //! since some fields are going to be missing

  Map<String, Object> toDocument() {
    return {
      'description': description,
      'designation': designation,
      'employee': employee,
      'end_shift': end_shift,
      'ereignis_date': ereignis_date,
      'start_shift': start_shift,
      'reason': reason,
      'parent_id': parentId,
    };
  }

  List<Object> get props => [
        description,
        designation,
        employee,
        end_shift,
        id,
        reason,
        start_shift,
        ereignis_date,
        parentId
      ];

  @override
  String toString() {
    return 'EreignisEntity { description: $description, designation: $designation, employee: $employee, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, ereignisDate: $ereignis_date, parentId: $parentId)';
  }

  static EreignisEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;

    return EreignisEntity(
      designation: json['designation'] as String,
      description: json['description'] as String,
      employee: json['employee'] as String,
      end_shift: json['end_shift'] as String,
      id: json['id'] as String,
      reason: json['reason'] as String,
      start_shift: json['start_shift'] as String,
      ereignis_date: date,
      parentId: json['parend_id'] as String,
    );
  }

  static EreignisEntity fromSnapshot(DocumentSnapshot snap) {
    return EreignisEntity(
      designation: snap.data['designation'],
      description: snap.data['description'],
      employee: snap.data['employee'],
      end_shift: snap.data['end_shift'],
      id: snap.documentID,
      reason: snap.data['reason'],
      start_shift: snap.data['start_shift'],
      ereignis_date: convertingFirestoreDateToDateTime(
          snap.data['ereignis_date'] as Timestamp),
      parentId: snap.data['parent_id']
    );
  }

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }
}
