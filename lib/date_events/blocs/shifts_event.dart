import 'package:date_events_repository/date_events_repository.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ShiftsEvent extends Equatable {
  const ShiftsEvent();

  @override
  List<Object> get props => [];
}

class ShiftsLoaded extends ShiftsEvent {}

// class AddShift extends ShiftsEvent {
//   final Shift shift;

//   const AddShift(this.shift);

//   @override
//   List<Object> get props => [shift];

//   @override
//   String toString() => 'AddShift(shift: $shift)';
// }

// class UpdateShift extends ShiftsEvent {
//   final Shift updatedShift;

//   const UpdateShift(this.updatedShift);

//   @override
//   List<Object> get props => [updatedShift];

//   @override
//   String toString() => 'UpdateShift { updatedShift: $updatedShift }';
// }

// class RedoShift extends ShiftsEvent {
//   final Shift redoneShift;

//   const RedoShift(this.redoneShift);

//   @override
//   List<Object> get props => [redoneShift];

//   @override
//   String toString() => 'RedoShift { redoneShift: $redoneShift }';
// }

class ShiftDeleted extends ShiftsEvent {
  final Shift shift;

  const ShiftDeleted(this.shift);

  @override
  List<Object> get props => [shift];

  @override
  String toString() => 'ShiftDeleted { shift: $shift }';
}

// class ShiftsUpdated extends ShiftsEvent {
//   final List<Shift> shifts;

//   const ShiftsUpdated(this.shifts);

//   @override
//   List<Object> get props => [shifts];

//   @override
//   String toString() {
//     return 'ShiftsUpdated: shifts: $shifts }';
//   }
// }

class NewShiftCreated extends ShiftsEvent {
  final DateTime shiftDate;

  NewShiftCreated({@required this.shiftDate});

  @override
  List<Object> get props => [shiftDate];

  @override
  String toString() {
    return 'NewShiftCreated: { shiftDate: $shiftDate }';
  }
}

class NewShiftEmployeeSpecificCreated extends ShiftsEvent {
  final DateTime shiftDate;
  final Employee employee;

  NewShiftEmployeeSpecificCreated({
    this.shiftDate,
    this.employee,
  });

  @override
  List<Object> get props => [shiftDate, employee];

  @override
  String toString() {
    return 'NewShiftEmployeeSpecificCreated: { shiftDate: $shiftDate, employee: $employee } ';
  }
}

class NewDayOffCreated extends ShiftsEvent {
  final DateTime dayOffDate;
  final String employeeId;
  final String employeeName;

  NewDayOffCreated({
    this.dayOffDate,
    this.employeeId,
    this.employeeName
  });

  @override
  List<Object> get props => [dayOffDate, employeeId, employeeName];

  @override
  String toString() {
  return 'NewDayOffCreated: dayOffDate: $dayOffDate, employee: $employeeId, employeeName: $employeeName } ';
   }
}

class DayOffEdited extends ShiftsEvent {
  final DateTime dayOffDate;
  final String employeeId;
  final String id;
  final String description;
  final String reason = 'Day Off';

  DayOffEdited({this.dayOffDate, this.employeeId, this.id, this.description});

  @override
  List<Object> get props => [dayOffDate, employeeId, id, description];

  @override
  String toString() {
    return 'DayOffEdited(dayOffDate: $dayOffDate, employeeId: $employeeId, id: $id, description: $description, reason: $reason)';
  }

  DayOffEdited copyWith({
    DateTime dayOffDate,
    Employee employeeId,
    String id,
    String description,
    String reason,
  }) {
    return DayOffEdited(
      dayOffDate: dayOffDate ?? this.dayOffDate,
      employeeId: employeeId ?? this.employeeId,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }
}

class ShiftEdited extends ShiftsEvent {
  final Employee currentEmployee;
  final String currentDesignation;
  final DateTime shiftDate;
  final String description;
  final String shiftStart;
  final String shiftEnd;
  final String id;
  final Employee oldEmployee;

  ShiftEdited({
    @required this.currentEmployee,
    @required this.description,
    @required this.shiftStart,
    @required this.shiftEnd,
    @required this.currentDesignation,
    @required this.shiftDate,
    this.id,
    this.oldEmployee,
  });

