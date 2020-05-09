import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';

abstract class StatusesEvent extends Equatable {
  const StatusesEvent();

  @override
  List<Object> get props => [];
}

class LoadAllStatusesForEmployeeForXWeeks extends StatusesEvent {
  final String employeeId;
  final int numOfWeeks;

  const LoadAllStatusesForEmployeeForXWeeks(this.employeeId, this.numOfWeeks);

  @override
  List<Object> get props => [employeeId, numOfWeeks];

  @override
  String toString() => 'LoadStatuses for employeeId: $employeeId for numOfWeeks: $numOfWeeks';
}

class LoadAllShiftsForXWeeks extends StatusesEvent {
  final int numOfWeeks;

  const LoadAllShiftsForXWeeks(this.numOfWeeks);

  @override
  List<Object> get props => [numOfWeeks];

  @override
  String toString() => 'LoadAllShifts for numOfWeeks: $numOfWeeks';
}

class AddStatus extends StatusesEvent {
  final Status status;
  final String employeeId;
  // I can still assign shifts to the "employee" 'Open'

  const AddStatus(this.status, this.employeeId);

  @override
  List<Object> get props => [status, employeeId];

  @override
  String toString() => 'AddStatus { status: $status for employeeId: $employeeId }';
}

class UpdateStatus extends StatusesEvent {
  final Status status;
  final String employeeId;

  const UpdateStatus(this.status, this.employeeId);

  @override
  List<Object> get props => [status, employeeId];

  @override
  String toString() => 'UpdateStatus { updateStatus: $status for employeeId: $employeeId }';
}

class RedoStatus extends StatusesEvent {
  final Status status;
  final String employeeId;

  const RedoStatus(this.status, this.employeeId);

  @override
  List<Object> get props => [status, employeeId];

  @override
  String toString() => 'RedoStatus { redoStatus: $status for employeeId: $employeeId }';
}

class DeleteStatus extends StatusesEvent {
  final Status status;
  final String employeeId;

  const DeleteStatus(this.status, this.employeeId);

  @override
  List<Object> get props => [status, employeeId];

  @override
  String toString() => 'DeleteStatus { deleteStatus: $status for employeeId: $employeeId }';
}

class StatusesUpdated extends StatusesEvent {
  final List<Status> statuses;
  
  const StatusesUpdated(this.statuses);

  @override
  List<Object> get props => [statuses];
}

class ShiftStatusesUpdated extends StatusesEvent {
  final List<Status> statuses;
  
  const ShiftStatusesUpdated(this.statuses);

  @override
  List<Object> get props => [statuses];
}

