import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Employee {
  final List<String> designations;
  final String email;
  final DateTime hiringDate;
  final String id;
  final String name;
  final double salary;
  final double weeklyHours;
  final Map<DateTime,bool> busyMap;
  Employee(
      {this.designations,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.busyMap});

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    if (timestamp != null) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
    }
  }

  Employee copyWith(
      {List<String> designations,
      String email,
      DateTime hiringDate,
      int id,
      String name,
      double salary,
      double weeklyHours,
      List<DateEvent> currentWeekDateEvent}) {
    return Employee(
      designations: designations ?? this.designations,
      email: email ?? this.email,
      hiringDate: hiringDate ?? this.hiringDate,
      id: id ?? this.id,
      name: name ?? this.name,
      salary: salary ?? this.salary,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      busyMap: currentWeekDateEvent ?? this.busyMap
    );
  }

  @override
  int get hashCode {
    return designations.hashCode ^
        email.hashCode ^
        hiringDate.hashCode ^
        id.hashCode ^
        name.hashCode ^
        salary.hashCode ^
        weeklyHours.hashCode ^
        busyMap.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Employee &&
        o.designations == designations &&
        o.email == email &&
        o.hiringDate == hiringDate &&
        o.id == id &&
        o.name == name &&
        o.salary == salary &&
        o.weeklyHours == weeklyHours &&
        o.busyMap == busyMap;
  }

  @override
  String toString() {
    return 'Employee ( designations: $designations, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, currentWeekDateEvent: $busyMap)';
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
        designations:designations, 
        email: email,
        hiringDate: hiringDate, 
        id: id, 
        name: name, 
        salary: salary,
        weeklyHours: weeklyHours,
        busyMap: busyMap);
  }

  static Employee fromEntity(EmployeeEntity entity) {
    return Employee(
        designations: entity.designations,
        email: entity.email,
        hiringDate: entity.hiringDate,
        id: entity.id,
        name: entity.name,
        salary: entity.salary,
        weeklyHours: entity.weeklyHours,
        busyMap: entity.busyMap);
  }
}
