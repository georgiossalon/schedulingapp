import 'package:date_events_repository/date_events_repository.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

@immutable class ShiftCreatedOrEdited extends ShiftsState {
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
  final String id;
  final Employee oldEmployee;
  final bool isShiftsView;

  const ShiftCreatedOrEdited({
    @required this.designations,
    @required this.currentDesignation,
    this.currentEmployee,
    this.availableEmployees,
    this.description,
    this.shiftStart,
    this.shiftEnd,
    this.shiftDate,
    this.id,
    this.oldEmployee,
    @required this.isShiftsView,
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
        id,
        oldEmployee,
        isShiftsView,
      ];

  @override
  String toString() =>
      'New Shift Created { defaultDesignation: $currentDesignation, defaultEmployee: $currentEmployee, designation: $designations, availableEmployees: $availableEmployees, defaultEmployeeName: $defaultEmployeeName, description: $description, shiftStart: $shiftStart, shiftEnd: $shiftEnd, shiftDate: $shiftDate, reason: $reason, id: $id, oldEmployee: $oldEmployee, isShiftsView: $isShiftsView }';

  ShiftCreatedOrEdited copyWith({
    String currentDesignation,
    List<String> designations,
    Employee currentEmployee,
    List<Employee> availableEmployees,
    String description,
    String shiftStart,
    String shiftEnd,
    DateTime shiftDate,
    String id,
    Employee oldEmployee,
    bool isShiftsView,
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
      id: id ?? this.id,
      oldEmployee: oldEmployee ?? this.oldEmployee,
      isShiftsView: isShiftsView ?? this.isShiftsView,
    );
  }
}

// class CreatedDayOff extends ShiftsState {
//   final DateTime dayOffDate;
//   final String employeeId;

//   CreatedDayOff({this.dayOffDate, this.employeeId});

//   @override
//   List<Object> get props => [dayOffDate, employeeId];

//   @override
//   String toString() {
//     return 'CreatedDayOff(dayOffDate: $dayOffDate, employeeId: $employeeId)';
//   }

//   CreatedDayOff copyWith({
//     DateTime dayOffDate,
//     String employeeId,
//   }) {
//     return CreatedDayOff(
//       dayOffDate: dayOffDate ?? this.dayOffDate,
//       employeeId: employeeId ?? this.employeeId,
//     );
//   }
// }

class CreatedOrEditedDayOff extends ShiftsState {
  final DateTime dayOffDate;
  final String id;
  final String employeeId;
  final String employeeName;
  final String description;
  final String reason = 'Day Off';

  CreatedOrEditedDayOff(
      {this.dayOffDate,
      this.id,
      this.employeeId,
      this.employeeName,
      this.description});

  @override
  List<Object> get props =>
      [dayOffDate, id, employeeId, employeeName, description];

  @override
  String toString() {
    return 'EditedDayOff(dayOffDate: $dayOffDate, id: $id, employeeId: $employeeId, employeeName: $employeeName, description: $description)';
  }

  CreatedOrEditedDayOff copyWith({
    DateTime dayOffDate,
    String id,
    String employeeId,
    String employeeName,
    String description,
  }) {
    return CreatedOrEditedDayOff(
      dayOffDate: dayOffDate ?? this.dayOffDate,
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      description: description ?? this.description,
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
