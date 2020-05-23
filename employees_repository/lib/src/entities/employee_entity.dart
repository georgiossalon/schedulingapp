import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/entities/entities.dart';
import 'package:employees_repository/src/models/employee.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
//import 'package:date_events_repository/date_events_repository.dart';


class EmployeeEntity extends Equatable {
  final List<String> designations;
  final String email;
  final DateTime hiringDate;
  final String id;
  final String name;
  final double salary;
  final double weeklyHours;
  final Map<DateTime,String> busyMap;

  const EmployeeEntity(
      {this.designations,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.busyMap} 
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
        designations,
        email,
        hiringDate,
        id,
        name,
        salary,
        weeklyHours,
      ];

  @override
  String toString() {
    return 'EmployeeEntity(designations: $designations, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, busyMap: $busyMap)';
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
  //     // json['currentWeekDateEvent'] as Map
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

  // static List<EmployeeDateEvent> snapMapToList(var snapMap) {
  //   if (snapMap != null) {
  //     List<EmployeeDateEvent> hList = new List<EmployeeDateEvent>();
  //     snapMap.forEach((k, v) {
  //       //fixme: the dateEvent keys are of type String.
  //       //fixme... make the keys to have the same format example 2020-05-31
  //       var dateTime = DateTime.parse(k);
  //       DateTime updatedDateTime = utcTo12oclock(dateTime);
  //       EmployeeDateEvent dateEvent =
  //           EmployeeDateEvent.fromEntity(EmployeeDateEventEntity.fromJson(v, updatedDateTime));
  //       hList.add(dateEvent);
  //     });
  //     return hList;
  //   }
  // }

  // static Map dateEventListToMap(List<EmployeeDateEvent> currentWeekDateEvent) {
  //   if (currentWeekDateEvent != null) {
  //     Map<String, Map<String, String>> hMap =
  //         new Map<String, Map<String, String>>();
  //     for (EmployeeDateEvent dateEvent in currentWeekDateEvent) {
  //       Map<String, String> hhMap = new Map<String, String>();
  //       hhMap['start_shift'] = dateEvent.start_shift;
  //       hhMap['end_shift'] = dateEvent.end_shift;
  //       hhMap['reason'] = dateEvent.reason;
  //       hhMap['description'] = dateEvent.description;
  //       // Firestore keys (map) have to be of type String
  //       // key: date ->
  //       // val: Map (keys: start_shift, end_shift, reason, description)
  //       var formatter = new DateFormat('yyyy-MM-dd');
  //       String formatedDate = formatter.format(dateEvent.dateEvent_date);
  //       // connecting the dateEvent details with the date
  //       hMap[formatedDate] = hhMap;
  //     }
  //     return hMap;
  //   }
  // }

  static Map<String, String> changeMapKeyForDocument(Map<DateTime, String> busyMap) {
    if (busyMap != null) {
      Map<String, String> hMap = new Map<String,String>();
      busyMap.forEach((k, v) {
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatedDate = formatter.format(k);
        hMap[formatedDate] = v;
      });
      return hMap;
    }
  }

  static Map<DateTime, String> changeMapKeyForObject(Map<String,dynamic> snapMap) {
    if (snapMap != null) {
      Map<DateTime, String> hMap = new Map<DateTime,String>();
      snapMap.forEach((k,v) {
         var dateTime = DateTime.parse(k);
        DateTime updatedDateTime = utcTo12oclock(dateTime);
        hMap[updatedDateTime] = v;
      });
      return hMap;
    }
  }

  static EmployeeEntity fromSnapshot(DocumentSnapshot snap) {

    return EmployeeEntity(
        designations: List.from(snap.data['designations']),
        email: snap.data['email'],
        hiringDate:
            Employee.convertingFirestoreDateToDateTime(snap.data['hiringDate']),
        id: snap.documentID,
        name: snap.data['name'],
        salary: snap.data['salary'],
        weeklyHours: snap.data['weeklyHours'],
        busyMap: changeMapKeyForObject(snap.data['busy_map']) 
        );
  }

  Map<String, Object> toDocument() {
    return {
      'designations': designations,
      'email': email,
      'hiringDate': hiringDate,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
      'busy_map': changeMapKeyForDocument(busyMap),
    };
  }
}
