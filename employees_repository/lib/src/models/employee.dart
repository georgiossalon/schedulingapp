import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Employee {
  final String designation;
  final String email;
  final DateTime hiringDate;
  final String id;
  final String name;
  final double salary;
  final double weeklyHours;
  final List<Status> currentWeekUnavailability;
  Employee(
      {this.designation,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours,
      this.currentWeekUnavailability});

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    if (timestamp != null) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
    }
  }

  Employee copyWith(
      {String designation,
      String email,
      DateTime hiringDate,
      int id,
      String name,
      double salary,
      double weeklyHours,
      List<Status> currentWeekUnavailability}) {
    return Employee(
      designation: designation ?? this.designation,
      email: email ?? this.email,
      hiringDate: hiringDate ?? this.hiringDate,
      id: id ?? this.id,
      name: name ?? this.name,
      salary: salary ?? this.salary,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      currentWeekUnavailability: currentWeekUnavailability ?? this.currentWeekUnavailability
    );
  }

  @override
  int get hashCode {
    return designation.hashCode ^
        email.hashCode ^
        hiringDate.hashCode ^
        id.hashCode ^
        name.hashCode ^
        salary.hashCode ^
        weeklyHours.hashCode ^
        currentWeekUnavailability.hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Employee &&
        o.designation == designation &&
        o.email == email &&
        o.hiringDate == hiringDate &&
        o.id == id &&
        o.name == name &&
        o.salary == salary &&
        o.weeklyHours == weeklyHours &&
        o.currentWeekUnavailability == currentWeekUnavailability;
  }

  @override
  String toString() {
    return 'Employee(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours, currentWeekUnavailability: $currentWeekUnavailability)';
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
        designation, email, hiringDate, id, name, salary, weeklyHours,currentWeekUnavailability);
  }

  static Employee fromEntity(EmployeeEntity entity) {
    return Employee(
        designation: entity.designation,
        email: entity.email,
        hiringDate: entity.hiringDate,
        id: entity.id,
        name: entity.name,
        salary: entity.salary,
        weeklyHours: entity.weeklyHours,
        currentWeekUnavailability: entity.currentWeekStatus);
  }
}
