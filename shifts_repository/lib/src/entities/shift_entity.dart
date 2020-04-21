import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftEntity extends Equatable {
  final String designation;
  final String employee;
  final String end_shift;
  final int local_DB_ID;
  final Timestamp shift_date;
  final String start_shift;
  final String id;

  const ShiftEntity(
    this.designation,
    this.employee,
    this.end_shift,
    this.local_DB_ID,
    this.shift_date,
    this.start_shift,
    this.id,
  );

  @override
  Map<String,Object> toJson() {
    return {
      'designation': designation,
      'employee': employee,
      'end_shift':end_shift,
      'local_DB_ID': local_DB_ID,
      'shift_date': shift_date,
      'start_shift': start_shift,
      'id':id,
    };
  }
  
  List<Object> get props => [
        designation,
        employee,
        end_shift,
        local_DB_ID,
        shift_date,
        start_shift,
        id,
      ];

  @override
  String toString() {
    return 'ShiftEntity(designation: $designation, employee: $employee, end_shift: $end_shift, local_DB_ID: $local_DB_ID, shift_date: $shift_date, start_shift: $start_shift, id:$id)';
  }
  
  static ShiftEntity fromJson(Map<String,Object> json) {
    return ShiftEntity(
      json['designation'] as String,
      json['employee'] as String,
      json['end_shift'] as String,
      json['local_DB_ID'] as int,
      json['shift_date'] as Timestamp,
      json['start_shift'] as String,
      json['id'] as String
    );
  }

  static ShiftEntity fromSnapshot (DocumentSnapshot snap) {
    return ShiftEntity(
      snap.data['designation'],
      snap.data['employee'],
      snap.data['end_shift'],
      snap.data['local_DB_ID'],
      snap.data['shift_date'],
      snap.data['start_shift'],
      snap.documentID,
    );
  }

  Map<String,Object> toDocument() {
    return{
      'designation': designation,
      'employee': employee,
      'end_shift': end_shift,
      'local_DB_ID':local_DB_ID,
      'shift_date':shift_date,
      'start_shift':start_shift,
    };
  }
  
}
