import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeesEvent {}

class AddEmployee extends EmployeesEvent {
  final Employee employee;

  const AddEmployee(this.employee);

  @override
  List<Object> get props => [employee];

  @override
  String toString() => 'AddEmployee(employee: $employee)';
}




