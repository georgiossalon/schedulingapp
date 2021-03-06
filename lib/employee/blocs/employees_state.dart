import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

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

class EmployeesLoadedWithGivenDesignation extends EmployeesState {
  final List<Employee> employees;

  const EmployeesLoadedWithGivenDesignation([this.employees = const[]]);

  @override
  List<Object> get props => [employees];

  @override
  String toString() => 'EmployeesLoaded {employees: $employees }';
}

class EmployeesNotLoaded extends EmployeesState {}
