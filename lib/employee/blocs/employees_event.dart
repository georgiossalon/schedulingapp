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

  const UpdateEmployeeBusyMap({this.employeeDateEvent});

  @override
  List<Object> get props => [employeeDateEvent];

  @override
  String toString() =>
      'UpdateEmployeeBusyMap { employeeDateEvent: $employeeDateEvent}';
}

class EmployeesBusyMapDateEventRemoved extends EmployeesEvent {
  final String oldEmployeeId;
  final DateTime dateTime;

  EmployeesBusyMapDateEventRemoved({
    @required this.oldEmployeeId,
    @required this.dateTime,
  });

  @override
  List<Object> get props => [oldEmployeeId, dateTime];

  @override
  String toString() {
    return 'EmployeesBusyMapDateEventRemoved: { oldEmployeeId: $oldEmployeeId, dateTime: $dateTime }';
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
