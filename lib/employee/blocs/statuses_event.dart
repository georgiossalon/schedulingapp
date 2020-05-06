import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';

abstract class StatusesEvent extends Equatable {
  const StatusesEvent();

  @override
  List<Object> get props => [];
}

class LoadStatuses extends StatusesEvent {
  final Employee employee;
  final int numOfWeeks;

  const LoadStatuses(this.employee, this.numOfWeeks);

  @override
  List<Object> get props => [employee, numOfWeeks];

  @override
  String toString() => 'LoadStatuses for employee: $employee for numOfWeeks: $numOfWeeks';
}

class AddStatus extends StatusesEvent {
  final Status status;
  final Employee employee;

  const AddStatus(this.status, this.employee);

  @override
  List<Object> get props => [status, employee];

  @override
  String toString() => 'AddStatus { status: $status for employee: $employee }';
}

class UpdateStatus extends StatusesEvent {
  final Status status;
  final Employee employee;

  const UpdateStatus(this.status, this.employee);

  @override
  List<Object> get props => [status, employee];

  @override
  String toString() => 'UpdateStatus { updateStatus: $status for employee: $employee }';
}

class RedoStatus extends StatusesEvent {
  final Status status;
  final Employee employee;

  const RedoStatus(this.status, this.employee);

  @override
  List<Object> get props => [status, employee];

  @override
  String toString() => 'RedoStatus { redoStatus: $status for employee: $employee }';
}

class DeleteStatus extends StatusesEvent {
  final Status status;
  final Employee employee;

  const DeleteStatus(this.status, this.employee);

  @override
  List<Object> get props => [status, employee];

  @override
  String toString() => 'DeleteStatus { deleteStatus: $status for employee: $employee }';
}

class StatusesesUpdated extends StatusesEvent {
  final List<Status> statuses;
  
  const StatusesesUpdated(this.statuses);

  @override
  List<Object> get props => [statuses];
}