  @override
  List<Object> get props => [
        currentEmployee,
        description,
        shiftStart,
        shiftEnd,
        currentDesignation,
        shiftDate,
        id,
        oldEmployee,
      ];

  @override
  String toString() {
    return 'ShiftEdited: { currentEmployee: $currentEmployee, description: $description, shiftStart: $shiftStart, shiftEnd: $shiftEnd, currentDesignation: $currentDesignation, shiftDate: $shiftDate, id: $id, oldEmployee: $oldEmployee }';
  }
}

class AvailableEmployeesForDesignationFetched extends ShiftsEvent {
  final Employee currentEmployee;
  final String currentDesignation;
  final DateTime shiftDate;

  AvailableEmployeesForDesignationFetched({
    @required this.currentEmployee,
    @required this.currentDesignation,
    @required this.shiftDate,
  });

  @override
  List<Object> get props => [
        currentEmployee,
        currentDesignation,
        shiftDate,
      ];

  @override
  String toString() {
    return 'AvailableEmployeesForDesignationFetched: { currentEmployee: $currentEmployee, currentDesignation: $currentDesignation, shiftDate: $shiftDate } ';
  }
}

class ShiftDataPushed extends ShiftsEvent {
  final Employee currentEmployee;
  final String currentDesignation;
  final DateTime shiftDate;
  final List<Employee> availableEmployees;
  final String shiftStart;
  final String shiftEnd;
  final String description;
  final String id;
  final Employee oldEmployee;

  ShiftDataPushed({
    @required this.currentEmployee,
    @required this.currentDesignation,
    @required this.shiftDate,
    @required this.availableEmployees,
    this.shiftStart,
    this.shiftEnd,
    this.description,
    this.id,
    this.oldEmployee,
  });

  @override
  List<Object> get props => [
        currentEmployee,
        currentDesignation,
        shiftDate,
        availableEmployees,
        shiftStart,
        shiftEnd,
        description,
        id,
        oldEmployee,
      ];

  @override
  String toString() {
    return 'ShiftDataPushed: { currentEmployee: $currentEmployee, currentDesignation: $currentDesignation, shiftDate: $shiftDate, availableEmployees: $availableEmployees, shiftStart: $shiftStart, shiftEnd: $shiftEnd, description: $description, id: $id, oldEmployee: $oldEmployee }';
  }
}

class UploadDateEventAdded extends ShiftsEvent {
  final DateEvent dateEvent;

  UploadDateEventAdded({@required this.dateEvent});

  @override
  List<Object> get props => [dateEvent];

  @override
  String toString() => 'UploadDateEventAdded(dateEvent: $dateEvent)';
}

class ShiftsDescriptionChanged extends ShiftsEvent {
  final String description;

  ShiftsDescriptionChanged({this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() {
    return 'ShiftsDescriptionChanged: { $description }';
  }
}

class DayOffDescriptionChanged extends ShiftsEvent {
  final String description;

  DayOffDescriptionChanged({this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() {
    return 'DayOffDescriptionChanged: { $description }';
  }
}

class ShiftsEmployeeChanged extends ShiftsEvent {
  final Employee employee;

  ShiftsEmployeeChanged({this.employee});

  @override
  List<Object> get props => [employee];

  @override
  String toString() {
    return 'ShiftsCurrentEmployeeChanged: { $employee }';
  }
}

class ShiftsDesignationChanged extends ShiftsEvent {
  final String designation;

  ShiftsDesignationChanged({this.designation});

  @override
  List<Object> get props => [designation];

  @override
  String toString() {
    return 'ShiftsDesignationChanged: { $designation }';
  }
}

class ShiftsStartTimeChanged extends ShiftsEvent {
  final String shiftStart;

  ShiftsStartTimeChanged({this.shiftStart});

  @override
  List<Object> get props => [shiftStart];

  @override
  String toString() {
    return 'ShiftsStartTimeChanged: { $shiftStart }';
  }
}

class ShiftsEndTimeChanged extends ShiftsEvent {
  final String shiftEnd;

  ShiftsEndTimeChanged({this.shiftEnd});

  @override
  List<Object> get props => [shiftEnd];

  @override
  String toString() {
    return 'ShiftsEndTimeChanged: { $shiftEnd }';
  }
}
