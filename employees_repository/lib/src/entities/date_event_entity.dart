
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DateEventEntity extends Equatable {
  final String description;
  final String designation;
  final String employeeName;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime dateEvent_date;
  final String parentId;

  const DateEventEntity({
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

  // @override
  // Map<String, Object> toJson() {
  //   return {
  //     'dateEvent_date': dateEvent_date,
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
      'employee_name': employeeName,
      'end_shift': end_shift,
      'dateEvent_date': dateEvent_date,
      'start_shift': start_shift,
      'reason': reason,
      'parent_id': parentId,
    };
  }

  List<Object> get props => [
        description,
        designation,
        employeeName,
        end_shift,
        id,
        reason,
        start_shift,
        dateEvent_date,
        parentId
      ];

  @override
  String toString() {
    return 'DateEventEntity { description: $description, designation: $designation, employee: $employeeName, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, dateEventDate: $dateEvent_date, parentId: $parentId)';
  }

  static DateEventEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;

    return DateEventEntity(
      designation: json['designation'] as String,
      description: json['description'] as String,
      employeeName: json['employee_name'] as String,
      end_shift: json['end_shift'] as String,
      id: json['id'] as String,
      reason: json['reason'] as String,
      start_shift: json['start_shift'] as String,
      dateEvent_date: date,
      parentId: json['parend_id'] as String,
    );
  }

  static DateEventEntity fromSnapshot(DocumentSnapshot snap) {
    return DateEventEntity(
      designation: snap.data['designation'],
      description: snap.data['description'],
      employeeName: snap.data['employee_name'],
      end_shift: snap.data['end_shift'],
      id: snap.documentID,
      reason: snap.data['reason'],
      start_shift: snap.data['start_shift'],
      dateEvent_date: convertingFirestoreDateToDateTime(
          snap.data['dateEvent_date'] as Timestamp),
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
