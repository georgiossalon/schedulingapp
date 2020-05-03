import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/entities/entities.dart';
import 'package:employees_repository/src/models/employee.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class EmployeeEntity extends Equatable {
  final String designation;
  final String email;
  final DateTime hiringDate;
  final String id;
  final String name;
  final double salary;
  final double weeklyHours;
  final List<Unavailability> currentWeekUnavailability;

  const EmployeeEntity(
      this.designation,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.currentWeekUnavailability //todo map the parameters
      );

  // @override
  // Map<String,Object> toJson() {
  //   return {
  //     'designation': designation,
  //     'email': email,
  //     'hiringDate': hiringDate,
  //     'id': id,
  //     'name': name,
  //     'salary': salary,
  //     'weeklyHours': weeklyHours,
  //   };
  // }

  List<Object> get props => [
        designation,
        email,
        hiringDate,
        id,
        name,
        salary,
        weeklyHours,
      ];

  @override
  String toString() {
    return 'EmployeeEntity(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, currentWeekUnavailability: $currentWeekUnavailability)';
  }

  // static EmployeeEntity fromJson(Map<String,Object> json) {
  //   return EmployeeEntity(
  //     json['designation'] as String,
  //     json['email'] as String,
  //     Employee.convertingFirestoreDateToDateTime(['hiringDate'] as Timestamp),
  //     json['id'] as String,
  //     json['name'] as String,
  //     json['salary'] as double,
  //     json['weeklyHours'] as double,
  //     // json['currentWeekUnavailability'] as Map
  //   );
  // }

  static List<Unavailability> snapMapToList(var snapMap) {
    if (snapMap != null) {
      List<Unavailability> hList = new List<Unavailability>();
      snapMap.forEach((k, v) {
        //fixme: the unavailability keys are of type String.
        //fixme... make the keys to have the same format example 2020-05-31
        var dateTime = DateTime.parse(k);
        Unavailability unavailability = Unavailability.fromEntity(
            UnavailabilityEntity.fromJson(v, dateTime));
        hList.add(unavailability);
      });
      return hList;
    }
  }

  static EmployeeEntity fromSnapshot(DocumentSnapshot snap) {
    return EmployeeEntity(
        snap.data['designation'],
        snap.data['email'],
        Employee.convertingFirestoreDateToDateTime(snap.data['hiringDate']),
        snap.documentID,
        snap.data['name'],
        snap.data['salary'],
        snap.data['weeklyHours'],
        snapMapToList(snap.data[
            'currentWeekUnavailability']) // converting the Firebase Map to a List<Unavailability>
        );
  }

  Map unavailabilityListToMap (List<Unavailability> currentWeekUnavailability) {
    Map<String, Map<String,String>> hMap = new Map<String, Map<String,String>>();
    for (Unavailability unavailability in currentWeekUnavailability) {
      Map<String,String> hhMap = new Map<String,String>();
      hhMap['start_shift'] = unavailability.start_shift;
      hhMap['end_shift'] = unavailability.end_shift;
      hhMap['reason'] = unavailability.reason;
      hhMap['description'] = unavailability.description;
      // Firestore keys (map) have to be of type String
      // key: date -> 
      // val: Map (keys: start_shift, end_shift, reason, description)
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatedDate = formatter.format(unavailability.unavailabilityDate);
      // connecting the unavailability details with the date
      hMap[formatedDate] = hhMap;
    }
    return hMap;
  }

  Map<String, Object> toDocument() {
    return {
      'designation': designation,
      'email': email,
      'hiringDate': hiringDate,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
      'currentWeekUnavailability':
          unavailabilityListToMap(currentWeekUnavailability),
    };
  }
}
