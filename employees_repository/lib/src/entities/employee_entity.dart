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
  final List<Status> currentWeekStatus;

  const EmployeeEntity(
      this.designation,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.currentWeekStatus //todo map the parameters
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
    return 'EmployeeEntity(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, currentWeekStatus: $currentWeekStatus)';
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

  static DateTime utcTo12oclock(DateTime dateTimeToChange) {
    if (dateTimeToChange != null) {
      DateTime dateOfEvent = dateTimeToChange.toLocal();
      /*each device has a different utc. The table_calendar gives back
    everything as utc. Thus I have to find a way to edit everything to 12 o'clock*/
      return new DateTime(
          dateOfEvent.year, dateOfEvent.month, dateOfEvent.day, 12);
    }
  }

  static List<Status> snapMapToList(var snapMap) {
    if (snapMap != null) {
      List<Status> hList = new List<Status>();
      snapMap.forEach((k, v) {
        //fixme: the status keys are of type String.
        //fixme... make the keys to have the same format example 2020-05-31
        var dateTime = DateTime.parse(k);
        DateTime updatedDateTime = utcTo12oclock(dateTime);
        Status status = Status.fromEntity(
            StatusEntity.fromJson(v, updatedDateTime));
        hList.add(status);
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
            'currentWeekStatus']) // converting the Firebase Map to a List<status>
        );
  }

  static Map statusListToMap(
      List<Status> currentWeekStatus) {
    if (currentWeekStatus != null) {
      Map<String, Map<String, String>> hMap =
          new Map<String, Map<String, String>>();
      for (Status status in currentWeekStatus) {
        Map<String, String> hhMap = new Map<String, String>();
        hhMap['start_shift'] = status.start_shift;
        hhMap['end_shift'] = status.end_shift;
        hhMap['reason'] = status.reason;
        hhMap['description'] = status.description;
        // Firestore keys (map) have to be of type String
        // key: date ->
        // val: Map (keys: start_shift, end_shift, reason, description)
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatedDate =
            formatter.format(status.statusDate);
        // connecting the status details with the date
        hMap[formatedDate] = hhMap;
      }
      return hMap;
    }
  }

  Map<String, Object> toDocument() {
    return {
      'designation': designation,
      'email': email,
      'hiringDate': hiringDate,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
      'currentWeekStatus':
          statusListToMap(currentWeekStatus),
    };
  }
}
