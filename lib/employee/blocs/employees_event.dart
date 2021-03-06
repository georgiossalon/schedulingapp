import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';

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

class UpdateEmployee extends EmployeesEvent {
  final Employee updatedEmployee;

  const UpdateEmployee(this.updatedEmployee);

  @override
  List<Object> get props => [updatedEmployee];

  @override
  String toString() => 'UpdateEmployee { updatedEmployee: $updatedEmployee }';
}

class UpdateEmployeeBusyMap extends EmployeesEvent {
  final EmployeeDateEvent employeeDateEvent;
  final Employee oldEmployee;

  const UpdateEmployeeBusyMap({
    @required this.employeeDateEvent,
    this.oldEmployee,
  });

  @override
  List<Object> get props => [employeeDateEvent, oldEmployee];

  @override
  String toString() =>
      'UpdateEmployeeBusyMap { employeeDateEvent: $employeeDateEvent, oldEmployee: $oldEmployee}';
}

class EmployeesBusyMapDateEventRemoved extends EmployeesEvent {
  final Employee oldEmployee;
  final String currentEmployeeId;
  final String oldEmployeeName;
  final DateTime dateTime;

  EmployeesBusyMapDateEventRemoved({
    @required this.oldEmployee,
    this.oldEmployeeName,
    this.currentEmployeeId,
    @required this.dateTime,
  });

  @override
  List<Object> get props =>
      [oldEmployee, oldEmployeeName, currentEmployeeId, dateTime];

  @override
  String toString() {
    return 'EmployeesBusyMapDateEventRemoved: { oldEmployee: $oldEmployee, oldEmployeeName: $oldEmployeeName, currentEmployeeId: $currentEmployeeId, dateTime: $dateTime }';
  }
}

class RedoEmployee extends EmployeesEvent {
  final Employee redoneEmployee;

  const RedoEmployee(this.redoneEmployee);

  @override
  List<Object> get props => [redoneEmployee];

  @override
  String toString() => 'RedoEmployee { redoneEmployee: $redoneEmployee }';
}

class DeleteEmployee extends EmployeesEvent {
  final Employee employee;

  const DeleteEmployee(this.employee);

  @override
  List<Object> get props => [employee];

  @override
  String toString() => 'DeleteEmployee { employee: $employee }';
}

class EmployeesUpdated extends EmployeesEvent {
  final List<Employee> employees;

  const EmployeesUpdated(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeesUpdatedWithGivenDesignation extends EmployeesEvent {
  final List<Employee> employees;

  const EmployeesUpdatedWithGivenDesignation(this.employees);

  @override
  List<Object> get props => [employees];
}

class LoadEmployeesWithGivenDesignation extends EmployeesEvent {
  final String designation;
  final DateTime date;

  const LoadEmployeesWithGivenDesignation({this.designation, this.date});

  @override
  List<Object> get props => [designation, date];
}

class EmployeesEmpty extends EmployeesEvent {}
