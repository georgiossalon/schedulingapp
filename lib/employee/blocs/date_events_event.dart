import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/date_events.dart';

abstract class DateEventsEvent extends Equatable {
  const DateEventsEvent();

  @override
  List<Object> get props => [];
}

class LoadAllDateEventsForEmployeeForXWeeks extends DateEventsEvent {
  final String employeeId;
  final int numOfWeeks;

  const LoadAllDateEventsForEmployeeForXWeeks(this.employeeId, this.numOfWeeks);

  @override
  List<Object> get props => [employeeId, numOfWeeks];

  @override
  String toString() => 'LoadDateEvents for employeeId: $employeeId for numOfWeeks: $numOfWeeks';
}

class LoadAllShiftsForXWeeks extends DateEventsEvent {
  final int numOfWeeks;

  const LoadAllShiftsForXWeeks(this.numOfWeeks);

  @override
  List<Object> get props => [numOfWeeks];

  @override
  String toString() => 'LoadAllShifts for numOfWeeks: $numOfWeeks';
}

class AddDateEvent extends DateEventsEvent {
  final DateEvent dateEvent;
  // I can still assign shifts to the "employee" 'Open'

  const AddDateEvent(this.dateEvent);

  @override
  List<Object> get props => [dateEvent];

  @override
  String toString() => 'AddDateEvent { dateEvent: $dateEvent for parentId: ${dateEvent.parentId} }';
}

class UpdateDateEvent extends DateEventsEvent {
  final DateEvent dateEvent;

  const UpdateDateEvent(this.dateEvent);

  @override
  List<Object> get props => [dateEvent];

  @override
  String toString() => 'UpdateDateEvent { updateDateEvent: $dateEvent for parentId: ${dateEvent.parentId} }';
}

class RedoDateEvent extends DateEventsEvent {
  final DateEvent dateEvent;

  const RedoDateEvent(this.dateEvent);

  @override
  List<Object> get props => [dateEvent];

  @override
  String toString() => 'RedoDateEvent { redoDateEvent: $dateEvent for parentId: ${dateEvent.parentId} }';
}

class DeleteDateEvent extends DateEventsEvent {
  final DateEvent dateEvent;

  const DeleteDateEvent(this.dateEvent);

  @override
  List<Object> get props => [dateEvent];

  @override
  String toString() => 'DeleteDateEvent { deleteDateEvent: $dateEvent for parentId: ${dateEvent.parentId} }';
}

class DateEventsUpdated extends DateEventsEvent {
  final List<DateEvent> dateEvents;
  
  const DateEventsUpdated(this.dateEvents);

  @override
  List<Object> get props => [dateEvents];
}

class ShiftDateEventsUpdated extends DateEventsEvent {
  final List<DateEvent> dateEvents;
  
  const ShiftDateEventsUpdated(this.dateEvents);

  @override
  List<Object> get props => [dateEvents];
}

