import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:date_events_repository/date_events_repository.dart';

abstract class ShiftsState extends Equatable {
  const ShiftsState();

  @override
  List<Object> get props => [];
}

class ShiftsLoading extends ShiftsState {}

class LoadedShifts extends ShiftsState {
  final List<Shift> shifts;

  const LoadedShifts([this.shifts = const []]);

  @override
  List<Object> get props => [shifts];

  @override
  String toString() => 'ShiftsLoaded {shifts: $shifts }';
}

class ShiftsNotLoaded extends ShiftsState {}

//! the danger may be when I am creating a new shift after editing one
//! that first the old data will get loaded and later the "new"
class ShiftCreatedOrEdited extends ShiftsState {
  final String currentDesignation;
  final List<String> designations;
  final Employee currentEmployee;
  final List<Employee> availableEmployees;
  final String defaultEmployeeName = 'open';
  final String description;
  final String shiftStart;
  final String shiftEnd;
  final DateTime shiftDate;
  final String reason = 'shift';

  const ShiftCreatedOrEdited({
    @required this.designations,
    @required this.currentDesignation,
    this.currentEmployee,
    this.availableEmployees,
    this.description,
    this.shiftStart,
    this.shiftEnd,
    this.shiftDate,
  });


  @override
  List<Object> get props => [
        currentDesignation,
        designations,
        currentEmployee,
        availableEmployees,
        defaultEmployeeName,
        description,
        shiftStart,
        shiftEnd,
        shiftDate,
        reason,
      ];

  @override
  String toString() =>
      'New Shift Created { defaultDesignation: $currentDesignation, defaultEmployee: $currentEmployee, designation: $designations, availableEmployees: $availableEmployees, defaultEmployeeName: $defaultEmployeeName, description: $description, shiftStart: $shiftStart, shiftEnd: $shiftEnd, shiftDate: $shiftDate, reason: $reason }';

  ShiftCreatedOrEdited copyWith({
    String currentDesignation,
    List<String> designations,
    Employee currentEmployee,
    List<Employee> availableEmployees,
    String description,
    String shiftStart,
    String shiftEnd,
    DateTime shiftDate,
  }) {
    return ShiftCreatedOrEdited(
      currentDesignation: currentDesignation ?? this.currentDesignation,
      designations: designations ?? this.designations,
      currentEmployee: currentEmployee ?? this.currentEmployee,
      availableEmployees: availableEmployees ?? this.availableEmployees,
      description: description ?? this.description,
      shiftStart: shiftStart ?? this.shiftStart,
      shiftEnd: shiftEnd ?? this.shiftEnd,
      shiftDate: shiftDate ?? this.shiftDate,
    );
  }
}

class FetchedAvailableEmployeesForDesignation extends ShiftsState {
  final List<Employee> availableEmployees;

  FetchedAvailableEmployeesForDesignation({@required this.availableEmployees});

  @override
  List<Object> get props => [availableEmployees];

  @override
  String toString() =>
      'AvailableEmployeesForDesignationFetched: { $availableEmployees }';

}
