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
  final Map<DateTime, bool> busyMap;

  const EmployeeEntity(
      {this.designation,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.busyMap} //todo map the parameters
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
    return 'EmployeeEntity(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, busyMap: $busyMap)';
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
  //     // json['currentWeekEreignis'] as Map
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

  static List<Ereignis> snapMapToList(var snapMap) {
    if (snapMap != null) {
      List<Ereignis> hList = new List<Ereignis>();
      snapMap.forEach((k, v) {
        //fixme: the ereignis keys are of type String.
        //fixme... make the keys to have the same format example 2020-05-31
        var dateTime = DateTime.parse(k);
        DateTime updatedDateTime = utcTo12oclock(dateTime);
        Ereignis ereignis =
            Ereignis.fromEntity(EreignisEntity.fromJson(v, updatedDateTime));
        hList.add(ereignis);
      });
      return hList;
    }
  }

  static Map ereignisListToMap(List<Ereignis> currentWeekEreignis) {
    if (currentWeekEreignis != null) {
      Map<String, Map<String, String>> hMap =
          new Map<String, Map<String, String>>();
      for (Ereignis ereignis in currentWeekEreignis) {
        Map<String, String> hhMap = new Map<String, String>();
        hhMap['start_shift'] = ereignis.start_shift;
        hhMap['end_shift'] = ereignis.end_shift;
        hhMap['reason'] = ereignis.reason;
        hhMap['description'] = ereignis.description;
        // Firestore keys (map) have to be of type String
        // key: date ->
        // val: Map (keys: start_shift, end_shift, reason, description)
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatedDate = formatter.format(ereignis.ereignis_date);
        // connecting the ereignis details with the date
        hMap[formatedDate] = hhMap;
      }
      return hMap;
    }
  }

  Map<String, bool> changeMapKeyForDocument(Map<DateTime, bool> busyMap) {
    if (busyMap != null) {
      Map<String, bool> hMap = new Map<String, bool>();
      busyMap.forEach((k, v) {
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatedDate = formatter.format(k);
        hMap[formatedDate] = v;
      });
      return hMap;
    }
  }

  static Map<DateTime, bool> changeMapKeyForObject(Map<String,dynamic> snapMap) {
    if (snapMap != null) {
      Map<DateTime, bool> hMap = new Map<DateTime,bool>();
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
        designation: snap.data['designation'],
        email: snap.data['email'],
        hiringDate:
            Employee.convertingFirestoreDateToDateTime(snap.data['hiringDate']),
        id: snap.documentID,
        name: snap.data['name'],
        salary: snap.data['salary'],
        weeklyHours: snap.data['weeklyHours'],
        busyMap: changeMapKeyForObject(snap.data['busy_map']) //todo probably have to transform the keys String to DateTime
        );
  }

  Map<String, Object> toDocument() {
    return {
      'designation': designation,
      'email': email,
      'hiringDate': hiringDate,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
      'busy_map': changeMapKeyForDocument(busyMap),
    };
  }
}
