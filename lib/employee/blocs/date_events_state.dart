import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

abstract class DateEventsState extends Equatable {
  const DateEventsState();

  @override
  List<Object> get props => [];
}

class DateEventsLoading extends DateEventsState {}

class DateEventsLoaded extends DateEventsState {
  final List<DateEvent> dateEvents;

  const DateEventsLoaded([this.dateEvents = const[]]);

  @override
  List<Object> get props => [dateEvents];

  @override
  String toString() => 'DateEvents {dateEvents $dateEvents }';
}

class ShiftDateEventsLoaded extends DateEventsState {
  final List<DateEvent> dateEvents;

  const ShiftDateEventsLoaded([this.dateEvents = const[]]);

  @override
  List<Object> get props => [dateEvents];

  @override
  String toString() => 'DateEvents {dateEvents $dateEvents }';
}

// class DateEventsForGivenEmployeeLoaded extends DateEventsState {
//   final List<DateEvent> dateEvents;
//   final String employeeId;

//   const DateEventsForGivenEmployeeLoaded([this.dateEvents = const[], this.employeeId]);

//   @override
//   List<Object> get props => [dateEvents, employeeId];

//   @override
//   String toString() => 'DateEvents { dateEvents $dateEvents for employeeId: $employeeId }';
// }

class DateEventsNotLoaded extends DateEventsState {}