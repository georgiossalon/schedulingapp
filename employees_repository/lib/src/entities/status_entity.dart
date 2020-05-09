
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final String description;
  final String designation;
  final String employee;
  final String end_shift;
  final String id;
  final String reason;
  final String start_shift;
  final DateTime status_date;

  const StatusEntity({
    this.description,
    this.designation,
    this.employee,
    this.end_shift,
    this.id,
    this.reason,
    this.start_shift,
    this.status_date,
  });

  // @override
  // Map<String, Object> toJson() {
  //   return {
  //     'status_date': status_date,
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
      'status_date': status_date,
      'id': id,
      'start_shift': start_shift,
      'reason': reason,
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
        status_date,
      ];

  @override
  String toString() {
    return 'StatusEntity { description: $description, designation: $designation, employee: $employee, end_shift: $end_shift, id: $id, reason: $reason, start_shift: $start_shift, statusDate: $status_date)';
  }

  static StatusEntity fromJson(Map<String, Object> json, DateTime date) {
    if (json == null) return null;

    return StatusEntity(
      designation: json['designation'] as String,
      description: json['description'] as String,
      employee: json['employee'] as String,
      end_shift: json['end_shift'] as String,
      id: json['id'] as String,
      reason: json['reason'] as String,
      start_shift: json['start_shift'] as String,
      status_date: date,
    );
  }

  static StatusEntity fromSnapshot(DocumentSnapshot snap) {
    return StatusEntity(
      designation: snap.data['designation'],
      description: snap.data['description'],
      employee: snap.data['employee'],
      end_shift: snap.data['end_shift'],
      id: snap.documentID,
      reason: snap.data['reason'],
      start_shift: snap.data['start_shift'],
      status_date: convertingFirestoreDateToDateTime(
          snap.data['status_date'] as Timestamp),
    );
  }

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }
}
