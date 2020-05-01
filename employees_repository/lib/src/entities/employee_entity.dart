import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/models/employee.dart';
import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final String designation;
  final String email;
  final DateTime hiringDate;
  final String id;
  final String name;
  final double salary;
  final double weeklyHours;

  const EmployeeEntity(
    this.designation,
    this.email,
    this.hiringDate,
    this.id,
    this.name,
    this.salary,
    this.weeklyHours,
  );

  @override
  Map<String,Object> toJson() {
    return {
      'designation': designation,
      'email': email,
      'hiringDate': hiringDate,
      'id': id,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
    };
  } 
    
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
    return 'EmployeeEntity(designation: $designation, email: $email, hiringDate: $hiringDate, id: $id, name: $name, salary: $salary, weeklyHours: $weeklyHours)';
  }

  static EmployeeEntity fromJson(Map<String,Object> json) {
    return EmployeeEntity(
      json['designation'] as String,
      json['email'] as String,
      Employee.convertingFirestoreDateToDateTime(['hiringDate'] as Timestamp),
      json['id'] as String,
      json['name'] as String,
      json['salary'] as double,
      json['weeklyHours'] as double,
    );
  }

  static EmployeeEntity fromSnapshot (DocumentSnapshot snap) {
    return EmployeeEntity(
      snap.data['designation'],
      snap.data['email'],
      Employee.convertingFirestoreDateToDateTime(snap.data['hiringDate']),
      snap.documentID,
      snap.data['name'],
      snap.data['salary'],
      snap.data['weeklyHours'],
    );
  }

  Map<String,Object> toDocument() {
    return {
      'designation': designation,
      'email': email,
      'hiringDate': hiringDate,
      'name': name,
      'salary': salary,
      'weeklyHours': weeklyHours,
    };
  }
  
}
