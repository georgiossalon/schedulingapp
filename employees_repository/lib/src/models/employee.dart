import 'package:cloud_firestore/cloud_firestore.dart';
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
  Employee(
      {this.designation,
      this.email,
      this.hiringDate,
      this.id,
      this.name,
      this.salary,
      this.weeklyHours});

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
      double weeklyHours}) {
    return Employee(
      designation: designation ?? this.designation,
      email: email ?? this.email,
      hiringDate: hiringDate ?? this.hiringDate,
      id: id ?? this.id,
      name: name ?? this.name,
      salary: salary ?? this.salary,
      weeklyHours: weeklyHours ?? this.weeklyHours,
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
        weeklyHours.hashCode;
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
        o.weeklyHours == weeklyHours;
  }

  @override
  String toString() {
    return 'Employee(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours)';
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
        designation, email, hiringDate, id, name, salary, weeklyHours);
  }

  static Employee fromEntity(EmployeeEntity entity) {
    return Employee(
        designation: entity.designation,
        email: entity.email,
        hiringDate: entity.hiringDate,
        id: entity.id,
        name: entity.name,
        salary: entity.salary,
        weeklyHours: entity.weeklyHours);
  }
}
