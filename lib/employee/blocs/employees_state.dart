import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;

  const EmployeesLoaded([this.employees = const[]]);

  @override
  List<Object> get props => [employees];

  @override
  String toString() => 'EmployeesLoaded {employees: $employees }';
}

class EmployeesNotLoaded extends EmployeesState {}
