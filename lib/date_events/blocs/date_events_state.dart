import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:date_events_repository/date_events_repository.dart';

abstract class DateEventsState extends Equatable {
  const DateEventsState();

  @override
  List<Object> get props => [];
}

class DateEventsLoading extends DateEventsState {}

class DateEventsLoaded extends DateEventsState {
  final List<DateEvent> dateEvents;

  const DateEventsLoaded([this.dateEvents = const []]);

  @override
  List<Object> get props => [dateEvents];

  @override
  String toString() => 'DateEvents {dateEvents $dateEvents }';
}

class ShiftDateEventsLoaded extends DateEventsState {
  final List<DateEvent> dateEvents;

  const ShiftDateEventsLoaded([this.dateEvents = const []]);

  @override
  List<Object> get props => [dateEvents];

  @override
  String toString() => 'DateEvents {dateEvents $dateEvents }';
}

class DateEventsNotLoaded extends DateEventsState {}

class ShiftUpdated extends DateEventsState {
  final String currentDesignation;
  final Employee currentEmployee;
  final List<Employee> availableEmployeesForThisDesignation;
  final List<String> designations;

  const ShiftUpdated(
    this.currentDesignation,
    this.currentEmployee,
    //todo: merge the current employee with the employees List into one
    this.availableEmployeesForThisDesignation,
    this.designations,
  );

  @override
  List<Object> get props => [
        currentDesignation,
        currentEmployee,
        availableEmployeesForThisDesignation,
        designations,
      ];

  @override
  String toString() => 
    'ShiftUpdated : { currentDesignation: $currentDesignation, currentEmployee: $currentEmployee, availableEmployeesForThisDesignation: $availableEmployeesForThisDesignation, designations: $designations' ;
}

class DesignationsForShiftLoaded extends DateEventsState {}

class DesignationsForShiftUpdated extends DateEventsState {
  final List<String> designations;

  const DesignationsForShiftUpdated(this.designations);

  @override
  List<Object> get props => [designations];

  @override
  String toString() => 'Designations for Shift Updated: $designations';
}
